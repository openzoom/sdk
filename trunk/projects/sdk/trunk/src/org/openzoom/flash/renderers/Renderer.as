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

import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;

/**
 * Renderer base class.
 */
public class Renderer extends Sprite
                      implements IRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function Renderer()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IRenderer
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  scene
    //----------------------------------

    private var _scene:IReadonlyMultiScaleScene

    /**
     * @inheritDoc
     */
    public function get scene():IReadonlyMultiScaleScene
    {
        return _scene
    }
    
    public function set scene(value:IReadonlyMultiScaleScene):void
    {
        if (scene === value)
            return
        
        _scene = value
        
        dispatchEvent(new RendererEvent(RendererEvent.ADDED_TO_SCENE))
    }

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

        _viewport = value
    }
}

}
