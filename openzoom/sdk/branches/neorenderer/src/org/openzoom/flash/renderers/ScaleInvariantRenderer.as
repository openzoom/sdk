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
package org.openzoom.flash.renderers
{

import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.events.ViewportEvent;

/**
 * Base class for all renderers that should preserve their size on a
 * multiscale scene, e.g. map markers, hotspots, etc.
 */
public class ScaleInvariantRenderer extends Renderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ScaleInvariantRenderer()
    {
        addEventListener(RendererEvent.ADDED_TO_SCENE,
                         addedToSceneHandler,
                         false, 0, true)
        addEventListener(RendererEvent.REMOVED_FROM_SCENE,
                         removedFromSceneHandler,
                         false, 0, true)
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function addedToSceneHandler(event:RendererEvent):void
    {
        viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                  viewport_transformUpdateHandler,
                                  false, 0, true)
        updateDisplayList()
    }

    /**
     * @private
     */
    private function removedFromSceneHandler(event:RendererEvent):void
    {
        viewport.removeEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                     viewport_transformUpdateHandler)
    }

    /**
     * @private
     */
    private function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
        updateDisplayList()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Layout
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function updateDisplayList():void
    {
        scaleX = scaleY = 1 / viewport.scale
    }
}

}