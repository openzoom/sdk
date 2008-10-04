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
package org.openzoom.viewer
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.core.IViewport;
import org.openzoom.core.IViewportController;
import org.openzoom.core.Viewport;
import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.renderers.MultiScaleImageRenderer;
import org.openzoom.viewer.controllers.KeyboardNavigationController;
import org.openzoom.viewer.controllers.MouseNavigationController;
import org.openzoom.viewer.controllers.ViewTransformationController;

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
   
    private static const DEFAULT_MIN_ZOOM     : Number = 1
    private static const DEFAULT_MAX_ZOOM     : Number = 50000
    
    private static const ZOOM_IN_FACTOR     : Number = 2.0
    private static const ZOOM_OUT_FACTOR    : Number = 0.3
    private static const TRANSLATION_FACTOR : Number = 0.1
    
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
        
        // viewport
        createViewport()
        viewport.minZ = DEFAULT_MIN_ZOOM
        viewport.maxZ = DEFAULT_MAX_ZOOM
        
        // children
        createChildren()
        
        // image
        image = createImage()
        var bounds : Rectangle = image.getBounds( this )
        viewport.scene = bounds
        addChild( image )
        
        // controllers
        createControllers( image )
        
        updateViewport()  
    }
   
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var descriptor : IMultiScaleImageDescriptor
    private var image : MultiScaleImageRenderer

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

    private var _viewport : IViewport
    
    public function get viewport() : IViewport
    {
        return _viewport
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
        viewport.zoomTo( 1 )
    }
    
    // zooming
    public function zoomIn() : void
    {
        var origin : Point = getMouseOrigin()
        viewport.normalizedZoomBy( ZOOM_IN_FACTOR, origin.x, origin.y )
    }
    
    public function zoomOut() : void
    {
        var origin : Point = getMouseOrigin()
        viewport.normalizedZoomBy( ZOOM_OUT_FACTOR, origin.x, origin.y )
    }
    
    // panning
    public function moveUp() : void
    {
        var dy : Number = viewport.normalizedHeight * TRANSLATION_FACTOR
        viewport.normalizedMoveBy( 0, -dy )
    }
    
    public function moveDown() : void
    {
        var dy : Number = viewport.normalizedHeight * TRANSLATION_FACTOR
        viewport.normalizedMoveBy( 0, dy )
    }
    
    public function moveLeft() : void
    {
        var dx : Number = viewport.normalizedWidth * TRANSLATION_FACTOR
        viewport.normalizedMoveBy( -dx, 0 )
    }
    
    public function moveRight() : void
    {
        var dx : Number = viewport.normalizedWidth * TRANSLATION_FACTOR
        viewport.normalizedMoveBy( dx, 0 )
    }
    
    public function setSize( width : Number, height : Number ) : void
    {
        if( this.width == width && this.height == height )
           return
        
        mouseCatcher.width = width
        mouseCatcher.height = height
        updateViewport()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Children
    //
    //--------------------------------------------------------------------------
    
    private function createViewport() : void
    {
        _viewport = new Viewport()
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
    
    private function createImage() : MultiScaleImageRenderer
    {
        var image : MultiScaleImageRenderer = new MultiScaleImageRenderer( descriptor )
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
        viewport.bounds = new Rectangle( 0, 0, width, height )
    }
    
    private function getMouseOrigin() : Point
    {
        return new Point( mouseX / width, mouseY / height )
    }
}

}