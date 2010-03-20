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
package org.openzoom.flash.viewport.controllers
{

import flash.display.DisplayObject;
import flash.events.Event;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.viewport.INormalizedViewport;

use namespace openzoom_internal;

/**
 * @private
 *
 * Base class for viewport controllers. For your own controller, extend
 * this class and implement org.openzoom.flash.viewport.IViewportController.
 *
 * @see org.openzoom.flash.viewport.IViewportController
 */
public class ViewportControllerBase
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
    * Constructor.
    */
    public function ViewportControllerBase():void
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport:INormalizedViewport

    /**
     * Indicates which viewport is controlled by this controller.
     */
    public function get viewport():INormalizedViewport
    {
        return _viewport
    }

    public function set viewport(value:INormalizedViewport):void
    {
        _viewport = value
    }

    //----------------------------------
    //  view
    //----------------------------------

    private var _view:DisplayObject

    /**
     * Indicates the display object this controller receives its events from.
     */
    public function get view():DisplayObject
    {
        return _view
    }

    public function set view(value:DisplayObject):void
    {
        if (view === value)
            return

        if (!value)
            view_removedFromStageHandler(null)

        _view = value

        if (value)
        {
            view.addEventListener(Event.ADDED_TO_STAGE,
                                  view_addedToStageHandler,
                                  false, 0, true)
            view.addEventListener(Event.REMOVED_FROM_STAGE,
                                  view_removedFromStageHandler,
                                  false, 0, true)

            if (view.stage)
                view_addedToStageHandler(null)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     *
     * Documentation not available.
     */
    protected function view_addedToStageHandler(event:Event):void
    {
    }

    /**
     * @private
     *
     * Documentation not available.
     */
    protected function view_removedFromStageHandler(event:Event):void
    {
    }
}

}
