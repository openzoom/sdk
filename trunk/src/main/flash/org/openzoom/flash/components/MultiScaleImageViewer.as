////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.flash.components
{

import caurina.transitions.Tweener;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.LoadingQueue;
import org.openzoom.flash.renderers.MultiScaleImageRenderer;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.MultiScaleScene;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.viewport.AnimationViewport;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportContainer;
import org.openzoom.flash.viewport.IViewportController;
import org.openzoom.flash.viewport.NormalizedViewport;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.controllers.ViewTransformationController;

/**
 * Basic multi-scale image viewer.
 */
public class MultiScaleImageViewer extends Sprite
{   
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
   
    private static const DEFAULT_MIN_ZOOM               : Number = 0.25
    private static const DEFAULT_MAX_ZOOM               : Number = 10000
    
    private static const DEFAULT_SCENE_WIDTH            : Number = 24000
    private static const DEFAULT_SCENE_HEIGHT           : Number = 15000
    private static const DEFAULT_SCENE_BACKGROUND_COLOR : uint   = 0x333333
    private static const DEFAULT_SCENE_BACKGROUND_ALPHA : Number = 0.5
    
    private static const DEFAULT_VIEWPORT_WIDTH         : Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT        : Number = 600
    
    private static const ZOOM_IN_FACTOR                 : Number = 2.0
    private static const ZOOM_OUT_FACTOR                : Number = 0.3
    private static const TRANSLATION_FACTOR             : Number = 0.1
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleImageViewer( descriptor : IMultiScaleImageDescriptor )
    {
        this.descriptor = descriptor
        
        // children
        createChildren()
        
        // scene
        createScene()
        
        // viewport
//        createNormalizedViewport( scene )
        createAnimationViewport( scene )
        
        // TODO
//        viewport.constraint = null
//        viewport.minZoom = DEFAULT_MIN_ZOOM
//        viewport.maxZoom = DEFAULT_MAX_ZOOM
        
        var loadingQueue : LoadingQueue = new LoadingQueue()
        
        for( var i : int = 0; i < 10; i++ )
        {
            for( var j : int = 0; j < 5; j++ )
            {
            	var scale : Number = clamp( Math.random() / 2, 0.025, 0.25 )
		        var image : MultiScaleImageRenderer =
		                      createImage( descriptor.clone(),
		                                   loadingQueue,
		                                   descriptor.width * scale,
		                                   descriptor.height * scale )
		                      
                // Random layout             
                image.x = Math.random() * DEFAULT_SCENE_WIDTH  * 0.8
                image.y = Math.random() * DEFAULT_SCENE_HEIGHT * 0.8
                
                // Grid layout
//		        image.x = i * (image.width * 1.1)
//		        image.y = j * (image.height * 1.1)

		        _scene.addChild( image )
            }
        }
        
        // controllers
        createControllers()
        updateViewport()
    }
   
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var descriptor : IMultiScaleImageDescriptor

    private var mouseCatcher : Sprite
    private var controllers : Array = []
    
    private var keyboardController : KeyboardController
    private var mouseController : MouseController
    private var transformationController : ViewTransformationController
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : IViewportContainer
    
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
    
    //----------------------------------
    //  scene
    //----------------------------------    
    
    private var _scene : MultiScaleScene
    
    public function get scene() : IMultiScaleScene
    {
    	return _scene
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObject
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  width
    //----------------------------------    
  
    override public function get width() : Number
    {
        return mouseCatcher.width
    }
  
    override public function set width( value : Number ) : void
    {
        if( mouseCatcher.width == value )
            return
    
        mouseCatcher.width = value
        updateViewport()
    }
  
    //----------------------------------
    //  height
    //----------------------------------    
  
    override public function get height() : Number
    {
        return mouseCatcher.height
    }
  
    override public function set height( value : Number ) : void
    {
        if( mouseCatcher.height == value )
            return

        mouseCatcher.height = value
        updateViewport()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public function showAll() : void
    {
        viewport.showAll()
    }
    
    // zooming
    public function zoomIn() : void
    {
        var origin : Point = getMouseOrigin()
        viewport.zoomBy( ZOOM_IN_FACTOR, origin.x, origin.y )
    }
    
    public function zoomOut() : void
    {
        var origin : Point = getMouseOrigin()
        viewport.zoomBy( ZOOM_OUT_FACTOR, origin.x, origin.y )
    }
    
    // panning
    public function moveUp() : void
    {
        var dy : Number = viewport.height * TRANSLATION_FACTOR
        viewport.moveBy( 0, -dy )
    }
    
    public function moveDown() : void
    {
        var dy : Number = viewport.height * TRANSLATION_FACTOR
        viewport.moveBy( 0, dy )
    }
    
    public function moveLeft() : void
    {
        var dx : Number = viewport.width * TRANSLATION_FACTOR
        viewport.moveBy( -dx, 0 )
    }
    
    public function moveRight() : void
    {
        var dx : Number = viewport.width * TRANSLATION_FACTOR
        viewport.moveBy( dx, 0 )
    }
    
    public function setSize( width : Number, height : Number ) : void
    {
        if( this.width == width && this.height == height )
           return
        
        mouseCatcher.width = width
        mouseCatcher.height = height
        updateViewport()
    }
    
    public function shuffle() : void
    {
    	for( var i : int = 0; i < _scene.numChildren; i++ )
        {
            var renderer : DisplayObject = _scene.getChildAt( i )
            var scale : Number = 1
//          var scale : Number = clamp( Math.random() * 2, 0.8, 2 )
            Tweener.addTween(
                              renderer,
                              {
                                  x: Math.random() * DEFAULT_SCENE_WIDTH  * 0.90,
                                  y: Math.random() * DEFAULT_SCENE_HEIGHT * 0.90,
                                  width: renderer.width * scale,
                                  height: renderer.height * scale,
                                  time: 2
                              }
                            )
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Children
    //
    //--------------------------------------------------------------------------
    
    private function createNormalizedViewport( scene : IMultiScaleScene ) : void
    {
        _viewport = new NormalizedViewport( DEFAULT_VIEWPORT_WIDTH,
                                            DEFAULT_VIEWPORT_HEIGHT,
                                            scene )
        
        transformationController = new ViewTransformationController()
        transformationController.viewport = viewport
        transformationController.view = scene.targetCoordinateSpace
    }
    
    private function createAnimationViewport( scene : IMultiScaleScene ) : void
    {
        _viewport = new AnimationViewport( DEFAULT_VIEWPORT_WIDTH,
                                           DEFAULT_VIEWPORT_HEIGHT,
                                           scene )
        _viewport.addEventListener( ViewportEvent.TRANSFORM_START,
                                    viewport_transformStartHandler,
                                    false, 0, true ) 
        _viewport.addEventListener( ViewportEvent.TRANSFORM_UPDATE,
                                    viewport_transformUpdateHandler,
                                    false, 0, true )
        _viewport.addEventListener( ViewportEvent.TRANSFORM_END,
                                    viewport_transformEndHandler,
                                    false, 0, true ) 
    }
    
    private function viewport_transformStartHandler( event : ViewportEvent ) : void
    {
    	trace("ViewportEvent.TRANSFORM_START")
    }
    
    private function viewport_transformUpdateHandler( event : ViewportEvent ) : void
    {
        trace("ViewportEvent.TRANSFORM_UPDATE", viewport.zoom )
        // FIXME
        var v : INormalizedViewport = viewport
        var targetWidth   : Number =  v.viewportWidth / v.width
        var targetHeight  : Number =  v.viewportHeight / v.height
        var targetX       : Number = -v.x * targetWidth
        var targetY       : Number = -v.y * targetHeight
        
        var target : DisplayObject = scene.targetCoordinateSpace
            target.x = targetX
            target.y = targetY
            target.width = targetWidth
            target.height = targetHeight
    }
    
    private function viewport_transformEndHandler( event : ViewportEvent ) : void
    {
        trace("ViewportEvent.TRANSFORM_END")
    }
    
    private function createScene() : void
    {
        _scene = new MultiScaleScene( DEFAULT_SCENE_WIDTH,
                                      DEFAULT_SCENE_HEIGHT,
                                      DEFAULT_SCENE_BACKGROUND_COLOR,
                                      DEFAULT_SCENE_BACKGROUND_ALPHA )
        addChild( _scene )
    }
    
    private function createChildren() : void
    {
        mouseCatcher = createMouseCatcher()
        addChild( mouseCatcher )
    }
    
    private function createMouseCatcher() : Sprite
    {
        var mouseCatcher : Sprite = new Sprite()
        var g : Graphics = mouseCatcher.graphics
        g.beginFill( 0x000000, 0 )
        g.drawRect( 0, 0, 100, 100 )
        g.endFill()
        
        return mouseCatcher
    }
    
    private function createImage( descriptor : IMultiScaleImageDescriptor,
                                  loader : LoadingQueue,
                                  width : Number, height : Number ) : MultiScaleImageRenderer
    {
        var image : MultiScaleImageRenderer =
                        new MultiScaleImageRenderer( descriptor, loader, width, height )
        image.viewport = viewport
        return image
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Controllers
    //
    //--------------------------------------------------------------------------
  
    private function createControllers() : void
    {   
        mouseController = new MouseController()
        keyboardController = new KeyboardController()

        addController( mouseController )
        addController( keyboardController )
    }
  
    private function addController( controller : IViewportController ) : Boolean
    {
        if( controllers.indexOf( controller ) != -1 )
            return false
       
        controllers.push( controller )
        controller.viewport = viewport
        controller.view = this
        return true
    }
  
    private function removeController( controller : IViewportController ) : Boolean
    {
        if( controllers.indexOf( controller ) == -1 )
            return false
       
        controllers.splice( controllers.indexOf( controller ), 1 )
        controller.viewport = null
        controller.view = null
        return true
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function updateViewport() : void
    {
        _viewport.setSize( width, height )
    }
    
    private function getMouseOrigin() : Point
    {
        return new Point( mouseX / width, mouseY / height )
    }
}

}