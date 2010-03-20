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
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.ContextMenu;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.net.ILoaderClient;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.utils.IDisposable;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransformer;

use namespace openzoom_internal;

/**
 * @private
 *
 * Base class for MultiScaleImage and DeepZoomContainer.
 */
internal class MultiScaleImageBase extends Sprite
                                   implements IMultiScaleContainer,
                                              ILoaderClient,
                                              IDisposable
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    protected static const DEFAULT_SCENE_DIMENSION:Number = 16384 // 2^14

    private static const DEFAULT_VIEWPORT_WIDTH:Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT:Number = 600

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
        createChildren()
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var container:MultiScaleContainer

    //--------------------------------------------------------------------------
    //
    //  Properties: ILoaderClient
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  loader
    //----------------------------------

    public function get loader():INetworkQueue
    {
        return container ? container.loader : null
    }

    public function set loader(value:INetworkQueue):void
    {
        if (container)
            container.loader = value
    }

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
        return container ? container.scene.sceneWidth : NaN
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneHeight
     */
    public function get sceneHeight():Number
    {
        return container ? container.scene.sceneHeight : NaN
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Viewport
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

    /**
     * Viewport of this image.
     */
    public function get viewport():INormalizedViewport
    {
        return container.viewport
    }

    //----------------------------------
    //  transformer
    //----------------------------------

    /**
     * Viewport transformer. Transformers are used to create the transitions
     * between transformations of the viewport.
     *
     * @see org.openzoom.flash.viewport.transformers.TweenerTransformer
     * @see org.openzoom.flash.viewport.transformers.NullTransformer
     */
    public function get transformer():IViewportTransformer
    {
        return viewport.transformer
    }

    public function set transformer(value:IViewportTransformer):void
    {
        if (transformer !== value)
            viewport.transformer = value
    }

    //----------------------------------
    //  constraint
    //----------------------------------

    /**
     * Viewport transformer constraint. Constraints are used to control
     * the positions and zoom levels the viewport can reach.
     *
     * @see org.openzoom.flash.viewport.constraints.VisibilityConstraint
     * @see org.openzoom.flash.viewport.constraints.ZoomConstraint
     * @see org.openzoom.flash.viewport.constraints.ScaleConstraint
     * @see org.openzoom.flash.viewport.constraints.CompositeConstraint
     * @see org.openzoom.flash.viewport.constraints.NullConstraint
     */
    public function get constraint():IViewportConstraint
    {
        return viewport.transformer.constraint
    }

    public function set constraint(value:IViewportConstraint):void
    {
        if (constraint !== value)
            viewport.transformer.constraint = value
    }

    //----------------------------------
    //  controllers
    //----------------------------------

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
        return container.controllers
    }

    public function set controllers(value:Array):void
    {
        container.controllers = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function createChildren():void
    {
        if (!container)
            createContainer()
    }

    /**
     * @private
     */
    private function createContainer():void
    {
        container = new MultiScaleContainer()
        super.addChild(container)
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
        return container.width
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
        return container.height
    }

    override public function set height(value:Number):void
    {
        setActualSize(width, value)
    }

    //----------------------------------
    //  contextMenu
    //----------------------------------

    override public function get contextMenu():ContextMenu
    {
        return container.contextMenu
    }

    override public function set contextMenu(value:ContextMenu):void
    {
        container.contextMenu = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public function setActualSize(width:Number, height:Number):void
    {
        if (this.width == width && this.height == height)
            return

        container.setActualSize(width, height)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleImage
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
        return viewport.scale
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

    /**
     * @inheritDoc
     */
    override public function get numChildren():int
    {
        return container ? container.numChildren : 0
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
    	container.dispose()
    	container = null
    	
    	loader = null
    }
}

}
