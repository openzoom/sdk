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
package org.openzoom.flash.components
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

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
import org.openzoom.flash.utils.IDisposable;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportController;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.NormalizedViewport;

use namespace openzoom_internal;

/**
 * Flash component for creating Zoomable User Interfaces.
 */
public final class MultiScaleContainer extends Sprite
                                       implements ILoaderClient,
                                                  IDisposable
{
	include "../core/Version.as"

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
        createChildren()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var mouseCatcher:Sprite
    private var contentMask:Shape

    // TODO: Consider applying dependency injection (DI)
    private var renderManager:ImagePyramidRenderManager

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  scene
    //----------------------------------

    private var _scene:MultiScaleScene

    /**
     * @copy org.openzoom.flash.viewport.IViewport#scene
     */
    public function get scene():IMultiScaleScene
    {
        return _scene
    }

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport:NormalizedViewport

    /**
     * Viewport of this container.
     */
    public function get viewport():NormalizedViewport
    {
        return _viewport
    }

    //----------------------------------
    //  constraint
    //----------------------------------

    private var _constraint:IViewportConstraint

    /**
     * Constraint of this container.
     *
     * @see org.openzoom.flash.viewport.constraints.CenterConstraint
     * @see org.openzoom.flash.viewport.constraints.ScaleConstraint
     * @see org.openzoom.flash.viewport.constraints.ZoomConstraint
     * @see org.openzoom.flash.viewport.constraints.CompositeConstraint
     * @see org.openzoom.flash.viewport.constraints.NullConstraint
     */
    public function get constraint():IViewportConstraint
    {
        return _constraint
    }

    public function set constraint(value:IViewportConstraint):void
    {
        if (viewport)
            viewport.transformer.constraint = value
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

    /**
     * @inheritDoc
     */
    public function get transformer():IViewportTransformer
    {
        return _transformer
    }

    public function set transformer(value:IViewportTransformer):void
    {
        if (viewport)
            viewport.transformer = value
    }

    //----------------------------------
    //  controllers
    //----------------------------------

    private var _controllers:Array = []

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
    public function get controllers():Array
    {
        return _controllers.slice(0)
    }

    public function set controllers(value:Array):void
    {
        // remove old controllers
        for each (var oldController:IViewportController in _controllers)
            removeController(oldController)

        _controllers = []

        // add new controllers
        for each (var controller:IViewportController in value)
            addController(controller)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sceneWidth
    //----------------------------------

    public function get sceneWidth():Number
    {
        return scene.sceneWidth
    }

    public function set sceneWidth(value:Number):void
    {
        scene.sceneWidth = value
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    public function get sceneHeight():Number
    {
        return scene.sceneHeight
    }

    public function set sceneHeight(value:Number):void
    {
        scene.sceneHeight = value
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    private function createChildren():void
    {
        if (!scene)
            createScene()

        if (!viewport)
            createViewport(_scene)

        if (!mouseCatcher)
            createMouseCatcher()

        if (!contentMask)
            createContentMask()

        if (!loader)
            createLoader()

        if (!renderManager)
            createRenderManager()
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObjectContainer
    //
    //--------------------------------------------------------------------------

    override public function get numChildren():int
    {
        return scene ? _scene.numChildren:0
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DisplayObjectContainer
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

    override public function setChildIndex(child:DisplayObject,
                                           index:int):void
    {
        _scene.setChildIndex(child, index)
    }

    override public function getChildAt(index:int):DisplayObject
    {
        return _scene.getChildAt(index)
    }

    override public function getChildIndex(child:DisplayObject):int
    {
        return _scene.getChildIndex(child)
    }

    override public function getChildByName(name:String):DisplayObject
    {
        return _scene.getChildByName(name)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function createMouseCatcher():void
    {
        mouseCatcher = new Sprite()
        var g:Graphics = mouseCatcher.graphics
        g.beginFill(0x000000, 0)
        g.drawRect(0, 0, 100, 100)
        g.endFill()

        mouseCatcher.mouseEnabled = false

        super.addChildAt(mouseCatcher, 0)
    }

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

    //--------------------------------------------------------------------------
    //
    //  Methods: Viewports
    //
    //--------------------------------------------------------------------------

    private function createViewport(scene:IReadonlyMultiScaleScene):void
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

        addEventListener(Event.ENTER_FRAME,
                         enterFrameHandler,
                         false, 0, true)
    }

    private function createScene():void
    {
        _scene = new MultiScaleScene(DEFAULT_SCENE_WIDTH,
                                     DEFAULT_SCENE_HEIGHT,
                                     DEFAULT_SCENE_BACKGROUND_COLOR,
                                     DEFAULT_SCENE_BACKGROUND_ALPHA)
        super.addChild(_scene)
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
    }

    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
//      trace("ViewportEvent.TRANSFORM_UPDATE")
        invalidated = true
    }

    private var invalidated:Boolean = true

    private function viewport_transformEndHandler(event:ViewportEvent):void
    {
//      trace("ViewportEvent.TRANSFORM_END")
    }

    private function enterFrameHandler(event:Event):void
    {
        if (invalidated)
            updateDisplayList()
    }

    private function updateDisplayList():void
    {
        var v:INormalizedViewport = viewport
        var targetWidth:Number = v.viewportWidth / v.width
        var targetHeight:Number = v.viewportHeight / v.height
        var targetX:Number = -v.x * targetWidth
        var targetY:Number = -v.y * targetHeight

        var target:DisplayObject = scene.targetCoordinateSpace
            target.x = targetX
            target.y = targetY
            target.width = targetWidth
            target.height = targetHeight

        invalidated = false
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Controllers
    //
    //--------------------------------------------------------------------------

    private function addController(controller:IViewportController):Boolean
    {
        if (_controllers.indexOf(controller) != -1)
            return false

        _controllers.push(controller)
        controller.viewport = viewport
        controller.view = this
        return true
    }

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
    //  Overridden properties: DisplayObject
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  width
    //----------------------------------

    override public function get width():Number
    {
        return mouseCatcher.width
    }

    override public function set width(value:Number):void
    {
        setActualSize(value, height)
    }

    //----------------------------------
    //  height
    //----------------------------------

    override public function get height():Number
    {
        return mouseCatcher.height
    }

    override public function set height(value:Number):void
    {
        setActualSize(width, value)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function setActualSize(width:Number, height:Number):void
    {
        if (this.width == width && this.height == height)
            return

        if (_viewport)
            _viewport.setSize(width, height)

        if (contentMask)
        {
            contentMask.width = width
            contentMask.height = height
        }

        if (mouseCatcher)
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
    public function get zoom():Number
    {
        return viewport.zoom
    }

    public function set zoom(value:Number):void
    {
        viewport.zoom = value
    }

    //----------------------------------
    //  scale
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#scale
     */
    public function get scale():Number
    {
        return viewport.zoom
    }

    public function set scale(value:Number):void
    {
        viewport.scale = value
    }

    //----------------------------------
    //  viewportX
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#x
     */
    public function get viewportX():Number
    {
        return viewport.x
    }

    public function set viewportX(value:Number):void
    {
        viewport.x = value
    }

    //----------------------------------
    //  viewportY
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    public function get viewportY():Number
    {
        return viewport.y
    }

    public function set viewportY(value:Number):void
    {
        viewport.y = value
    }

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    public function get viewportWidth():Number
    {
        return viewport.width
    }

    public function set viewportWidth(value:Number):void
    {
        viewport.width = value
    }

    //----------------------------------
    //  viewportHeight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    public function get viewportHeight():Number
    {
        return viewport.height
    }

    public function set viewportHeight(value:Number):void
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
    public function panBy(deltaX:Number, deltaY:Number,
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

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
        removeEventListener(Event.ENTER_FRAME,
                            enterFrameHandler)

    	_transformer = null
    	controllers = []
    	_constraint = null
    	
    	while (super.numChildren > 0)
    	   super.removeChildAt(0)

        mouseCatcher = null
        contentMask = null
                            
        _viewport.removeEventListener(ViewportEvent.TRANSFORM_START,
                                      viewport_transformStartHandler)
        _viewport.removeEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                      viewport_transformUpdateHandler)
        _viewport.removeEventListener(ViewportEvent.TRANSFORM_END,
                                      viewport_transformEndHandler)
    	_viewport.dispose()
    	_viewport = null
    	
    	_scene.dispose()
    	_scene = null
    	
    	_loader.dispose()
    	_loader = null
    }
}

}
