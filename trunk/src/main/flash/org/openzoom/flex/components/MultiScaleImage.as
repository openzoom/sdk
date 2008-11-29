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
package org.openzoom.flex.components
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.core.UIComponent;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorFactory;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.LoadingQueue;
import org.openzoom.flash.renderers.MultiScaleImageRenderer;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.MultiScaleScene;
import org.openzoom.flash.viewport.AnimationViewport;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportContainer;
import org.openzoom.flash.viewport.IViewportController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.controllers.ViewTransformationController;

/**
 * Component for displaying a single multi-scale image. Inspired by the Microsoft
 * Silverlight Deep Zoom MultiScaleImage component. This implementation has built-in
 * support for Zoomify, Deep Zoom and OpenZoom images. Basic keyboard and mouse navigation
 * is included: «Batteries included» so to speak.
 */
public class MultiScaleImage extends UIComponent
{   
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
   
    private static const DEFAULT_MIN_ZOOM        : Number = 0.25
    private static const DEFAULT_MAX_ZOOM        : Number = 10000
    
    private static const DEFAULT_SCENE_DIMENSION : Number = 12000
    
    private static const DEFAULT_VIEWPORT_WIDTH  : Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT : Number = 600
    
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function MultiScaleImage()
	{
        createMouseCatcher()
        createScene()
        createViewport( scene )
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var mouseCatcher : Sprite
    private var contentMask : Shape
    
    private var sourceURL : String
    private var sourceLoader : URLLoader

    private var controllers : Array = []
    
    private var keyboardNavigationController : KeyboardController
    private var mouseNavigationController : MouseController
    private var transformationController : ViewTransformationController
    
    private var loader : LoadingQueue
    private var image : MultiScaleImageRenderer
    
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  source
    //----------------------------------
    
    private var _source : IMultiScaleImageDescriptor
    
    [Bindable(event="sourceChanged")]
    public function get source() : Object
    {
    	return _source
    }
    
    public function set source( value : Object ) : void
    {    	
    	if( _source )
    	{
    		_source = null
	        _scene.removeChildAt( 0 )
	        viewport.showAll()
    	}
    	
    	if( value is String )
    	{
    		if( sourceURL == String( value ))
                return
    		  
    		sourceURL = String( value )
    		sourceLoader = new URLLoader( new URLRequest( sourceURL ))
    		sourceLoader.addEventListener( Event.COMPLETE, sourceLoader_completeHandler )
    	}
    	else if( value is IMultiScaleImageDescriptor )
    	{
            _source = IMultiScaleImageDescriptor( value )
            dispatchEvent( new Event( "sourceChanged" ))
            
            addImage( _source )
    	}
    }
    
    //----------------------------------
    //  scene
    //----------------------------------
    
    private var _scene : MultiScaleScene
    
    public function get scene() : IMultiScaleScene
    {
        return _scene
    }
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : IViewportContainer
    
    [Bindable(event="viewportChanged")]
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
    
	//--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    override protected function createChildren() : void
    {
    	super.createChildren()
    	
        createContentMask()
        
        createLoader()
        createControllers( _scene )
    }
    
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function createMouseCatcher() : void
    {
        mouseCatcher = new Sprite()
        var g : Graphics = mouseCatcher.graphics
        g.beginFill( 0x000000, 0 )
        g.drawRect( 0, 0, 100, 100 )
        g.endFill()
        
        addChild( mouseCatcher )
    }
    
    private function createContentMask() : void
    {
        contentMask = new Shape()
        var g : Graphics = contentMask.graphics
        g.beginFill( 0xFF0000, 0 )
        g.drawRect( 0, 0, 100, 100 )
        g.endFill()
        
        addChild( contentMask )
        mask = contentMask
    }
    
    private function createViewport( scene : IMultiScaleScene ) : void
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
                                     
       dispatchEvent( new Event("viewportChanged" ))
    }
    
    private function viewport_transformStartHandler( event : ViewportEvent ) : void
    {
        trace("ViewportEvent.TRANSFORM_START")
    }
    
    private function viewport_transformUpdateHandler( event : ViewportEvent ) : void
    {
        trace("ViewportEvent.TRANSFORM_UPDATE")
        
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
        _scene = new MultiScaleScene( DEFAULT_SCENE_DIMENSION, DEFAULT_SCENE_DIMENSION )
        addChild( _scene )
    }
    
    private function createLoader() : void
    {
    	loader = new LoadingQueue()
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
  
    private function createControllers( view : DisplayObject ) : void
    {   
        mouseNavigationController = new MouseController()
        keyboardNavigationController = new KeyboardController()

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
    
    private function addImage( descriptor : IMultiScaleImageDescriptor ) : void
    {
        var aspectRatio : Number = descriptor.width / descriptor.height 
        var sceneWidth : Number
        var sceneHeight : Number
        
        if( aspectRatio > 1 )
        {
            sceneWidth = DEFAULT_SCENE_DIMENSION
            sceneHeight = DEFAULT_SCENE_DIMENSION / aspectRatio
        }
        else
        {
            sceneWidth = DEFAULT_SCENE_DIMENSION * aspectRatio
            sceneHeight = DEFAULT_SCENE_DIMENSION
        }
        
        _scene.setSize( sceneWidth, sceneHeight )
        
        image = createImage( descriptor, loader, sceneWidth, sceneHeight )
        
        _scene.addChild( image )
    }
    
	//--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function sourceLoader_completeHandler( event : Event ) : void
    {
    	if( !sourceLoader.data )
    	   return
    	
        var data : XML = new XML( sourceLoader.data )
        var factory : MultiScaleImageDescriptorFactory =
                        MultiScaleImageDescriptorFactory.getInstance()
        var descriptor : IMultiScaleImageDescriptor = factory.getDescriptor( sourceURL, data )
        
        _source = descriptor
        dispatchEvent( new Event( "sourceChanged" ))
        
        addImage( descriptor )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    override protected function updateDisplayList( unscaledWidth : Number,
                                                   unscaledHeight : Number ) : void
    {
        mouseCatcher.width = unscaledWidth
        mouseCatcher.height = unscaledHeight
        
        contentMask.width = unscaledWidth
        contentMask.height = unscaledHeight
        
        _viewport.setSize( unscaledWidth, unscaledHeight )  
    }
}

}