////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package
{

import flash.display.Sprite
import flash.display.StageAlign
import flash.display.StageScaleMode
import flash.events.Event
import flash.system.Security
import flash.utils.setTimeout

import org.openzoom.flash.components.MultiScaleImage
import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor
import org.openzoom.flash.utils.ExternalMouseWheel
import org.openzoom.flash.viewport.constraints.CompositeConstraint
import org.openzoom.flash.viewport.constraints.MappingConstraint
import org.openzoom.flash.viewport.constraints.ScaleConstraint
import org.openzoom.flash.viewport.constraints.ZoomConstraint
import org.openzoom.flash.viewport.controllers.ContextMenuController
import org.openzoom.flash.viewport.controllers.KeyboardController
import org.openzoom.flash.viewport.controllers.MouseController
import org.openzoom.flash.viewport.transformers.TweenerTransformer


[SWF(width="960", height="600", frameRate="60", backgroundColor="#222222")]
/**
 * Sample for building mapping applications with OpenZoom. The goal would be
 * to encapsulate all the logic and thinking that happens here inside a completely
 * new component (called Map) for example, possibly without relying on MultiScaleImage.
 */
public class MappingFlash extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MappingFlash()
    {
        // Cross-domain security
        Security.loadPolicyFile("http://tile.openstreetmap.org/crossdomain.xml")
        
        // Standard stage setup
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.align = StageAlign.TOP_LEFT
        stage.addEventListener(Event.RESIZE, stage_resizeHandler)

        // Enable mouse wheel support on Mac OS
        // without external JavaScript dependency
        ExternalMouseWheel.initialize(stage)

        // Map setup
        map = new MultiScaleImage()

        // Controllers handle user input
        var mouseController:MouseController = new MouseController()
        
        // Because we always zoom to power of 2 scale we need
        // the following constraints for the mousewheel zooming.
        mouseController.minMouseWheelZoomInFactor = 2
        mouseController.minMouseWheelZoomOutFactor = 0.5

        // This is for you, Tom =)
        mouseController.smoothPanning = false
        // Basically it does the following:
        // viewport.panBy(x, y, immediately = true)
        //                            ^
        //                       no animation

        // Navigation through keyboard and context menu
        var keyboardController:KeyboardController = new KeyboardController()
        var contextMenuController:ContextMenuController = new ContextMenuController()

        map.controllers = [mouseController,
                           keyboardController,
                           contextMenuController]

        // Viewport animation (this is what makes the file 15K bigger,
        // implementing a more light-weight tweening engine and we have
        // an OpenZoom map engine of 20K, not bad, ey?! +)
        map.transformer = new TweenerTransformer()

        // Constraints (due to a bug, these have to be applied after the transformer)
        scaleConstraint = new ScaleConstraint()

        // Zoom is a relative value, 0.5 means the map will never be smaller
        // than half of the viewport, with automatic consideration of the aspect ratio.
        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
            zoomConstraint.minZoom = 0.5

        // This is the heart of the logic for creating mapping applications
        // with OpenZoom. This constraint makes sure that the map will never
        // render at a scale that is not a power of 2. This way, we'll always
        // have cristal crisp rendering of maps like Google Maps, Yahoo Maps,
        // or from the OSM project.
        var mappingConstraint:MappingConstraint = new MappingConstraint()

        // Since the architecture I designed only allows for one constraint,
        // we can use the composite design pattern for grouping several constraints
        // with a the CompositeConstraint class.
        var constraint:CompositeConstraint = new CompositeConstraint()
        constraint.constraints = [ scaleConstraint,
                                   zoomConstraint,
                                   mappingConstraint ]

        map.constraint = constraint


        // Listen for the complete event in order to set the maximum scale
        // the map can reach. We can only set this once we know the size of the
        // loaded image.
        map.addEventListener(Event.COMPLETE, map_completeHandler)
        
        // Avoid trouble with OSM
        setTimeout(initializeMap, 1000)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var map:MultiScaleImage
    
    // We're keeping a reference to the scale constraints
    // since the maxScale is only set after the image has loaded
    private var scaleConstraint:ScaleConstraint

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function initializeMap():void
    {
        // Alright, let's load the map...
        map.source = "openstreetmap.xml"

        // Add the map to the display list
        // and layout the application
        addChild(map)
        layout()
    }

    private function stage_resizeHandler(event:Event):void
    {
        layout()
    }

    private function map_completeHandler(event:Event):void
    {
        var descriptor:IMultiScaleImageDescriptor = map.source as IMultiScaleImageDescriptor

        if (descriptor)
        {
        	// This is where we're ensuring that the user cannot zoom in more
        	// than the original size of the highest resolution of the map.
        	// Through the descriptor we find the size of the image (for OSM this
        	// would be 67108864 pixels) and divide it by the size of the underlying
        	// Sprite object (scene) for rendering which through empiric tests
        	// has been set to 16384 pixels. In this case this gives us a maximum
        	// scale factor (scaleX and scaleY) of 4096 (2^12) for the scene sprite.
        	// After a lot of testing and tearing out hair I found that the best
        	// scaling happens when the scene has a size that is a power of 2.
        	// In retrospect this makes kind of sense considering the structure
        	// of integers in computers.
            var maxScale:Number = descriptor.width / map.sceneWidth
            scaleConstraint.maxScale = maxScale
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Layout
    //
    //--------------------------------------------------------------------------

    private function layout():void
    {
    	// Making sure the map fits the
    	// entire available screen real estate.
        if (map)
        {
            map.x = map.y = 0
            map.width = stage.stageWidth
            map.height = stage.stageHeight
        }
    }
}

}