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

import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;

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
[Event(name="transform", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="transformEnd", type="org.openzoom.events.ViewportEvent")]

/**
 * @inheritDoc
 */
[Event(name="targetUpdate", type="org.openzoom.events.ViewportEvent")]


/**
 * IViewport implementation that is based on the scene
 * coordinate system [0, scene(Width|Height)].
 */
public final class SceneViewport extends EventDispatcher
                                 implements ISceneViewport
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function SceneViewport(lock:SingletonLock,
                                  viewport:INormalizedViewport)
    {
        this.viewport = viewport
    }

    private var viewport:INormalizedViewport
    private static var sceneViewports:Dictionary = new Dictionary(true)

    /**
     * Returns an instance of SceneViewport for a given normalized viewport.
     */
    public static function getInstance(viewport:INormalizedViewport):ISceneViewport
    {
        var svp:ISceneViewport = sceneViewports[viewport] as ISceneViewport

        if (!svp)
            sceneViewports[viewport] = new SceneViewport(new SingletonLock(),
                                                         viewport)
            svp = ISceneViewport(sceneViewports[viewport])

        return svp
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
        return viewport.zoom
    }

    public function set zoom(value:Number):void
    {
        viewport.zoom = value
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
        return viewport.scale
    }

    public function set scale(value:Number):void
    {
        viewport.scale = value
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
     * @inheritDoc
     */
    public function get transformer():IViewportTransformer
    {
        return viewport.transformer
    }

    /**
     * @inheritDoc
     */
    public function set transformer(value:IViewportTransformer):void
    {
        viewport.transformer = value
    }

    //----------------------------------
    //  transform
    //----------------------------------

    /**
     * @private
     * Storage for the transform property.
     */
//    private var _transform:IViewportTransform
//
//   ;[Bindable(event="transformUpdate")]
//
//    /**
//     * @inheritDoc
//     */
//    public function get transform():IViewportTransform
//    {
//        return _transform.clone()
//    }
//
//    public function set transform(value:IViewportTransform):void
//    {
//        var oldTransform:IViewportTransform = _transform.clone()
//        _transform = value.clone()
//        dispatchUpdateTransformEvent(oldTransform)
//    }

    //----------------------------------
    //  scene
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get scene():IReadonlyMultiScaleScene
    {
        return viewport.scene
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
        return viewport.viewportWidth
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
        return viewport.viewportHeight
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
                           transformX:Number=NaN,
                           transformY:Number=NaN,
                           immediately:Boolean=false):void
    {
        if (isNaN(transformX))
           transformX = scene.sceneWidth / 2

        if (isNaN(transformY))
           transformY = scene.sceneHeight / 2

        viewport.zoomTo(zoom,
                        transformX / scene.sceneWidth,
                        transformY / scene.sceneHeight,
                        immediately)
    }

    /**
     * @inheritDoc
     */
    public function zoomBy(factor:Number,
                           transformX:Number=NaN,
                           transformY:Number=NaN,
                           immediately:Boolean=false):void
    {
        if (isNaN(transformX))
           transformX = scene.sceneWidth / 2

        if (isNaN(transformY))
           transformY = scene.sceneHeight / 2

        viewport.zoomBy(factor,
                        transformX / scene.sceneWidth,
                        transformY / scene.sceneHeight,
                        immediately)

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
        viewport.panTo(x / scene.sceneWidth,
                       y / scene.sceneHeight,
                       immediately)
    }

    /**
     * @inheritDoc
     */
    public function panBy(deltaX:Number,
                          deltaY:Number,
                          immediately:Boolean=false):void
    {
        viewport.panBy(deltaX / scene.sceneWidth,
                       deltaY / scene.sceneHeight,
                       immediately)
    }

    /**
     * @inheritDoc
     */
    public function panCenterTo(centerX:Number,
                                centerY:Number,
                                immediately:Boolean=false):void
    {
        viewport.panCenterTo(centerX / scene.sceneWidth,
                             centerY / scene.sceneHeight,
                             immediately)
    }

    /**
     * @inheritDoc
     */
    public function fitToBounds(bounds:Rectangle,
                                scale:Number=1.0,
                                immediately:Boolean=false):void
    {
        bounds.x /= scene.sceneWidth
        bounds.y /= scene.sceneHeight
        bounds.width /= scene.sceneWidth
        bounds.height /= scene.sceneHeight

        viewport.fitToBounds(bounds, scale, immediately)
    }

    /**
     * @inheritDoc
     */
    public function showAll(immediately:Boolean=false):void
    {
        viewport.showAll(immediately)
    }

    /**
     * @inheritDoc
     */
    public function get transform():IViewportTransform
    {
        throw new IllegalOperationError("Not implemented.")
        return null
    }

    /**
     * @inheritDoc
     */
    public function set transform(value:IViewportTransform):void
    {
        throw new IllegalOperationError("Not implemented.")
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
        point.x /= viewportWidth
        point.y /= viewportHeight
        var p:Point = viewport.localToScene(point)
        p.x *= scene.sceneWidth
        p.y *= scene.sceneHeight

        return p
    }

    /**
     * @inheritDoc
     */
    public function sceneToLocal(point:Point):Point
    {
        point.x /= scene.sceneWidth
        point.y /= scene.sceneHeight
        var p:Point = viewport.sceneToLocal(point)
        p.x *= viewportWidth
        p.y *= viewportHeight

        return p
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewport / flash.geom.Rectangle
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function getBounds():Rectangle
    {
        return new Rectangle(x, y, width, height)
    }

    /**
     * @inheritDoc
     */
    public function getCenter():Point
    {
        return new Point(x + width / 2,
                         y + height / 2)
    }

    /**
     * @inheritDoc
     */
    public function contains(x:Number, y:Number):Boolean
    {
        return (x >= left) &&
               (x <= right) &&
               (y >= top) &&
               (y <= bottom)
    }

    /**
     * @inheritDoc
     */
    public function intersects(toIntersect:Rectangle):Boolean
    {
        var bounds:Rectangle = toIntersect.clone()

        bounds.x /= scene.sceneWidth
        bounds.y /= scene.sceneHeight
        bounds.width /= scene.sceneWidth
        bounds.height /= scene.sceneHeight

        return viewport.intersects(bounds)
    }

    /**
     * @inheritDoc
     */
    public function intersection(toIntersect:Rectangle):Rectangle
    {
        var bounds:Rectangle = toIntersect.clone()

        bounds.x /= scene.sceneWidth
        bounds.y /= scene.sceneHeight
        bounds.width /= scene.sceneWidth
        bounds.height /= scene.sceneHeight

        bounds = viewport.intersection(bounds)

        bounds.x *= scene.sceneWidth
        bounds.y *= scene.sceneHeight
        bounds.width *= scene.sceneWidth
        bounds.height *= scene.sceneHeight

        return bounds
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
        return viewport.x * scene.sceneWidth
    }

    public function set x(value:Number):void
    {
        viewport.x = value / scene.sceneWidth
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
       return viewport.y * scene.sceneHeight
    }

    public function set y(value:Number):void
    {
        viewport.y = value / scene.sceneHeight
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
        return viewport.width * scene.sceneWidth
    }

    public function set width(value:Number):void
    {
        viewport.width = value / scene.sceneWidth
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
        return viewport.height * scene.sceneHeight
    }

    public function set height(value:Number):void
    {
        viewport.height = value / scene.sceneHeight
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
        return viewport.left * scene.sceneWidth
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
        return viewport.right * scene.sceneWidth
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
        return viewport.top * scene.sceneHeight
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
        return viewport.bottom * scene.sceneHeight
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
        var p:Point = viewport.topLeft
        p.x *= scene.sceneWidth
        p.y *= scene.sceneHeight

        return p
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
        var p:Point = viewport.topLeft
        p.x *= scene.sceneWidth
        p.y *= scene.sceneHeight

        return p
    }

    //----------------------------------
    //  bottomRight
    //----------------------------------

    [Bindable(event="transformUpdate")]

    /**
     * @inheritDoc
     */
    public function get center():Point
    {
        var p:Point = viewport.center
        p.x *= scene.sceneWidth
        p.y *= scene.sceneHeight

        return p
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
        viewport.beginTransform()
    }

    /**
     * @inheritDoc
     */
    public function endTransform():void
    {
        viewport.endTransform()
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
        return "[SceneViewport]" + "\n" +
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
    	// TODO
    }
}

}

class SingletonLock {}
