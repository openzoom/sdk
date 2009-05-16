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
package org.openzoom.flash.renderers.images
{

import flash.display.Graphics;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;

import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * Manages the rendering of all image pyramid renderers on stage.
 */
public class ImagePyramidRenderManager
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const FRAMES_PER_SECOND:Number = 20
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function ImagePyramidRenderManager(scene:IMultiScaleScene,
                                              viewport:INormalizedViewport,
                                              loader:INetworkQueue)
    {
    	this.scene = scene
    	
        this.viewport = viewport
        this.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                       viewport_transformUpdateHandler,
                                       false, 0, true)

        this.loader = loader

        timer = new Timer(1000 / FRAMES_PER_SECOND)
        timer.addEventListener(TimerEvent.TIMER,
                               timer_timerHandler,
                               false, 0, true)
        timer.start()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var renderers:Array /* of ImagePyramidRenderer */ = []

    private var timer:Timer
    private var viewport:INormalizedViewport
    private var scene:IMultiScaleScene
    private var loader:INetworkQueue

    private var invalidateDisplayListFlag:Boolean = false
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function updateDisplayList(renderer:ImagePyramidRenderer):void
    {
    	var viewport:INormalizedViewport = renderer.viewport
    	var scene:IReadonlyMultiScaleScene = renderer.scene
    	
    	// Is renderer on scene?
        if (!viewport)
            return
        
        // Compute normalized scene bounds of renderer
        var sceneBounds:Rectangle = renderer.getBounds(scene.targetCoordinateSpace)
            sceneBounds.x /= scene.sceneWidth
            sceneBounds.y /= scene.sceneHeight
            sceneBounds.width /= scene.sceneWidth
            sceneBounds.height /= scene.sceneHeight

        // Visibility test
        var visible:Boolean = viewport.intersects(sceneBounds)
        
        if (!visible)
            return

        // Get viewport bounds (normalized)
        var viewportBounds:Rectangle = viewport.getBounds()
        
        // Compute normalized visible bounds in renderer coordinate system
        var localBounds:Rectangle = sceneBounds.intersection(viewportBounds)
        localBounds.offset(-sceneBounds.x, -sceneBounds.y)
        localBounds.x /= sceneBounds.width
        localBounds.y /= sceneBounds.height
        localBounds.width /= sceneBounds.width
        localBounds.height /= sceneBounds.height
        
        
        // Determine optimal level
        var descriptor:IImagePyramidDescriptor = renderer.source
        var stageBounds:Rectangle = renderer.getBounds(renderer.stage)
        var optimalLevel:IImagePyramidLevel = descriptor.getLevelForSize(stageBounds.width,
                                                                         stageBounds.height)
        trace(optimalLevel)
        
        // Render image pyramid from bottom up
        var fromLevel:int = 0
        var toLevel:int = optimalLevel.index
    
        for (var level:int = fromLevel; level <= toLevel; level++)
        {
//        var g:Graphics = renderer.graphics
//        g.clear()
//        g.beginFill(0xFF0000)
//        g.drawRect(0, 0, renderer.width, renderer.height)
//        g.endFill()
//        
//        g.beginFill(0x0088FF)
//        g.drawRect(localBounds.x * renderer.width + 10,
//                   localBounds.y * renderer.height + 10,
//                   localBounds.width * renderer.width - 20,
//                   localBounds.height * renderer.height - 20)
//        g.endFill()
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Validation/Invalidation
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function timer_timerHandler(event:TimerEvent):void
    {
        // Rendering loop
        validateDisplayList()
    }
    
    /**
     * @private
     */
    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
        invalidateDisplayList()
    }

    /**
     * @private
     */
    public function invalidateDisplayList():void
    {
        if (!invalidateDisplayListFlag)
            invalidateDisplayListFlag = true
    }
    
    /**
     * @private
     */ 
    public function validateDisplayList():void
    {
        if (invalidateDisplayListFlag)
        {
            // TODO: Validate renderers from the transformation origin outwards
            for each (var renderer:ImagePyramidRenderer in renderers)
                updateDisplayList(renderer)
                
            // Mark as validated
            invalidateDisplayListFlag = false
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Renderer management
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */ 
    public function addRenderer(renderer:ImagePyramidRenderer):ImagePyramidRenderer
    {
        if (renderers.indexOf(renderer) != -1)
            throw new ArgumentError("Renderer already added.")

        renderers.push(renderer)
        invalidateDisplayList()
        
        return renderer
    }

    /**
     * @private
     */
    public function removeRenderer(renderer:ImagePyramidRenderer):ImagePyramidRenderer
    {
        var index:int = renderers.indexOf(renderer)
        if (index == -1)
            throw new ArgumentError("Renderer does not exist.")

        renderers.splice(index, 1)
        
        return renderer
    }
}

}