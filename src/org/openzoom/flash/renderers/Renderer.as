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
package org.openzoom.flash.renderers
{
import flash.display.Sprite;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
import org.openzoom.flash.viewport.INormalizedViewport;

use namespace openzoom_internal;

//------------------------------------------------------------------------------
//
//  Events
//
//------------------------------------------------------------------------------

/**
 *  Dispatched when the renderer is added to the scene.
 *
 *  @eventType org.openzoom.flash.events.RendererEvent.ADDED_TO_SCENE
 */
[Event(name="addedToScene", type="org.openzoom.flash.events.RendererEvent")]

/**
 *  Dispatched when the renderer is removed from the scene.
 *
 *  @eventType org.openzoom.flash.events.RendererEvent.REMOVED_FROM_SCENE
 */
[Event(name="removedFromScene", type="org.openzoom.flash.events.RendererEvent")]

/**
 * Base class for all renderers on a multiscale scene.
 */
public class Renderer extends Sprite
                      implements IRenderer
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

        if (!value)
            dispatchEvent(new RendererEvent(RendererEvent.REMOVED_FROM_SCENE))

        _scene = value

        if (_scene)
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

    //----------------------------------
    //  zoom
    //----------------------------------

    /**
     * Returns the scale ratio of this renderer in respect to the viewport.
     *
     * @return Zoom value of this renderer. NaN if <code>scene</code> is <code>null</code>.
     */
    public function get zoom():Number
    {
        if (!viewport)
           return NaN

        var normalizedWidth:Number = width / scene.sceneWidth
        var normalizedHeight:Number = height / scene.sceneHeight

        return Math.max(normalizedWidth / viewport.width,
                        normalizedHeight / viewport.height)
    }
}

}
