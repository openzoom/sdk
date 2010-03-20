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
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.core.UIComponent;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.NormalizedViewport;

use namespace openzoom_internal;

/**
 * @private
 *
 * Base class for MultiScaleImage and DeepZoomContainer.
 */
internal class MultiScaleImageBase extends UIComponent
                                  /*implements IMultiScaleContainer*/
{
	include "../../flash/core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    protected static const DEFAULT_SCENE_DIMENSION:Number = 16384 // 2^14

    private static const DEFAULT_VIEWPORT_WIDTH:Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT:Number = 600

    private static const DEFAULT_MEASURED_WIDTH:Number = 400
    private static const DEFAULT_MEASURED_HEIGHT:Number = 300

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleImageBase()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

   ;[Bindable(event="containerChanged")]
    protected var container:MultiScaleContainer

    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sceneWidth
    //----------------------------------

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneWidth
     */
    public function get sceneWidth():Number
    {
        return container ? container.sceneWidth : NaN
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneHeight
     */
    public function get sceneHeight():Number
    {
        return container ? container.sceneHeight : NaN
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Viewport
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

   ;[Bindable(event="viewportChanged")]

    /**
     * Viewport of this image.
     */
    public function get viewport():NormalizedViewport
    {
        return container ? container.viewport : null
    }

    //----------------------------------
    //  transformer
    //----------------------------------

    private var _transformer:IViewportTransformer
    private var transformerChanged:Boolean = false

   ;[Bindable(event="transformerChanged")]

    /**
     * Viewport transformer. Transformers are used to create the transitions
     * between transformations of the viewport.
     *
     * @see org.openzoom.flash.viewport.transformers.TweenerTransformer
     * @see org.openzoom.flash.viewport.transformers.NullTransformer
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
    //  constraint
    //----------------------------------

    private var _constraint:IViewportConstraint
    private var constraintChanged:Boolean = false

   ;[Bindable(event="constraintChanged")]

    /**
     * Viewport transformer constraint. Constraints are used to control
     * the positions and zoom levels the viewport can reach.
     *
     * @see org.openzoom.flash.viewport.constraints.ZoomConstraint
     * @see org.openzoom.flash.viewport.constraints.ScaleConstraint
     * @see org.openzoom.flash.viewport.constraints.VisibilityConstraint
     * @see org.openzoom.flash.viewport.constraints.CompositeConstraint
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
    //  controllers
    //----------------------------------

    private var _controllers:Array /* of IViewportController */ = []
    private var controllersChanged:Boolean = false

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
        if (_controllers !== value)
        {
            _controllers = value.slice(0)
            controllersChanged = true
            invalidateProperties()

            dispatchEvent(new Event("controllersChanged"))
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: ILoaderClient
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  loader
    //----------------------------------

    /**
     * @copy org.openzoom.flash.net.ILoaderClient#loader
     */
    public function get loader():INetworkQueue
    {
        return container ? container.loader : null
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

        if (!container)
        {
            container = new MultiScaleContainer()
            super.addChild(container)

//            container.loader.addEventListener(Event.INIT,
//                                              container_eventHandler,
//                                              false, 0, true)
//            container.loader.addEventListener(ProgressEvent.PROGRESS,
//                                              container_eventHandler,
//                                              false, 0, true)
//            container.loader.addEventListener(Event.COMPLETE,
//                                              container_eventHandler,
//                                              false, 0, true)

            dispatchEvent(new Event("containerChanged"))
            dispatchEvent(new Event("viewportChanged"))
        }
    }

    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        container.setActualSize(unscaledWidth, unscaledHeight)
    }

    override protected function measure():void
    {
        measuredWidth = DEFAULT_MEASURED_WIDTH
        measuredHeight = DEFAULT_MEASURED_HEIGHT
    }

    /**
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties()

        if (controllersChanged)
        {
            container.controllers = _controllers
            controllersChanged = false
        }

        if (transformerChanged)
        {
            container.transformer = _transformer
            transformerChanged = false
        }

        if (constraintChanged)
        {
            container.constraint = _constraint
            constraintChanged = false
        }

        if (zoomChanged || scaleChanged ||
			viewportXChanged || viewportYChanged ||
			viewportWidthChanged || viewportHeightChanged)
        {
            if (zoomChanged)
            {
                container.zoom = zoom
                zoomChanged = false
            }

            if (scaleChanged)
            {
                container.scale = scale
                scaleChanged = false
            }

            if (viewportXChanged || viewportYChanged)
            {
                container.panTo(viewportX, viewportY)
                viewportXChanged = viewportYChanged = false
            }

            if (viewportWidthChanged)
            {
                container.viewportWidth = viewportWidth
                viewportWidthChanged = false
            }

            if (viewportHeightChanged)
            {
                container.viewportHeight = viewportHeight
                viewportHeightChanged = false
            }

            dispatchEvent(new Event("viewportChanged"))
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers: Container
    //
    //--------------------------------------------------------------------------

    private function container_eventHandler(event:Event):void
    {
        dispatchEvent(event.clone())
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

   ;[Bindable(event="viewportChanged")]

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

   ;[Bindable(event="viewportChanged")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#scale
     */
    public function get scale():Number
    {
        return _scale
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

   ;[Bindable(event="viewportChanged")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#x
     */

    public function get viewportX():Number
    {
        return viewport ? viewport.x : _viewportX
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

   ;[Bindable(event="viewportChanged")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    public function get viewportY():Number
    {
        return viewport ? viewport.y : _viewportY
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

   ;[Bindable(event="viewportChanged")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    public function get viewportWidth():Number
    {
        return container ? container.viewportWidth : _viewportWidth
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

   ;[Bindable(event="viewportChanged")]

    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    public function get viewportHeight():Number
    {
        return container ? container.viewportHeight : _viewportHeight
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
        container.zoomTo(zoom, transformX, transformY, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomBy()
     */
    public function zoomBy(factor:Number,
                           transformX:Number=0.5,
                           transformY:Number=0.5,
                           immediately:Boolean=false):void
    {
        container.zoomBy(factor, transformX, transformY, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panTo()
     */
    public function panTo(x:Number, y:Number,
                          immediately:Boolean=false):void
    {
        container.panTo(x, y, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panBy()
     */
    public function panBy(deltaX:Number, deltaY:Number,
                          immediately:Boolean=false):void
    {
        container.panBy(deltaX, deltaY, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#fitToBounds()
     */
    public function fitToBounds(bounds:Rectangle,
                                scale:Number=1.0,
                                immediately:Boolean=false):void
    {
        container.fitToBounds(bounds, scale, immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showAll()
     */
    public function showAll(immediately:Boolean=false):void
    {
        container.showAll(immediately)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#localToScene()
     */
    public function localToScene(point:Point):Point
    {
        return container.localToScene(point)
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#sceneToLocal()
     */
    public function sceneToLocal(point:Point):Point
    {
        return container.sceneToLocal(point)
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function addChild(child:DisplayObject):DisplayObject
    {
        return container.addChild(child)
    }

    /**
     * @inheritDoc
     */
    override public function removeChild(child:DisplayObject):DisplayObject
    {
        return container.removeChild(child)
    }

    override public function getChildIndex(child:DisplayObject):int
    {
        return container.getChildIndex(child)
    }

    override public function getChildAt(index:int):DisplayObject
    {
        return container.getChildAt(index)
    }

    override public function getChildByName(name:String):DisplayObject
    {
        return container.getChildByName(name)
    }

    override public function removeChildAt(index:int):DisplayObject
    {
        return container.removeChildAt(index)
    }

    override public function addChildAt(child:DisplayObject, index:int):DisplayObject
    {
        return container.addChildAt(child, index)
    }

    override public function get numChildren():int
    {
        return container ? container.numChildren : 0
    }

    // TODO: Implement rest of child management methods
}

}
