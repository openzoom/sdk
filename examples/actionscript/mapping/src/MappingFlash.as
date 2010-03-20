////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.system.Security;
import flash.utils.setTimeout;

import org.openzoom.flash.components.MultiScaleImage;
import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.openstreetmap.OpenStreetMapDescriptor;
import org.openzoom.flash.utils.ExternalMouseWheel;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.MapConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;

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

        // Ensure the scene is centered once we zoom out
        var centerConstraint:CenterConstraint = new CenterConstraint()

        // Zoom is a relative value, 0.5 means the map will never be smaller
        // than half of the viewport, with automatic consideration of the aspect ratio.
        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
            zoomConstraint.minZoom = 0.5

        // This is the heart of the logic for creating mapping applications
        // with OpenZoom. This constraint makes sure that the map will never
        // render at a scale that is not a power of 2. This way, we'll always
        // have cristal crisp rendering of maps like Google Maps, Yahoo Maps,
        // or from the OSM project.
        var mappingConstraint:MapConstraint = new MapConstraint()

        // Since the architecture I designed only allows for one constraint,
        // we can use the composite design pattern for grouping several constraints
        // with a the CompositeConstraint class.
        var constraint:CompositeConstraint = new CompositeConstraint()
        constraint.constraints = [scaleConstraint,
                                  zoomConstraint,
                                  centerConstraint,
                                  mappingConstraint]

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
        map.source = new OpenStreetMapDescriptor()
//        map.source = new VirtualEarthDescriptor()

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