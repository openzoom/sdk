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
package org.openzoom.components.flex
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.core.UIComponent;
import mx.events.ResizeEvent;

import org.openzoom.components.common.controllers.KeyboardNavigationController;
import org.openzoom.components.common.controllers.MouseNavigationController;
import org.openzoom.components.common.controllers.ViewTransformationController;
import org.openzoom.core.IMultiScaleScene;
import org.openzoom.core.INormalizedViewport;
import org.openzoom.core.IViewportController;
import org.openzoom.core.MultiScaleScene;
import org.openzoom.core.NormalizedViewport;
import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.MultiScaleImageDescriptorFactory;
import org.openzoom.net.TileLoader;
import org.openzoom.renderers.MultiScaleImageRenderer;

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
    
    private var keyboardNavigationController : KeyboardNavigationController
    private var mouseNavigationController : MouseNavigationController
    private var transformationController : ViewTransformationController
    
    private var loader : TileLoader
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
    
    public function get source() : Object
    {
    	return _source
    }
    
    public function set source( value : Object ) : void
    {    	
    	if( _source )
    	{
    		_source = null
        
            // TODO
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
    	}
    	else
    	{
    		throw new ArgumentError("MultiScaleImage source must be either " + 
    				                "a URL or a IMultiScaleImageDescriptor")
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
    
    private var _viewport : NormalizedViewport;
    
    [Bindable(event="viewportChanged")]
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
    
    //----------------------------------
    //  minZoom
    //----------------------------------
    
    public function get minZoom() : Number
    {
        return viewport.minZoom
    }
    
    public function set minZoom( value : Number ) : void
    {
        viewport.minZoom = value
    }
    
    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    public function get maxZoom() : Number
    {
        return viewport.maxZoom
    }
    
    public function set maxZoom( value : Number ) : void
    {
        viewport.maxZoom = value
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
        addEventListener( ResizeEvent.RESIZE, resizeHandler )
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
        _viewport = new NormalizedViewport( DEFAULT_VIEWPORT_WIDTH,
                                            DEFAULT_VIEWPORT_HEIGHT,
                                            scene )
       dispatchEvent( new Event("viewportChanged" ))
    }
    
    private function createScene() : void
    {
        _scene = new MultiScaleScene( DEFAULT_SCENE_DIMENSION, DEFAULT_SCENE_DIMENSION )
        addChild( _scene )
    }
    
    private function createLoader() : void
    {
    	loader = new TileLoader()
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
    
    private function resizeHandler( event : ResizeEvent ) : void
    {
        mouseCatcher.width = width
        mouseCatcher.height = height
        
        contentMask.width = width
        contentMask.height = height
        
        _viewport.setSize( width, height )	
    }
}

}