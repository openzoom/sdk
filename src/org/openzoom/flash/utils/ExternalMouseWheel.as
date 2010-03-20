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
//
//  The MIT License
//
//  Copyright (c) 2008, Takanobu Izukawa <http://humming.via-kitchen.com/>
//                      Spark project <www.libspark.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.utils
{

import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.system.Capabilities;

import org.openzoom.flash.core.openzoom_internal;

use namespace openzoom_internal;

/**
 * The ExternalMouseWheel class provices support for the mouse wheel on systems
 * where the Flash Player does not natively support this capability. Refactored
 * for the use in OpenZoom from SWFWheel class in LibSpark project using the
 * ActionScript / JavaScript ExternalInterface injection technique described in
 * the following article:
 *
 * @see http://www.actionscript.org/resources/articles/745/1/JavaScript-and-VBScript-Injection-in-ActionScript-3/Page1.html
 */
public final class ExternalMouseWheel extends EventDispatcher
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    // Singleton instance
    private static var instance:ExternalMouseWheel

    // External functions
    private static const EXECUTE_FUNCTION:String = "ExternalMouseWheel.join"
    private static const FORCE_FUNCTION:String = "ExternalMouseWheel.force"
    private static const HANDLER_FUNCTION:String = "externalMouseEvent"

    // External script
    private static const EXTERNAL_SCRIPT:XML =
    <script>
        <![CDATA[

        function() {
            if (window.ExternalMouseWheel)
                return;
            var win = window;
            var doc = document;
            var nav = navigator;
            var ExternalMouseWheel = window.ExternalMouseWheel = function(id) {
                this.setUp(id);
                if (ExternalMouseWheel.browser.msie)
                    this.bind4msie();
                else
                    this.bind();
            };

            ExternalMouseWheel.prototype = {
                setUp: function(id) {
                    var el = doc.getElementById(id);
                    if (el.nodeName.toLowerCase() == 'embed' ||
                        ExternalMouseWheel.browser.safari)
                        el = el.parentNode;
                    this.target = el;
                    this.eventType = ExternalMouseWheel.browser.mozilla
                                       ? 'DOMMouseScroll' : 'mousewheel';
                },
                bind: function() {
                    this.target.addEventListener(this.eventType,
                    function(evt) {
                        var target, name, delta = 0;
                        if (/XPCNativeWrapper/.test(evt.toString())) {
                            if (!evt.target.id)
                                return;
                            target = doc.getElementById(evt.target.id);
                        } else {
                            target = evt.target;
                        }
                        name = target.nodeName.toLowerCase();
                        if (name != 'object' && name != 'embed') return;
                        evt.preventDefault();
                        evt.returnValue = false;
                        if (!target.externalMouseEvent)
                            return;
                        switch (true) {
                        case ExternalMouseWheel.browser.mozilla:
                            delta = -evt.detail;
                            break;
                        default:
                            delta = evt.wheelDelta / 80;
                            break;
                        }
                        target.externalMouseEvent(delta);
                    },
                    false);
                },
                bind4msie: function() {
                    var _wheel, _unload, target = this.target;
                    _wheel = function() {
                        var evt = win.event,
                        delta = 0,
                        name = evt.srcElement.nodeName.toLowerCase();
                        if (name != 'object' && name != 'embed')
                            return;
                        evt.returnValue = false;
                        if (!target.externalMouseEvent)
                            return;
                        delta = evt.wheelDelta / 80;
                        target.externalMouseEvent(delta);
                    };
                    _unload = function() {
                        target.detachEvent('onmousewheel', _wheel);
                        win.detachEvent('onunload', _unload);
                    };
                    target.attachEvent('onmousewheel', _wheel);
                    win.attachEvent('onunload', _unload);
                }
            };

            ExternalMouseWheel.browser = (function(ua) {
                return {
                    chrome:    /chrome/.test(ua),
                    stainless: /stainless/.test(ua),
                    safari:    /webkit/.test(ua) && !/(chrome|stainless)/.test(ua),
                    opera:     /opera/.test(ua),
                    msie:      /msie/.test(ua) && !/opera/.test(ua),
                    mozilla:   /mozilla/.test(ua) && !/(compatible|webkit)/.test(ua)
                }
            })(nav.userAgent.toLowerCase());

            ExternalMouseWheel.join = function(id) {
                var t = setInterval(function() {
                    if (doc.getElementById(id)) {
                        clearInterval(t);
                        new ExternalMouseWheel(id);
                    }
                },
                0);
            };

            ExternalMouseWheel.force = function(id) {
                if (ExternalMouseWheel.browser.safari
                    || ExternalMouseWheel.browser.stainless)
                    return true;
                var el = doc.getElementById(id),
                name = el.nodeName.toLowerCase();
                if (name == 'object')
                {
                    var k, v, param, params = el.getElementsByTagName('param');
                    for (var i = 0; i < params.length; i++) {
                        param = params[i];
                        k = param.getAttribute('name');
                        v = param.getAttribute('value') || '';
                        if (/wmode/i.test(k) && /(opaque|transparent)/i.test(v))
                            return true;
                    }
                }
                else if (name == 'embed')
                {
                    return /(opaque|transparent)/i.test(el.getAttribute('wmode'));
                }
                return false;
            };
        }
        ]]>
    </script>;


    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ExternalMouseWheel(stage:Stage,
                                       enforcer:SingletonEnforcer)
    {
        if (!ExternalInterface.available || !stage)
            return

        try
        {
            // Inject script
            ExternalInterface.call(EXTERNAL_SCRIPT)

            // Initialize external script
            ExternalInterface.call(EXECUTE_FUNCTION,
                                    ExternalInterface.objectID)

            var os:String = Capabilities.os.toLowerCase()
            var isMac:Boolean = os.indexOf("mac") != -1

            var force:Boolean =
                 ExternalInterface.call(FORCE_FUNCTION,
                                        ExternalInterface.objectID) as Boolean

            // Ignore if not Mac OS or Safari
            if (!isMac && !force)
                return

            this.stage = stage
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,
                                         stage_mouseMoveHandler,
                                         false, 0, true)

            ExternalInterface.addCallback(HANDLER_FUNCTION,
                                           externalMouseEventHandler)
        }
        catch(error:Error)
        {
            // Do nothing
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var stage:Stage
    private var currentItem:InteractiveObject
    private var clonedEvent:MouseEvent

    //--------------------------------------------------------------------------
    //
    //  Methods: Initialization
    //
    //--------------------------------------------------------------------------

    /**
     * Initialize this class once in your application.
     * Make sure that your embedded Flash movie has an
     * <code>id</code> and <code>name</code>.
     */
    public static function initialize(stage:Stage):void
    {
        if (!instance)
            instance = new ExternalMouseWheel(stage, new SingletonEnforcer())
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function stage_mouseMoveHandler(event:MouseEvent):void
    {
        currentItem = InteractiveObject(event.target)
        clonedEvent = MouseEvent(event)
    }

    /**
     * @private
     */
    private function externalMouseEventHandler(delta:Number):void
    {
        if (!clonedEvent)
            return

        var mouseWheelEvent:MouseEvent =
                                    new MouseEvent(MouseEvent.MOUSE_WHEEL,
                                                   true,
                                                   false,
                                                   clonedEvent.localX,
                                                   clonedEvent.localY,
                                                   clonedEvent.relatedObject,
                                                   clonedEvent.ctrlKey,
                                                   clonedEvent.altKey,
                                                   clonedEvent.shiftKey,
                                                   clonedEvent.buttonDown,
                                                   int(delta))

        currentItem.dispatchEvent(mouseWheelEvent)
    }
}

}

//------------------------------------------------------------------------------
//
//  Internal classes: Singleton support
//
//------------------------------------------------------------------------------

class SingletonEnforcer
{
}
