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

import mx.core.UIComponent;

import org.openzoom.flash.net.TileLoader;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.MultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportContainer;
import org.openzoom.flash.viewport.IViewportController;
import org.openzoom.flash.viewport.NormalizedViewport;
import org.openzoom.flash.viewport.controllers.ViewTransformationController;

[DefaultProperty("children")]
public class MultiScaleContainer extends UIComponent
{   
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
   
    private static const DEFAULT_MIN_ZOOM               : Number = 0.25
    private static const DEFAULT_MAX_ZOOM               : Number = 10000
    
    private static const DEFAULT_SCENE_WIDTH            : Number = 24000
    private static const DEFAULT_SCENE_HEIGHT           : Number = 18000
    private static const DEFAULT_SCENE_BACKGROUND_COLOR : uint   = 0x333333
    private static const DEFAULT_SCENE_BACKGROUND_ALPHA : Number = 0.2
    
    private static const DEFAULT_VIEWPORT_WIDTH         : Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT        : Number = 600
    
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleContainer()
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
    
//    private var keyboardNavigationController : KeyboardNavigationController
//    private var mouseNavigationController : MouseNavigationController
    private var transformationController : ViewTransformationController
    
    private var loader : TileLoader
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  scene
    //----------------------------------
    
    private var _scene : MultiScaleScene
    
   ;[Bindable(event="sceneChanged")]
    public function get scene() : IMultiScaleScene
    {
        return _scene
    }
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : IViewportContainer
    
   ;[Bindable(event="viewportChanged")]
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
    
    //----------------------------------
    //  controllers
    //----------------------------------
    
   ;[ArrayElementType("org.openzoom.flash.viewport.IViewportController")]
    private var _controllers : Array = []
    
   ;[ArrayElementType("org.openzoom.flash.viewport.IViewportController")]
    public function get controllers() : Array
    {
    	return _controllers.slice()
    }
    
    public function set controllers( value : Array ) : void
    {
        _controllers = []
    	for each( var controller : IViewportController in value )
    		addController( controller )
    }
    
    //----------------------------------
    //  children
    //----------------------------------
    
    private var _children : Array = []
    
    public function get children() : Array
    {
    	return _children
    }
    
    public function set children( value : Array ) : void
    {
        // TODO Remove all children beforehands
        for each( var child : DisplayObject in value )
            addChild( child )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Viewport
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  minZoom
    //----------------------------------
    
    [Bindable]
    public function get minZoom() : Number
    {
        return viewport.constraint.minZoom
    }
    
    public function set minZoom( value : Number ) : void
    {
        viewport.constraint.minZoom = value
    }
    
    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    [Bindable]
    public function get maxZoom() : Number
    {
        return viewport.constraint.maxZoom
    }
    
    public function set maxZoom( value : Number ) : void
    {
        viewport.constraint.maxZoom = value
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  sceneWidth
    //----------------------------------
    
    [Bindable]
    public function get sceneWidth() : Number
    {
        return scene.sceneWidth
    }
    
    public function set sceneWidth( value : Number ) : void
    {
        scene.sceneWidth = value
    }    
    
    //----------------------------------
    //  sceneHeight
    //----------------------------------
    
    [Bindable]
    public function get sceneHeight() : Number
    {
        return scene.sceneHeight
    }
    
    public function set sceneHeight( value : Number ) : void
    {
        scene.sceneHeight = value
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
        createDefaultControllers()
    }
    
    override public function addChild( child : DisplayObject ) : DisplayObject
    {
    	return _scene.addChild( child )
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
        
        super.addChild( mouseCatcher )
    }
    
    private function createContentMask() : void
    {
        contentMask = new Shape()
        var g : Graphics = contentMask.graphics
        g.beginFill( 0xFF0000, 0 )
        g.drawRect( 0, 0, 100, 100 )
        g.endFill()
        
        super.addChild( contentMask )
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
        _scene = new MultiScaleScene( DEFAULT_SCENE_WIDTH,
                                      DEFAULT_SCENE_HEIGHT,
                                      DEFAULT_SCENE_BACKGROUND_COLOR,
                                      DEFAULT_SCENE_BACKGROUND_ALPHA )
        super.addChild( _scene )
        dispatchEvent( new Event("sceneChanged" ))
    }
    
    private function createLoader() : void
    {
        loader = new TileLoader()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Controllers
    //
    //--------------------------------------------------------------------------
  
    private function createDefaultControllers() : void
    {   
//        mouseNavigationController = new MouseNavigationController()
//        keyboardNavigationController = new KeyboardNavigationController()
//
//        addController( mouseNavigationController )
//        addController( keyboardNavigationController )
        
        transformationController = new ViewTransformationController()
        transformationController.viewport = viewport
        transformationController.view = scene.targetCoordinateSpace
    }
  
    private function addController( controller : IViewportController ) : Boolean
    {
        if( _controllers.indexOf( controller ) != -1 )
            return false
       
        _controllers.push( controller )
        controller.viewport = viewport
        controller.view = this
        return true
    }
  
    private function removeController( controller : IViewportController ) : Boolean
    {
        if( _controllers.indexOf( controller ) == -1 )
            return false
       
        _controllers.splice( _controllers.indexOf( controller ), 1 )
        controller.viewport = null
        controller.view = null
        return true
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