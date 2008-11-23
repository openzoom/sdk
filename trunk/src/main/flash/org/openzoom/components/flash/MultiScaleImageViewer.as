////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.components.flash
{

import caurina.transitions.Tweener;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

import org.openzoom.components.common.controllers.KeyboardNavigationController;
import org.openzoom.components.common.controllers.MouseNavigationController;
import org.openzoom.components.common.controllers.ViewTransformationController;
import org.openzoom.core.IMultiScaleScene;
import org.openzoom.core.INormalizedViewport;
import org.openzoom.core.IViewportController;
import org.openzoom.core.MultiScaleScene;
import org.openzoom.core.NormalizedViewport;
import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.net.TileLoader;
import org.openzoom.renderers.MultiScaleImageRenderer;
import org.openzoom.utils.math.clamp;

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
   
    private static const DEFAULT_MIN_ZOOM        : Number = 0.25
    private static const DEFAULT_MAX_ZOOM        : Number = 10000
    
    private static const DEFAULT_DIMENSION       : Number = 20000
    private static const DEFAULT_SCENE_WIDTH     : Number = 40000
    private static const DEFAULT_SCENE_HEIGHT    : Number = 40000
    
    private static const DEFAULT_VIEWPORT_WIDTH  : Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT : Number = 600
    
    private static const ZOOM_IN_FACTOR          : Number = 2.0
    private static const ZOOM_OUT_FACTOR         : Number = 0.3
    private static const TRANSLATION_FACTOR      : Number = 0.1
    
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
        createViewport( scene )
        viewport.minZoom = DEFAULT_MIN_ZOOM
        viewport.maxZoom = DEFAULT_MAX_ZOOM
        
        var loader : TileLoader = new TileLoader()
        
        for( var i : int = 0; i < 5; i++ )
        {
            for( var j : int = 0; j < 5; j++ )
            {
            	var scale : Number = clamp( Math.random(), 0.05, 0.25 )
		        var image : MultiScaleImageRenderer =
		                      createImage( descriptor.clone(), loader,
		                                   descriptor.width * scale, descriptor.height * scale )
		                                   
//		        image.x = i * (image.width * 1.1)
//		        image.y = j * (image.height * 1.1)

                image.x = Math.random() * DEFAULT_SCENE_WIDTH * 0.75
                image.y = Math.random() * DEFAULT_SCENE_HEIGHT * 0.75
		        _scene.addChild( image )
            }
        }
        
        // controllers
        createControllers( _scene )
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
    
    private var keyboardNavigationController : KeyboardNavigationController
    private var mouseNavigationController : MouseNavigationController
    private var transformationController : ViewTransformationController
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : NormalizedViewport
    
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
    //  Overridden Properties: DisplayObject
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
    	for( var i : int = 1; i < _scene.numChildren; i++ )
        {
            var renderer : DisplayObject = _scene.getChildAt( i )
            var scale : Number = 1// clamp( Math.random() * 2, 0.8, 2 )
            Tweener.addTween(
                              renderer,
                              {
                                  x: Math.random() * DEFAULT_SCENE_WIDTH * 0.95,
                                  y: Math.random() * DEFAULT_SCENE_HEIGHT * 0.95,
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
    
    private function createViewport( scene : IMultiScaleScene ) : void
    {
        _viewport = new NormalizedViewport( DEFAULT_VIEWPORT_WIDTH,
                                            DEFAULT_VIEWPORT_HEIGHT,
                                            scene )
    }
    
    private function createScene() : void
    {
        _scene = new MultiScaleScene( DEFAULT_SCENE_WIDTH,
                                      DEFAULT_SCENE_HEIGHT,
                                      0x333333, 0.1 )
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
                                  loader : TileLoader,
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
  
    private function createControllers( view : DisplayObject ) : void
    {   
        mouseNavigationController = new MouseNavigationController()
        keyboardNavigationController = new KeyboardNavigationController()

        addController( mouseNavigationController )
        addController( keyboardNavigationController )
        
        transformationController = new ViewTransformationController()
        transformationController.viewport = viewport
        transformationController.view = view
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