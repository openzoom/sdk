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

import flash.geom.Point
import flash.geom.Rectangle

import org.openzoom.flash.viewport.INormalizedViewport
import org.openzoom.flash.viewport.IViewportConstraint
import org.openzoom.flash.viewport.IViewportTransformer

/**
 * @private
 *
 * Interface of a multiscale container.
 */
public interface IMultiScaleContainer
{
    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sceneWidth
    //----------------------------------

    /**
     * Width of the scene belonging to this container.
     */
    function get sceneWidth():Number

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    /**
     * Height of the scene belonging to this container.
     */
    function get sceneHeight():Number

    //--------------------------------------------------------------------------
    //
    //  Properties: Viewport
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

    /**
     * Viewport belonging to this container.
     */
    function get viewport():INormalizedViewport

    //----------------------------------
    //  constraint
    //----------------------------------

    /**
     * Viewport constraint.
     */
    function get constraint():IViewportConstraint
    function set constraint(value:IViewportConstraint):void

    //----------------------------------
    //  transformer
    //----------------------------------

    /**
     * Viewport transformer.
     */
    function get transformer():IViewportTransformer
    function set transformer(value:IViewportTransformer):void

    //----------------------------------
    //  zoom
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoom
     */
    function get zoom():Number
    function set zoom(value:Number):void

    //----------------------------------
    //  scale
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#scale
     */
    function get scale():Number
    function set scale(value:Number):void

    //----------------------------------
    //  viewportX
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#x
     */
    function get viewportX():Number
    function set viewportX(value:Number):void

    //----------------------------------
    //  viewportY
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    function get viewportY():Number
    function set viewportY(value:Number):void

    //----------------------------------
    //  viewportWidth
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    function get viewportWidth():Number
    function set viewportWidth(value:Number):void

    //----------------------------------
    //  viewportHeight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    function get viewportHeight():Number
    function set viewportHeight(value:Number):void

    //--------------------------------------------------------------------------
    //
    //  Methods: Viewport
    //
    //--------------------------------------------------------------------------

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomTo()
     */
    function zoomTo(zoom:Number,
                    transformX:Number=0.5,
                    transformY:Number=0.5,
                    immediately:Boolean=false):void

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomBy()
     */
    function zoomBy(factor:Number,
                    transformX:Number=0.5,
                    transformY:Number=0.5,
                    immediately:Boolean=false):void

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panTo()
     */
    function panTo(x:Number, y:Number,
                   immediately:Boolean=false):void

    /**
     * @copy org.openzoom.flash.viewport.IViewport#fitToBounds()
     */
    function fitToBounds(bounds:Rectangle,
                         scale:Number=1.0,
                         immediately:Boolean = false):void

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showAll()
     */
    function showAll(immediately:Boolean = false):void

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panBy()
     */
    function panBy(deltaX:Number, deltaY:Number,
                   immediately:Boolean=false):void

    /**
     * @copy org.openzoom.flash.viewport.IViewport#localToScene()
     */
    function localToScene(point:Point):Point

    /**
     * @copy org.openzoom.flash.viewport.IViewport#sceneToLocal()
     */
    function sceneToLocal(point:Point):Point
}

}
