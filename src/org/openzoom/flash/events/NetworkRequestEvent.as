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
package org.openzoom.flash.events
{

import flash.events.Event;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.net.INetworkRequest;

use namespace openzoom_internal;

/**
 * @private
 *
 * NetworkRequest event class.
 */
public final class NetworkRequestEvent extends Event
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    public static const COMPLETE:String = "complete"
    public static const ERROR:String = "error"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function NetworkRequestEvent(type:String,
                                        bubbles:Boolean=false,
                                        cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable)
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     * Request this event belongs to.
     */
    public var request:INetworkRequest

    /**
     * Data that the event is carrying.
     */
    public var data:* = null

    /**
     * Context of this request event.
     * Useful for identifying certain requests, e.g. by URL.
     */
    public var context:* = null

    //--------------------------------------------------------------------------
    //
    //  Methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function clone():Event
    {
        return new NetworkRequestEvent(type, bubbles, cancelable)
    }
}

}
