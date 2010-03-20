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
                         immediately:Boolean=false):void

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showAll()
     */
    function showAll(immediately:Boolean=false):void

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
