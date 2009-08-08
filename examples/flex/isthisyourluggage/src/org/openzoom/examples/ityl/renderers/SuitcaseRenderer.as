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
package org.openzoom.examples.ityl.renderers
{

import caurina.transitions.Tweener;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;

import org.openzoom.examples.ityl.Suitcase;
import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.viewport.ISceneViewport;
import org.openzoom.flash.viewport.SceneViewport;


public class SuitcaseRenderer extends Renderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function SuitcaseRenderer(data:Suitcase)
    {
        this.data = data

        buttonMode = true

        suitcase = data.image
        suitcase.smoothing = true
        addChild(suitcase)

        addEventListener(RendererEvent.ADDED_TO_SCENE,
                         addedToSceneHandler,
                         false, 0, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var loader:Loader
    private var data:Suitcase
    private var suitcase:Bitmap
    private var content:Bitmap

    private static var focusedSuitcase:SuitcaseRenderer

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function open():void
    {
        if (!loader)
        {
            loader = new Loader()
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
                                                      loader_completeHandler,
                                                      false, 0, true)

            var uri:String = "images/suitcases/" + data.name + "-content.png"
            loader.load(new URLRequest(uri))
        }


        if (!content)
           return

        Tweener.addTween(suitcase, {alpha: 0, time: 0.4})
    }

    private function close():void
    {
        if (!content)
           return

        Tweener.addTween(suitcase, {alpha: 1, time: 0.6})
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function addedToSceneHandler(event:RendererEvent):void
    {
        viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                  viewport_transformUpdateHandler,
                                  false, 0, true)

        viewport.addEventListener(ViewportEvent.TRANSFORM_END,
                                  viewport_transformEndHandler,
                                  false, 0, true)

        addEventListener(MouseEvent.CLICK,
                         clickHandler,
                         false, 0, true)
    }

    private function viewport_transformEndHandler(event:ViewportEvent):void
    {
        if (focusedSuitcase === this && zoom < 0.4)
            close()
    }

    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
        var sceneViewport:ISceneViewport = SceneViewport.getInstance(viewport)
        var sceneViewportBounds:Rectangle = sceneViewport.getBounds()
        var bounds:Rectangle = getBounds(scene.targetCoordinateSpace)

        var focused:Boolean = bounds.containsRect(sceneViewportBounds)

        if (focused)
            focusedSuitcase = this
    }

    private function clickHandler(event:MouseEvent):void
    {
        var sceneViewport:ISceneViewport = SceneViewport.getInstance(viewport)
        var bounds:Rectangle = getBounds(scene.targetCoordinateSpace)
        var sceneBounds:Rectangle = sceneViewport.getBounds()

        var center:Point = new Point()
        center.x = bounds.x + bounds.width / 2,
        center.y = bounds.y + bounds.height / 2

        var viewportCenter:Point = new Point()
        viewportCenter.x = sceneBounds.x + sceneBounds.width / 2,
        viewportCenter.y = sceneBounds.y + sceneBounds.height / 2

        if (zoom > 0.6 && zoom < 2)
            sceneViewport.panCenterTo(center.x, center.y)

        if (zoom < 0.6)
            sceneViewport.fitToBounds(bounds, 0.6)

        if (focusedSuitcase !== this)
        {
            if (focusedSuitcase)
                focusedSuitcase.close()
            focusedSuitcase = this
        }

        open()
    }

    private function loader_completeHandler(event:Event):void
    {
        Tweener.addTween(suitcase, {alpha: 0, time: 1})
        content = loader.content as Bitmap
        loader.unload()

        content.scaleX = content.scaleY = Math.min(width / content.width,
                                                   height / content.height) * 0.8
        content.x = (width - content.width) / 2
        content.y = (height - content.height) / 2

        addChildAt(content, 0)
    }
}

}
