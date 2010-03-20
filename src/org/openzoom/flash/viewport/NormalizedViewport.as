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
package org.openzoom.flash.viewport
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.viewport.transformers.NullTransformer;

use namespace openzoom_internal;

//------------------------------------------------------------------------------
//
//  Events
//
//------------------------------------------------------------------------------

/**
 * @inheritDoc
 */
[Event(name="resize", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="transformStart", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="transformUpdate", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="transformEnd", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="targetUpdate", type="org.openzoom.events.ViewportEvent")]


/**
 * IViewport implementation that is based on a normalized [0, 1] coordinate system.
 */
public final class NormalizedViewport extends EventDispatcher
                                      implements INormalizedViewport,
                                                 INormalizedViewportContainer
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const NULL_TRANSFORMER:IViewportTransformer = new NullTransformer()

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function NormalizedViewport(viewportWidth:Number,
                                       viewportHeight:Number,
                                       scene:IReadonlyMultiScaleScene)
    {
        _scene = scene
        _scene.addEventListener(Event.RESIZE,
                                scene_resizeHandler,
                                false, 0, true)

        var x:Number = 0
        var y:Number = 0
        var width:Number = 1
        var height:Number = 1
        var zoom:Number = 1

        _transform = ViewportTransform.fromValues(x,
                                                  y,
                                                  width,
                                                  height,
                                                  zoom,
                                                  viewportWidth,
                                                  viewportHeight,
                                                  scene.sceneWidth,
                                                  scene.sceneHeight)
        transformer = NULL_TRANSFORMER
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get zoom():Number
    {
        return _transform.zoom
    }

    public function set zoom(value:Number):void
    {
        zoomTo(value)
    }

    //----------------------------------
    //  scale
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get scale():Number
    {
        return _transform.scale
    }

    public function set scale(value:Number):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.scale = value
        applyTransform(t)
    }

    //----------------------------------
    //  center
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get center():Point
    {
        return _transform.center
    }

