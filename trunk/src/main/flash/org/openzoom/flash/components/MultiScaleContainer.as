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
package org.openzoom.flash.components
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.ILoaderClient;
import org.openzoom.flash.net.ILoadingQueue;
import org.openzoom.flash.net.LoadingQueue;
import org.openzoom.flash.renderers.IMultiScaleRenderer;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.scene.MultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.INormalizedViewportContainer;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportController;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.NormalizedViewport;

/**
 * @private
 *
 * Flash component for creating Zoomable User Interfaces.
 */
public final class MultiScaleContainer extends Sprite
                                       implements ILoaderClient
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_VIEWPORT_WIDTH         : Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT        : Number = 600

    private static const DEFAULT_SCENE_WIDTH            : Number = 24000
    private static const DEFAULT_SCENE_HEIGHT           : Number = 18000
    private static const DEFAULT_SCENE_BACKGROUND_COLOR : uint   = 0x333333
    private static const DEFAULT_SCENE_BACKGROUND_ALPHA : Number = 0

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
        createChildren()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var mouseCatcher : Sprite
    private var contentMask : Shape

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  scene
    //----------------------------------

    private var _scene : MultiScaleScene

    /**
     * @copy org.openzoom.flash.viewport.IViewport#scene
     */
    public function get scene() : IMultiScaleScene
    {
        return _scene
    }

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport : INormalizedViewportContainer

    /**
     * Viewport of this container.
     */
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }

    //----------------------------------
    //  constraint
    //----------------------------------

    private var _constraint : IViewportConstraint

    /**
     * Constraint of this container.
     *
     * @see org.openzoom.flash.viewport.constraints.CenterConstraint
     * @see org.openzoom.flash.viewport.constraints.ScaleConstraint
     * @see org.openzoom.flash.viewport.constraints.ZoomConstraint
     * @see org.openzoom.flash.viewport.constraints.CompositeConstraint
     * @see org.openzoom.flash.viewport.constraints.NullConstraint
     */
    public function get constraint() : IViewportConstraint
    {
        return _constraint
    }

    public function set constraint( value : IViewportConstraint ) : void
    {
        if( viewport )
            viewport.transformer.constraint = value
    }

    //----------------------------------
    //  loader
    //----------------------------------

    private var _loader : ILoadingQueue

    public function get loader() : ILoadingQueue
    {
        return _loader
    }

    public function set loader( value : ILoadingQueue ) : void
    {
        _loader = value
    }

    //----------------------------------
    //  transformer
    //----------------------------------

    private var _transformer : IViewportTransformer

    /**
     * @inheritDoc
     */
    public function get transformer() : IViewportTransformer
    {
        return _transformer
    }

    public function set transformer( value : IViewportTransformer ) : void
    {
        if( viewport )
            viewport.transformer = value
    }

    //----------------------------------
    //  controllers
    //----------------------------------

    private var _controllers : Array = []

   ;[ArrayElementType("org.openzoom.flash.viewport.IViewportController")]

    /**
     * Controllers of type IViewportController applied to this MultiScaleImage.
     * For example, viewport controllers are used to navigate the MultiScaleImage
     * by mouse or keyboard.
     *
     * @see org.openzoom.flash.viewport.controllers.MouseController
     * @see org.openzoom.flash.viewport.controllers.KeyboardController
     * @see org.openzoom.flash.viewport.controllers.ContextMenuController
     */
    public function get controllers() : Array
    {
        return _controllers.slice( 0 )
    }

    public function set controllers( value : Array ) : void
    {
        // remove old controllers
        for each( var oldController : IViewportController in _controllers )
            removeController( oldController )

        _controllers = []

        // add new controllers
        for each( var controller : IViewportController in value )
            addController( controller )
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sceneWidth
    //----------------------------------

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

    private function createChildren() : void
    {
        if( !scene )
            createScene()

        if( !viewport )
            createViewport( _scene )

        if( !mouseCatcher )
            createMouseCatcher()

        if( !contentMask )
            createContentMask()

        if( !loader )
            createLoader()
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObjectContainer
    //
    //--------------------------------------------------------------------------

    override public function get numChildren() : int
    {
        return scene ? _scene.numChildren : 0
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DisplayObjectContainer
    //
    //--------------------------------------------------------------------------

    override public function addChild( child : DisplayObject ) : DisplayObject
    {
        child = _scene.addChild( child )

        // FIXME
        if( child is IMultiScaleRenderer )
            IMultiScaleRenderer( child ).viewport = viewport

        return child
    }

    override public function removeChild( child : DisplayObject ) : DisplayObject
    {
        return _scene.removeChild( child )
    }

    override public function addChildAt( child : DisplayObject,
                                         index : int ) : DisplayObject
    {
        child = _scene.addChildAt( child, index )

        // FIXME
        if( child is IMultiScaleRenderer )
            IMultiScaleRenderer( child ).viewport = viewport

        return child
    }

    override public function removeChildAt( index : int ) : DisplayObject
    {
        return _scene.removeChildAt( index )
    }

    override public function swapChildren( child1 : DisplayObject,
                                           child2 : DisplayObject ) : void
    {
        _scene.swapChildren( child1, child2 )
    }

    override public function swapChildrenAt( index1 : int,
                                             index2 : int ) : void
    {
        _scene.swapChildrenAt( index1, index2 )
    }

    override public function setChildIndex( child : DisplayObject,
                                            index : int ) : void
    {
        _scene.setChildIndex( child, index )
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

    //--------------------------------------------------------------------------
    //
    //  Methods: Viewports
    //
    //--------------------------------------------------------------------------

    private function createViewport( scene : IReadonlyMultiScaleScene ) : void
    {
        _viewport = new NormalizedViewport( DEFAULT_VIEWPORT_WIDTH,
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

    private function createScene() : void
    {
        _scene = new MultiScaleScene( DEFAULT_SCENE_WIDTH,
                                      DEFAULT_SCENE_HEIGHT,
                                      DEFAULT_SCENE_BACKGROUND_COLOR,
                                      DEFAULT_SCENE_BACKGROUND_ALPHA )
        super.addChild( _scene )
    }

    private function createLoader() : void
    {
        _loader = new LoadingQueue()
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers: Viewport
    //
    //--------------------------------------------------------------------------

    private function viewport_transformStartHandler( event : ViewportEvent ) : void
    {
//      trace("ViewportEvent.TRANSFORM_START")
    }

    private function viewport_transformUpdateHandler( event : ViewportEvent ) : void
    {
//        trace("ViewportEvent.TRANSFORM_UPDATE")
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
//        trace("ViewportEvent.TRANSFORM_END")
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Controllers
    //
    //--------------------------------------------------------------------------

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
        setActualSize( value, height )
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
        setActualSize( width, value )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function setActualSize( width : Number, height : Number ) : void
    {
        if( this.width == width && this.height == height )
            return

        if( _viewport )
            _viewport.setSize( width, height )

        if( contentMask )
        {
            contentMask.width = width
            contentMask.height = height
        }

        if( mouseCatcher )
        {
            mouseCatcher.width = width
            mouseCatcher.height = height
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoom
     */
    public function get zoom() : Number
    {
        return viewport.zoom
    }

    public function set zoom( value : Number ) : void
    {
        viewport.zoom = value
    }

    //----------------------------------
    //  scale
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#scale
     */
    public function get scale() : Number
    {
        return viewport.zoom
    }

    public function set scale( value : Number ) : void
    {
        viewport.scale = value
    }

    //----------------------------------
    //  viewportX
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#x
     */
    public function get viewportX() : Number
    {
        return viewport.x
    }

    public function set viewportX( value : Number ) : void
    {
        viewport.x = value
    }

    //----------------------------------
    //  viewportY
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    public function get viewportY() : Number
    {
        return viewport.y
    }

    public function set viewportY( value : Number ) : void
    {
        viewport.y = value
    }

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    public function get viewportWidth() : Number
    {
        return viewport.width
    }

    public function set viewportWidth( value : Number ) : void
    {
        viewport.width = value
    }

    //----------------------------------
    //  viewportHeight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    public function get viewportHeight() : Number
    {
        return viewport.height
    }

    public function set viewportHeight( value : Number ) : void
    {
        viewport.height = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomTo()
     */
    public function zoomTo( zoom : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomTo( zoom, transformX, transformY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomBy()
     */
    public function zoomBy( factor : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomBy( factor, transformX, transformY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panTo()
     */
    public function panTo( x : Number, y : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panTo( x, y, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panBy()
     */
    public function panBy( deltaX : Number, deltaY : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panBy( deltaX, deltaY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomToBounds()
     */
    public function zoomToBounds( bounds : Rectangle,
                                  scale : Number = 1.0,
                                  immediately : Boolean = false ) : void
    {
        viewport.zoomToBounds( bounds, scale, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showAll()
     */
    public function showAll( immediately : Boolean = false ) : void
    {
        viewport.showAll( immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#localToScene()
     */
    public function localToScene( point : Point ) : Point
    {
        return viewport.localToScene( point )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#sceneToLocal()
     */
    public function sceneToLocal( point : Point ) : Point
    {
        return viewport.sceneToLocal( point )
    }
}

}