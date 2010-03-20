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
package org.openzoom.flex.components
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.core.UIComponent;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.net.ILoaderClient;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.NetworkQueue;
import org.openzoom.flash.renderers.IRenderer;
import org.openzoom.flash.renderers.images.ImagePyramidRenderManager;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.scene.MultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportController;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.NormalizedViewport;

use namespace openzoom_internal;

[DefaultProperty("children")]
/**
 * Generic container for multiscale content.
 */
public final class MultiScaleContainer extends UIComponent
                                        implements /*IMultiScaleContainer,*/
                                                   ILoaderClient
{
	include "../../flash/core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_VIEWPORT_WIDTH:Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT:Number = 600

    private static const DEFAULT_SCENE_WIDTH:Number = 24000
    private static const DEFAULT_SCENE_HEIGHT:Number = 18000
    private static const DEFAULT_SCENE_BACKGROUND_COLOR:uint = 0x333333
    private static const DEFAULT_SCENE_BACKGROUND_ALPHA:Number = 0

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
        super()

        tabEnabled = false
        tabChildren = true
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var mouseCatcher:Sprite
    private var contentMask:Shape
    private var renderManager:ImagePyramidRenderManager

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

//    //----------------------------------
//    //  scene
//    //----------------------------------
//
    private var _scene:MultiScaleScene

   ;[Bindable(event="sceneChanged")]

    /**
     * @inheritDoc
     */
    public function get scene():IMultiScaleScene
    {
        return _scene
    }

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport:NormalizedViewport

   ;[Bindable(event="viewportChanged")]

    /**
     * @inheritDoc
     */
    public function get viewport():NormalizedViewport
    {
        return _viewport
    }

    //----------------------------------
    //  constraint
    //----------------------------------

    private var _constraint:IViewportConstraint
    private var constraintChanged:Boolean = false

   ;[Bindable(event="constraintChanged")]

    /**
     * @inheritDoc
     *
     * @see org.openzoom.flash.viewport.constraints.DefaultConstraint
     * @see org.openzoom.flash.viewport.constraints.NullConstraint
     */
    public function get constraint():IViewportConstraint
    {
        return _constraint
    }

    public function set constraint(value:IViewportConstraint):void
    {
        if (_constraint !== value)
        {
            _constraint = value
            constraintChanged = true
            invalidateProperties()

            dispatchEvent(new Event("constraintChanged"))
        }
    }

    //----------------------------------
    //  loader
    //----------------------------------

    private var _loader:INetworkQueue

    public function get loader():INetworkQueue
    {
        return _loader
    }

    public function set loader(value:INetworkQueue):void
    {
        _loader = value
    }

    //----------------------------------
    //  transformer
    //----------------------------------

    private var _transformer:IViewportTransformer
    private var transformerChanged:Boolean=false

   ;[Bindable(event="transformerChanged")]

    /**
     * @inheritDoc
     */
    public function get transformer():IViewportTransformer
    {
        return _transformer
    }

    public function set transformer(value:IViewportTransformer):void
    {
        if (_transformer !== value)
        {
            _transformer = value
            transformerChanged = true
            invalidateProperties()

            dispatchEvent(new Event("transformerChanged"))
        }
    }

    //----------------------------------
    //  controllers
    //----------------------------------

    private var _controllers:Array = []
    private var _controllersHolder:Array = []
    private var controllersChanged:Boolean = false

   ;[ArrayElementType("org.openzoom.flash.viewport.IViewportController")]
   ;[Inspectable(arrayType="org.openzoom.flash.viewport.IViewportController")]

   ;[Bindable(event="controllersChanged")]

    /**
     * Controllers of type IViewportController applied to this MultiScaleImage.
     * For example, viewport controllers are used to navigate the MultiScaleImage
     * by mouse or keyboard.
     *
     * @see org.openzoom.flash.viewport.controllers.MouseController
     * @see org.openzoom.flash.viewport.controllers.KeyboardController
     * @see org.openzoom.flash.viewport.controllers.ContextMenuController
     */
    public function get controllers():Array
    {
        return _controllers.slice(0)
    }

    public function set controllers(value:Array):void
    {
        if (_controllers != value)
        {
            // remove old controllers
            for each (var oldController:IViewportController in _controllers)
                removeController(oldController)

            _controllersHolder = value.slice(0)
            controllersChanged = true
            invalidateProperties()

            dispatchEvent(new Event("controllersChanged"))
        }
    }

    //----------------------------------
    //  children
    //----------------------------------

    private var _children:Array
    private var childrenChanged:Boolean = false

    public function get children():Array
    {
        return _children
    }

    public function set children(value:Array):void
    {
        if (_children != value)
        {
            _children = value
            childrenChanged = true
            invalidateProperties()
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sceneWidth
    //----------------------------------

    private var _sceneWidth:Number
    private var sceneWidthChanged:Boolean = false

   ;[Bindable(event="sceneResize")]

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneWidth
     */
    public function get sceneWidth():Number
    {
        return scene ? scene.sceneWidth : _sceneWidth
    }

    public function set sceneWidth(value:Number):void
    {
        if (_sceneWidth != value)
        {
            _sceneWidth = value
            sceneWidthChanged = true

            invalidateProperties()
        }
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    private var _sceneHeight:Number
    private var sceneHeightChanged:Boolean = false

   ;[Bindable(event="sceneHeightChanged")]

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneHeight
     */
    public function get sceneHeight():Number
    {
        return scene ? scene.sceneHeight : _sceneHeight
    }

    public function set sceneHeight(value:Number):void
    {
        if (_sceneHeight != value)
        {
            _sceneHeight = value
            sceneHeightChanged = true

            invalidateProperties()
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function createChildren():void
    {
        super.createChildren()

        if (!scene)
            createScene()

        if (!viewport)
            createNormalizedViewport(_scene)

        if (!mouseCatcher)
            createMouseCatcher()

        if (!contentMask)
            createContentMask()

        if (!loader)
            createLoader()

        if (!renderManager)
            createRenderManager()
    }

    /**
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties()

        if (childrenChanged)
        {
            // remove all existing children
            while (numChildren > 0)
                removeChildAt(0)

//            for each (var child:DisplayObject in _children)
//                _scene.addItem(child)
        }

        if (sceneWidthChanged || sceneHeightChanged)
        {
           _scene.sceneWidth = _sceneWidth
           _scene.sceneHeight = _sceneHeight

           sceneWidthChanged = sceneHeightChanged = false

           dispatchEvent(new Event("sceneResize"))
        }

        if (transformerChanged)
        {
            viewport.transformer = _transformer
            transformerChanged = false
        }

        if (constraintChanged)
        {
            _viewport.transformer.constraint = _constraint
            constraintChanged = false
        }

        if (controllersChanged)
        {
            for each (var controller:IViewportController in _controllersHolder)
                addController(controller)

            _controllersHolder = []
            controllersChanged = false
        }

        if (zoomChanged || scaleChanged ||
            viewportXChanged || viewportYChanged ||
            viewportWidthChanged || viewportHeightChanged)
        {
            if (zoomChanged)
            {
                viewport.zoom = zoom
                zoomChanged = false
            }

            if (scaleChanged)
            {
                viewport.scale = scale
                scaleChanged = false
            }

            if (viewportXChanged || viewportYChanged)
            {
                viewport.panTo(viewportX, viewportY)
                viewportXChanged = viewportYChanged = false
            }

            if (viewportWidthChanged)
            {
                viewport.width = viewportWidth
                viewportWidthChanged = false
            }

            if (viewportHeightChanged)
            {
                viewport.height = viewportHeight
                viewportHeightChanged = false
            }

            dispatchEvent(new Event("transformUpdate"))
        }
    }

    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {

        if (viewport.viewportWidth != unscaledWidth ||
            viewport.viewportHeight != unscaledHeight)
            _viewport.setSize(unscaledWidth, unscaledHeight)

        if (mouseCatcher.width != unscaledWidth ||
            mouseCatcher.height != unscaledHeight)
        {
            mouseCatcher.width = unscaledWidth
            mouseCatcher.height = unscaledHeight
        }

        if (contentMask.width != unscaledWidth ||
            contentMask.height != unscaledHeight)
        {
            contentMask.width = unscaledWidth
            contentMask.height = unscaledHeight
        }

        var vp:INormalizedViewport = _viewport
        var targetWidth:Number = vp.viewportWidth / vp.width
        var targetHeight:Number = vp.viewportHeight / vp.height
        var targetX:Number = -vp.x * targetWidth
        var targetY:Number = -vp.y * targetHeight

        var target:DisplayObject = _scene.targetCoordinateSpace
        target.x = targetX
        target.y = targetY
        target.width = targetWidth
        target.height = targetHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------

    override public function get numChildren():int
    {
        return _scene ? _scene.numChildren : 0
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    override public function addChild(child:DisplayObject):DisplayObject
    {
        return addChildAt(child, numChildren)
    }

    override public function removeChild(child:DisplayObject):DisplayObject
    {
        return removeChildAt(getChildIndex(child))
    }

    override public function addChildAt(child:DisplayObject,
                                        index:int):DisplayObject
    {
        var renderer:IRenderer = child as IRenderer
        if (renderer)
        {
            renderer.viewport = _viewport
            renderer.scene = IReadonlyMultiScaleScene(_scene)

            var imagePyramidRenderer:ImagePyramidRenderer = renderer as ImagePyramidRenderer
            if (imagePyramidRenderer)
                renderManager.addRenderer(imagePyramidRenderer)
        }

        return _scene.addChildAt(child, index)
    }

    override public function removeChildAt(index:int):DisplayObject
    {
        var child:DisplayObject = _scene.getChildAt(index)

        var renderer:IRenderer = child as IRenderer
        if (renderer)
        {
            var imagePyramidRenderer:ImagePyramidRenderer = renderer as ImagePyramidRenderer
            if (imagePyramidRenderer)
                renderManager.removeRenderer(imagePyramidRenderer)

            renderer.scene = null
            renderer.viewport = null
        }

        return _scene.removeChildAt(index)
    }

    override public function getChildAt(index:int):DisplayObject
    {
        return _scene.getChildAt(index)
    }

    override public function getChildByName(name:String):DisplayObject
    {
        return _scene.getChildByName(name)
    }

    override public function getChildIndex(child:DisplayObject):int
    {
        return _scene.getChildIndex(child)
    }

    override public function setChildIndex(child:DisplayObject,
                                           index:int):void
    {
        _scene.setChildIndex(child, index)
    }

    override public function swapChildren(child1:DisplayObject,
                                          child2:DisplayObject):void
    {
        _scene.swapChildren(child1, child2)
    }

    override public function swapChildrenAt(index1:int,
                                            index2:int):void
    {
        _scene.swapChildrenAt(index1, index2)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Children
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function createScene():void
    {
        _scene = new MultiScaleScene(DEFAULT_SCENE_WIDTH,
                                     DEFAULT_SCENE_HEIGHT,
                                     DEFAULT_SCENE_BACKGROUND_COLOR,
                                     DEFAULT_SCENE_BACKGROUND_ALPHA)

        super.addChild(_scene)

        dispatchEvent(new Event("sceneChanged"))
    }

    /**
     * @private
     */
    private function createMouseCatcher():void
    {
        mouseCatcher = new Sprite()

        var g:Graphics = mouseCatcher.graphics
        g.beginFill(0x000000, 0)
        g.drawRect(0, 0, 100, 100)
        g.endFill()

        mouseCatcher.mouseEnabled = false

        super.addChild(mouseCatcher)
    }

    /**
     * @private
     */
    private function createContentMask():void
    {
        contentMask = new Shape()

        var g:Graphics = contentMask.graphics
        g.beginFill(0xFF0000, 0)
        g.drawRect(0, 0, 100, 100)
        g.endFill()

        super.addChild(contentMask)

        mask = contentMask
    }

    private function createNormalizedViewport(scene:IReadonlyMultiScaleScene):void
    {
        _viewport = new NormalizedViewport(DEFAULT_VIEWPORT_WIDTH,
                                           DEFAULT_VIEWPORT_HEIGHT,
                                           scene)

        _viewport.addEventListener(ViewportEvent.TRANSFORM_START,
                                   viewport_transformStartHandler,
                                   false, 0, true)
        _viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                   viewport_transformUpdateHandler,
                                   false, 0, true)
        _viewport.addEventListener(ViewportEvent.TRANSFORM_END,
                                   viewport_transformEndHandler,
                                   false, 0, true)

        dispatchEvent(new Event("viewportChanged"))
    }

    private function createLoader():void
    {
        _loader = new NetworkQueue()
    }

    private function createRenderManager():void
    {
        renderManager = new ImagePyramidRenderManager(this, scene, viewport, loader)
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers: Viewport
    //
    //--------------------------------------------------------------------------

    private function viewport_transformStartHandler(event:ViewportEvent):void
    {
//      trace("ViewportEvent.TRANSFORM_START")
        invalidateDisplayList()
    }

    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
//      trace("ViewportEvent.TRANSFORM_UPDATE")

        // TODO: Test…
        invalidateDisplayList()
    }

    private function viewport_transformEndHandler(event:ViewportEvent):void
    {
//      trace("ViewportEvent.TRANSFORM_END")
        invalidateDisplayList()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Controllers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function addController(controller:IViewportController):Boolean
    {
        if (_controllers.indexOf(controller) != -1)
            return false

        _controllers.push(controller)
        controller.viewport = _viewport
        controller.view = this
        return true
    }

    /**
     * @private
     */
    private function removeController(controller:IViewportController):Boolean
    {
        if (_controllers.indexOf(controller) == -1)
            return false

        _controllers.splice(_controllers.indexOf(controller), 1)
        controller.viewport = null
        controller.view = null
        return true
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleContainer
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------

    private var _zoom:Number
    private var zoomChanged:Boolean = false

   ;[Bindable(event="transformUpdate")]
    // FIXME
    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoom
     */
    public function get zoom():Number
    {
        return _zoom
    }

    public function set zoom(value:Number):void
    {
        if (_zoom != value)
        {
            _zoom = value
            zoomChanged = true
            invalidateProperties()
        }
    }

    //----------------------------------
    //  scale
    //----------------------------------

    private var _scale:Number
    private var scaleChanged:Boolean = false

   ;[Bindable(event="transformUpdate")]

    // FIXME
    /**
     * @copy org.openzoom.flash.viewport.IViewport#scale
     */
    public function get scale():Number
    {
        return  _scale
    }

    public function set scale(value:Number):void
    {
        if (_scale != value)
        {
            _scale = value
            scaleChanged = true
            invalidateProperties()
        }
    }

    //----------------------------------
    //  viewportX
    //----------------------------------

    private var _viewportX:Number
    private var viewportXChanged:Boolean = false

   ;[Bindable(event="transformUpdate")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#x
     */

    public function get viewportX():Number
    {
        return _viewportX
    }

    public function set viewportX(value:Number):void
    {
        if (_viewportX != value)
        {
            _viewportX = value
            viewportXChanged = true
            invalidateProperties()
        }
    }
    //----------------------------------
    //  viewportY
    //----------------------------------

    private var _viewportY:Number
    private var viewportYChanged:Boolean = false

   ;[Bindable(event="transformUpdate")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    public function get viewportY():Number
    {
        return _viewportY
    }

    public function set viewportY(value:Number):void
    {
        if (_viewportY != value)
        {
            _viewportY = value
            viewportYChanged = true
            invalidateProperties()
        }
    }

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    private var _viewportWidth:Number
    private var viewportWidthChanged:Boolean = false

   ;[Bindable(event="transformUpdate")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    public function get viewportWidth():Number
    {
        return _viewportWidth
    }

    public function set viewportWidth(value:Number):void
    {
        if (_viewportWidth != value)
        {
            _viewportWidth = value
            viewportWidthChanged = true
            invalidateProperties()
        }
    }

    //----------------------------------
    //  viewportHeight
    //----------------------------------

    private var _viewportHeight:Number
    private var viewportHeightChanged:Boolean = false

   ;[Bindable(event="transformUpdate")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    public function get viewportHeight():Number
    {
        return _viewportHeight
    }

    public function set viewportHeight(value:Number):void
    {
        if (_viewportHeight != value)
        {
            _viewportHeight = value
            viewportHeightChanged = true
            invalidateProperties()
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImage
    //
    //--------------------------------------------------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomTo()
     */
    public function zoomTo(zoom:Number,
                           transformX:Number=0.5,
                           transformY:Number=0.5,
                           immediately:Boolean=false):void
    {
        viewport.zoomTo(zoom, transformX, transformY, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomBy()
     */
    public function zoomBy(factor:Number,
                           transformX:Number=0.5,
                           transformY:Number=0.5,
                           immediately:Boolean=false):void
    {
        viewport.zoomBy(factor, transformX, transformY, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panTo()
     */
    public function panTo(x:Number, y:Number,
                          immediately:Boolean=false):void
    {
        viewport.panTo(x, y, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panBy()
     */
    public function panBy(deltaX:Number,
                          deltaY:Number,
                          immediately:Boolean=false):void
    {
        viewport.panBy(deltaX, deltaY, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#fitToBounds()
     */
    public function fitToBounds(bounds:Rectangle,
                                scale:Number=1.0,
                                immediately:Boolean=false):void
    {
        viewport.fitToBounds(bounds, scale, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showAll()
     */
    public function showAll(immediately:Boolean=false):void
    {
        viewport.showAll(immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#localToScene()
     */
    public function localToScene(point:Point):Point
    {
        return viewport.localToScene(point)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#sceneToLocal()
     */
    public function sceneToLocal(point:Point):Point
    {
        return viewport.sceneToLocal(point)
    }
}

}
