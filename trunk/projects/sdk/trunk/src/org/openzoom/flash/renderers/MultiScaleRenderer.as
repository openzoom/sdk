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
import flash.display.Sprite;

import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * @private
 *
 * Multiscale renderer base class.
 */
public class MultiScaleRenderer extends Sprite
                                implements IMultiScaleRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleRenderer()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleRenderer
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport:INormalizedViewport

    /**
     * @inheritDoc
     */
    public function get viewport():INormalizedViewport
    {
        return _viewport
    }

    public function set viewport(value:INormalizedViewport):void
    {
        if (viewport === value)
            return

        // remove old event listener
        if (viewport)
        {
            viewport.removeEventListener(ViewportEvent.TRANSFORM_START,
                                         viewport_transformStartHandler)
            viewport.removeEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                         viewport_transformUpdateHandler)
            viewport.removeEventListener(ViewportEvent.TRANSFORM_END,
                                         viewport_transformEndHandler)
            viewport.removeEventListener(ViewportEvent.TARGET_UPDATE,
                                         viewport_targetUpdateHandler)
        }

        _viewport = value

        // register new event listener
        if (viewport)
        {
            viewport.addEventListener(ViewportEvent.TRANSFORM_START,
                                      viewport_transformStartHandler,
                                      false, 0, true)
            viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                      viewport_transformUpdateHandler,
                                      false, 0, true)
            viewport.addEventListener(ViewportEvent.TRANSFORM_END,
                                      viewport_transformEndHandler,
                                      false, 0, true)
            viewport.addEventListener(ViewportEvent.TARGET_UPDATE,
                                      viewport_targetUpdateHandler,
                                      false, 0, true)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    protected function viewport_transformStartHandler(event:ViewportEvent):void
    {
    }

    /**
     * @private
     */
    protected function viewport_transformUpdateHandler(event:ViewportEvent):void
    {
    }

    /**
     * @private
     */
    protected function viewport_transformEndHandler(event:ViewportEvent):void
    {
    }

    /**
     * @private
     */
    protected function viewport_targetUpdateHandler(event:ViewportEvent):void
    {
    }
}

}