//    //----------------------------------
//    //  constraint
//    //----------------------------------
//
//    private var _constraint:IViewportConstraint = NULL_CONSTRAINT
//
//    public function get constraint():IViewportConstraint
//    {
//        return _constraint
//    }
//
//    public function set constraint(value:IViewportConstraint):void
//    {
//        if (value)
//           _constraint = value
//        else
//           _constraint = NULL_CONSTRAINT
//    }

    //----------------------------------
    //  transformer
    //----------------------------------

    /**
     * @private
     * Storage for the transformer property.
     */
    private var _transformer:IViewportTransformer

    /**
     * @inheritDoc
     */
    public function get transformer():IViewportTransformer
    {
        return _transformer
    }

    /**
     * @inheritDoc
     */
    public function set transformer(value:IViewportTransformer):void
    {
        if (_transformer)
        {
           _transformer.stop()

           // FIXME: Something goes wrong here...
//           _transformer.viewport = null
        }

        if (value)
           _transformer = value
        else
           _transformer = NULL_TRANSFORMER

        _transformer.viewport = this
    }

    //----------------------------------
    //  transform
    //----------------------------------

    /**
     * @private
     * Storage for the transform property.
     */
    private var _transform:IViewportTransform

   ;[Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get transform():IViewportTransform
    {
        return _transform.clone()
    }

    public function set transform(value:IViewportTransform):void
    {
        var oldTransform:IViewportTransform = _transform.clone()
        _transform = value.clone()
        dispatchUpdateTransformEvent(oldTransform)
    }

    //----------------------------------
    //  scene
    //----------------------------------

    /**
     * @private
     * Storage for the scene property.
     */
    private var _scene:IReadonlyMultiScaleScene

    /**
     * @inheritDoc
     */
    public function get scene():IReadonlyMultiScaleScene
    {
        return _scene
    }

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    [Bindable(event="resize")]

    /**
     * @inheritDoc
     */
    public function get viewportWidth():Number
    {
        return _transform.viewportWidth
    }

    //----------------------------------
    //  viewportHeight
    //----------------------------------

    [Bindable(event="resize")]

    /**
     * @inheritDoc
     */
    public function get viewportHeight():Number
    {
        return _transform.viewportHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function zoomTo(zoom:Number,
                           transformX:Number=0.5,
                           transformY:Number=0.5,
                           immediately:Boolean=false):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.zoomTo(zoom, transformX, transformY)
        applyTransform(t, immediately)
    }

    /**
     * @inheritDoc
     */
    public function zoomBy(factor:Number,
                           transformX:Number=0.5,
                           transformY:Number=0.5,
                           immediately:Boolean=false):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.zoomBy(factor, transformX, transformY)
        applyTransform(t, immediately)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function panTo(x:Number, y:Number,
                          immediately:Boolean=false):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.panTo(x, y)
        applyTransform(t, immediately)
    }

    /**
     * @inheritDoc
     */
    public function panBy(deltaX:Number, deltaY:Number,
                          immediately:Boolean=false):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.panBy(deltaX, deltaY)
        applyTransform(t, immediately)
    }

    /**
     * @inheritDoc
     */
    public function panCenterTo(x:Number, y:Number,
                                immediately:Boolean=false):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.panCenterTo(x, y)
        applyTransform(t, immediately)
    }

    /**
     * @inheritDoc
     */
    public function fitToBounds(bounds:Rectangle,
                                scale:Number=1.0,
                                immediately:Boolean=false):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.fitToBounds(bounds, scale)
        applyTransform(t, immediately)
    }

    /**
     * @inheritDoc
     */
    public function showAll(immediately:Boolean=false):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.showAll()
        applyTransform(t, immediately)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function localToScene(point:Point):Point
    {
        var p:Point = new Point()
        p.x = (x * scene.sceneWidth)
                + (point.x / viewportWidth)  * (width  * scene.sceneWidth)
        p.y = (y * scene.sceneHeight)
                + (point.y / viewportHeight) * (height * scene.sceneHeight)
        return p
    }

    /**
     * @inheritDoc
     */
    public function sceneToLocal(point:Point):Point
    {
        var p:Point = new Point()
        p.x = (point.x - (x  * scene.sceneWidth))
                / (width  * scene.sceneWidth) * viewportWidth
        p.y = (point.y - (y  * scene.sceneHeight))
                / (height * scene.sceneHeight) * viewportHeight
        return p
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewport / flash.geom.Rectangle
    //
    //--------------------------------------------------------------------------

   ;[Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function getBounds():Rectangle
    {
        return _transform.getBounds()
    }

    /**
     * @inheritDoc
     */
    public function contains(x:Number, y:Number):Boolean
    {
        return _transform.contains(x, y)
    }

    /**
     * @inheritDoc
     */
    public function intersects(toIntersect:Rectangle):Boolean
    {
        return _transform.intersects(toIntersect)
    }

    /**
     * @inheritDoc
     */
    public function intersection(toIntersect:Rectangle):Rectangle
    {
        return _transform.intersection(toIntersect)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IViewport
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  x
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get x():Number
    {
        return _transform.x
    }

    public function set x(value:Number):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.x = value
        applyTransform(t)
    }

    //----------------------------------
    //  y
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get y():Number
    {
       return _transform.y
    }

    public function set y(value:Number):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.y = value
        applyTransform(t)
    }

    //----------------------------------
    //  width
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get width():Number
    {
        return _transform.width
    }

    public function set width(value:Number):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.width = value
        applyTransform(t)
    }

    //----------------------------------
    //  height
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get height():Number
    {
        return _transform.height
    }

    public function set height(value:Number):void
    {
        var t:IViewportTransform = getTargetTransform()
        t.height = value
        applyTransform(t)
    }

    //----------------------------------
    //  left
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get left():Number
    {
        return _transform.left
    }

    //----------------------------------
    //  right
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get right():Number
    {
        return _transform.right
    }

    //----------------------------------
    //  top
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get top():Number
    {
        return _transform.top
    }

    //----------------------------------
    //  bottom
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get bottom():Number
    {
        return _transform.bottom
    }

    //----------------------------------
    //  topLeft
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get topLeft():Point
    {
        return _transform.topLeft
    }

    //----------------------------------
    //  bottomRight
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get bottomRight():Point
    {
        return _transform.bottomRight
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Transform Events
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function beginTransform():void
    {
//        trace("[NormalizedViewport]", "beginTransform")
        dispatchEvent(new ViewportEvent(ViewportEvent.TRANSFORM_START))
    }

    /**
     * @private
     * Dispatches a transformUpdate event along with a copy
     * of the transform previously applied to this viewport.
     */
    private function dispatchUpdateTransformEvent(oldTransform:IViewportTransform=null):void
    {
//        trace("[NormalizedViewport]", "updateTransform")
        dispatchEvent(new ViewportEvent(ViewportEvent.TRANSFORM_UPDATE,
                                        false, false, oldTransform))
    }

    /**
     * @inheritDoc
     */
    public function endTransform():void
    {
//        trace("[NormalizedViewport]", "endTransform")
        dispatchEvent(new ViewportEvent(ViewportEvent.TRANSFORM_END))
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getTargetTransform():IViewportTransform
    {
        return transformer.target
    }

    /**
     * @private
     */
    private function applyTransform(transform:IViewportTransform,
                                    immediately:Boolean=false):void
    {
        dispatchEvent(new ViewportEvent(ViewportEvent.TARGET_UPDATE))
        transformer.transform(transform, immediately)
    }

    /**
     * @private
     */
    private function reinitializeTransform(viewportWidth:Number,
                                           viewportHeight:Number):void
    {
        var old:IViewportTransform = transform
        var t:IViewportTransformContainer =
                ViewportTransform.fromValues(old.x, old.y,
                                             old.width, old.height, old.zoom,
                                             viewportWidth, viewportHeight,
                                             _scene.sceneWidth, _scene.sceneHeight)
        applyTransform(t, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportContainer
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function setSize(width:Number, height:Number):void
    {
        if (viewportWidth == width &&
            viewportHeight == height)
            return

        reinitializeTransform(width, height)

        var resizeEvent:ViewportEvent =
                new ViewportEvent(ViewportEvent.RESIZE, false, false)
        dispatchEvent(resizeEvent)
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function scene_resizeHandler(event:Event):void
    {
        reinitializeTransform(viewportWidth, viewportHeight)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function toString():String
    {
        return "[NormalizedViewport]" + "\n" +
               "x=" + x + "\n" +
               "y=" + y  + "\n" +
               "z=" + zoom + "\n" +
               "w=" + width + "\n" +
               "h=" + height + "\n" +
               "sW=" + scene.sceneWidth + "\n" +
               "sH=" + scene.sceneHeight
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
        _scene.removeEventListener(Event.RESIZE,
                                   scene_resizeHandler)
    	
    	_transform.dispose()
    	_transform = null
    	
    	_transformer = null    	
    }
}

}
