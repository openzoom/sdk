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

import flash.display.DisplayObjectContainer;
import flash.display.StageDisplayState;
import flash.errors.IllegalOperationError;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.utils.FullScreenUtil;
import org.openzoom.flash.viewport.IViewportController;

use namespace openzoom_internal;

/**
 * Context menu controller for viewports.
 */
public final class ContextMenuController extends ViewportControllerBase
                                         implements IViewportController
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static var FULL_SCREEN_MENU_ENTER_CAPTION:String = "Fullscreen"
    private static var FULL_SCREEN_MENU_ENTER_KEY:String = "F"

    private static var FULL_SCREEN_MENU_EXIT_CAPTION:String = "Exit Fullscreen"
    private static var FULL_SCREEN_MENU_EXIT_KEY:String = "Esc"

    private static var SHOW_ALL_MENU_CAPTION:String = "Show All"
    private static var SHOW_ALL_MENU_KEY:String = "H"

    private static var ZOOM_IN_MENU_CAPTION:String = "Zoom In"
    private static var ZOOM_IN_MENU_KEY:String = "I / +"
    private static var ZOOM_OUT_MENU_CAPTION:String = "Zoom Out"
    private static var ZOOM_OUT_MENU_KEY:String = "O / -"

    private static var PAN_UP_MENU_CAPTION:String = "Pan Up"
    private static var PAN_UP_MENU_KEY:String = "W / Up"
    private static var PAN_DOWN_MENU_CAPTION:String = "Pan Down"
    private static var PAN_DOWN_MENU_KEY:String = "S / Down"
    private static var PAN_LEFT_MENU_CAPTION:String = "Pan Left"
    private static var PAN_LEFT_MENU_KEY:String = "A / Left"
    private static var PAN_RIGHT_MENU_CAPTION:String = "Pan Right"
    private static var PAN_RIGHT_MENU_KEY:String = "D / Right"

    private static const DEFAULT_ZOOM_IN_FACTOR:Number = 2.0
    private static const DEFAULT_ZOOM_OUT_FACTOR:Number = 0.3
    private static const DEFAULT_PAN_FACTOR:Number = 0.1

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     * Constructor.
     */
    public function ContextMenuController()
    {
        var tab1:String = "\t"
        var tab2:String = "\t\t"
        var tab3:String = "\t\t\t"
        var tab4:String = "\t\t\t\t"

        // Default setup, e.g. Mac OS
        _fullScreenMenuEnterCaption = FULL_SCREEN_MENU_ENTER_CAPTION +
                                      tab3 + FULL_SCREEN_MENU_ENTER_KEY
        _fullScreenMenuExitCaption = FULL_SCREEN_MENU_EXIT_CAPTION +
                                     tab2 + FULL_SCREEN_MENU_EXIT_KEY

        _showAllMenuCaption = SHOW_ALL_MENU_CAPTION + tab3 + SHOW_ALL_MENU_KEY

        _zoomInMenuCaption = ZOOM_IN_MENU_CAPTION + tab4 + ZOOM_IN_MENU_KEY
        _zoomOutMenuCaption = ZOOM_OUT_MENU_CAPTION + tab3 + ZOOM_OUT_MENU_KEY

        _panUpMenuCaption = PAN_UP_MENU_CAPTION + tab4 + PAN_UP_MENU_KEY
        _panDownMenuCaption = PAN_DOWN_MENU_CAPTION + tab3 + PAN_DOWN_MENU_KEY
        _panLeftMenuCaption = PAN_LEFT_MENU_CAPTION + tab4 + PAN_LEFT_MENU_KEY
        _panRightMenuCaption = PAN_RIGHT_MENU_CAPTION + tab3 + PAN_RIGHT_MENU_KEY

        if (Capabilities.os.indexOf("Linux") != -1)
        {
            _fullScreenMenuEnterCaption = FULL_SCREEN_MENU_ENTER_CAPTION +
                                          tab3 + FULL_SCREEN_MENU_ENTER_KEY
            _fullScreenMenuExitCaption = FULL_SCREEN_MENU_EXIT_CAPTION +
                                         tab2 + FULL_SCREEN_MENU_EXIT_KEY

            _showAllMenuCaption = SHOW_ALL_MENU_CAPTION + tab4 + SHOW_ALL_MENU_KEY

            _zoomInMenuCaption = ZOOM_IN_MENU_CAPTION + tab4 + ZOOM_IN_MENU_KEY
            _zoomOutMenuCaption = ZOOM_OUT_MENU_CAPTION + tab3 + ZOOM_OUT_MENU_KEY

            _panUpMenuCaption = PAN_UP_MENU_CAPTION + tab4 + PAN_UP_MENU_KEY
            _panDownMenuCaption = PAN_DOWN_MENU_CAPTION + tab3 + PAN_DOWN_MENU_KEY
            _panLeftMenuCaption = PAN_LEFT_MENU_CAPTION + tab4 + PAN_LEFT_MENU_KEY
            _panRightMenuCaption = PAN_RIGHT_MENU_CAPTION + tab3 + PAN_RIGHT_MENU_KEY
        }

        if (Capabilities.os.indexOf("Windows") != -1)
        {
            _fullScreenMenuEnterCaption = FULL_SCREEN_MENU_ENTER_CAPTION +
                                          tab1 + FULL_SCREEN_MENU_ENTER_KEY
            _fullScreenMenuExitCaption = FULL_SCREEN_MENU_EXIT_CAPTION +
                                         tab1 + FULL_SCREEN_MENU_EXIT_KEY

            _showAllMenuCaption = SHOW_ALL_MENU_CAPTION + tab1 + SHOW_ALL_MENU_KEY

            _zoomInMenuCaption = ZOOM_IN_MENU_CAPTION + tab1 + ZOOM_IN_MENU_KEY
            _zoomOutMenuCaption = ZOOM_OUT_MENU_CAPTION + tab1 + ZOOM_OUT_MENU_KEY

            _panUpMenuCaption = PAN_UP_MENU_CAPTION + tab1 + PAN_UP_MENU_KEY
            _panDownMenuCaption = PAN_DOWN_MENU_CAPTION + tab1+ PAN_DOWN_MENU_KEY
            _panLeftMenuCaption = PAN_LEFT_MENU_CAPTION + tab1 + PAN_LEFT_MENU_KEY
            _panRightMenuCaption = PAN_RIGHT_MENU_CAPTION + tab1 + PAN_RIGHT_MENU_KEY
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    // context menu
    private var menu:ContextMenu

    // display mode
    private var showAllMenu:ContextMenuItem
    private var fullScreenMenu:ContextMenuItem

    // zooming
    private var zoomInMenu:ContextMenuItem
    private var zoomOutMenu:ContextMenuItem

    // panning
    private var panDownMenu:ContextMenuItem
    private var panUpMenu:ContextMenuItem
    private var panLeftMenu:ContextMenuItem
    private var panRightMenu:ContextMenuItem

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoomInFactor
    //----------------------------------

    public var zoomInFactor:Number = DEFAULT_ZOOM_IN_FACTOR

    //----------------------------------
    //  zoomOutFactor
    //----------------------------------

    public var zoomOutFactor:Number = DEFAULT_ZOOM_OUT_FACTOR

    //----------------------------------
    //  panFactor
    //----------------------------------

    public var panFactor:Number = DEFAULT_PAN_FACTOR

    //----------------------------------
    //  showAll
    //----------------------------------

    private var _showAll:Boolean = true

    public function get showAll():Boolean
    {
        return _showAll;
    }

    public function set showAll(value:Boolean):void
    {
        if (value === _showAll)
            return

        _showAll = value;

        if (!menu)
            return

        if (_showAll)
           showAllMenu = addContextMenuItem(showAllMenuCaption,
                                            showAllMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(showAllMenu,
                                  showAllMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  fullScreen
    //----------------------------------

    private var _fullScreen:Boolean = true

    public function get fullScreen():Boolean
    {
        return _fullScreen;
    }

    public function set fullScreen(value:Boolean):void
    {
        if (value === _fullScreen)
            return

        _fullScreen = value;

        if (!menu)
            return

        if (_fullScreen)
            fullScreenMenu = addContextMenuItem(view.stage.displayState == StageDisplayState.NORMAL ?
                                                fullScreenMenuEnterCaption:fullScreenMenuExitCaption,
                                                fullScreenMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(fullScreenMenu,
                                  fullScreenMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  zoomIn
    //----------------------------------

    private var _zoomIn:Boolean = true

    public function get zoomIn():Boolean
    {
        return _zoomIn;
    }

    public function set zoomIn(value:Boolean):void
    {
        if (value === _zoomIn)
            return

        _zoomIn = value;

        if (!menu)
            return

        if (_zoomIn)
            zoomInMenu = addContextMenuItem(zoomInMenuCaption,
                                            zoomInMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(zoomInMenu,
                                  zoomInMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  zoomOut
    //----------------------------------

    private var _zoomOut:Boolean = true

    public function get zoomOut():Boolean
    {
        return _zoomOut;
    }

    public function set zoomOut(value:Boolean):void
    {
        if (value === _zoomOut)
            return

        _zoomOut = value;

        if (!menu)
            return

        if (_zoomOut)
            zoomOutMenu = addContextMenuItem(zoomOutMenuCaption,
                                             zoomOutMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(zoomOutMenu,
                                  zoomOutMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  panDown
    //----------------------------------

    private var _panDown:Boolean = true

    public function get panDown():Boolean
    {
        return _panDown;
    }

    public function set panDown(value:Boolean):void
    {
        if (value === _panDown)
            return

        _panDown = value;

        if (!menu)
            return

        if (_panDown)
            panDownMenu = addContextMenuItem(panDownMenuCaption,
                                             panDownMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(panDownMenu,
                                  panDownMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  panUp
    //----------------------------------

    private var _panUp:Boolean = true

    public function get panUp():Boolean
    {
        return _panUp;
    }

    public function set panUp(value:Boolean):void
    {
        if (value === _panUp)
            return

        _panUp = value;

        if (!menu)
            return

        if (_panUp)
            panUpMenu = addContextMenuItem(panUpMenuCaption,
                                           panUpMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(panUpMenu,
                                  panUpMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  panLeft
    //----------------------------------

    private var _panLeft:Boolean = true

    public function get panLeft():Boolean
    {
        return _panLeft;
    }

    public function set panLeft(value:Boolean):void
    {
        if (value === _panLeft)
            return

        _panLeft = value;

        if (!menu)
            return

        if (_panLeft)
            panLeftMenu = addContextMenuItem(panLeftMenuCaption,
                                             panLeftMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(panLeftMenu,
                                  panLeftMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  panRight
    //----------------------------------

    private var _panRight:Boolean = true

    public function get panRight():Boolean
    {
        return _panRight;
    }

    public function set panRight(value:Boolean):void
    {
        if (value === _panRight)
            return

        _panRight = value;

        if (!menu)
            return

        if (_panRight)
            panRightMenu = addContextMenuItem(panRightMenuCaption,
                                              panRightMenu_menuItemSelectHandler)
        else
            removeContextMenuItem(panRightMenu,
                                  panRightMenu_menuItemSelectHandler)
    }

    //----------------------------------
    //  showAllMenuCaption
    //----------------------------------

    private var _showAllMenuCaption:String

    public function get showAllMenuCaption():String
    {
        return _showAllMenuCaption
    }

    public function set showAllMenuCaption(value:String):void
    {
        if (value === _showAllMenuCaption)
            return

        _showAllMenuCaption = value

        if (showAllMenu)
            showAllMenu.caption = _showAllMenuCaption
    }

    //----------------------------------
    //  fullScreenMenuEnterCaption
    //----------------------------------

    private var _fullScreenMenuEnterCaption:String

    public function get fullScreenMenuEnterCaption():String
    {
        return _fullScreenMenuEnterCaption
    }

    public function set fullScreenMenuEnterCaption(value:String):void
    {
        if (value == _fullScreenMenuEnterCaption)
            return

        _fullScreenMenuEnterCaption = value

        if (fullScreenMenu && view.stage.displayState == StageDisplayState.NORMAL)
            fullScreenMenu.caption = _fullScreenMenuEnterCaption
    }

    //----------------------------------
    //  fullScreenMenuExitCaption
    //----------------------------------

    private var _fullScreenMenuExitCaption:String

    public function get fullScreenMenuExitCaption():String
    {
        return _fullScreenMenuExitCaption
    }

    public function set fullScreenMenuExitCaption(value:String):void
    {
        if (value == _fullScreenMenuExitCaption)
            return

        _fullScreenMenuExitCaption = value

        if (fullScreenMenu &&
            (view.stage.displayState == StageDisplayState.FULL_SCREEN ||
             view.stage.displayState == "fullScreenInteractive"))
            fullScreenMenu.caption = _fullScreenMenuExitCaption
    }

    //----------------------------------
    //  zoomInMenuCaption
    //----------------------------------

    private var _zoomInMenuCaption:String

    public function get zoomInMenuCaption():String
    {
        return _zoomInMenuCaption
    }

    public function set zoomInMenuCaption(value:String):void
    {
        if (value === _zoomInMenuCaption)
            return

        _zoomInMenuCaption = value

        if (zoomInMenu)
            zoomInMenu.caption = _zoomInMenuCaption
    }

    //----------------------------------
    //  zoomOutMenuCaption
    //----------------------------------

    private var _zoomOutMenuCaption:String

    public function get zoomOutMenuCaption():String
    {
        return _zoomOutMenuCaption
    }

    public function set zoomOutMenuCaption(value:String):void
    {
        if (value === _zoomOutMenuCaption)
            return

        _zoomOutMenuCaption = value

        if (zoomOutMenu)
            zoomOutMenu.caption = _zoomOutMenuCaption
    }

    //----------------------------------
    //  panDownMenuCaption
    //----------------------------------

    private var _panDownMenuCaption:String

    public function get panDownMenuCaption():String
    {
        return _panDownMenuCaption
    }

    public function set panDownMenuCaption(value:String):void
    {
        if (value === _panDownMenuCaption)
            return

        _panDownMenuCaption = value

        if (panDownMenu)
            panDownMenu.caption = _panDownMenuCaption
    }

    //----------------------------------
    //  panUpMenuCaption
    //----------------------------------

    private var _panUpMenuCaption:String

    public function get panUpMenuCaption():String
    {
        return _panUpMenuCaption
    }

    public function set panUpMenuCaption(value:String):void
    {
        if (value === _panUpMenuCaption)
            return

        _panUpMenuCaption = value

        if (panUpMenu)
            panUpMenu.caption = _panUpMenuCaption
    }

    //----------------------------------
    //  panLeftMenuCaption
    //----------------------------------

    private var _panLeftMenuCaption:String

    public function get panLeftMenuCaption():String
    {
        return _panLeftMenuCaption
    }

    public function set panLeftMenuCaption(value:String):void
    {
        if (value === _panLeftMenuCaption)
            return

        _panLeftMenuCaption = value

        if (panLeftMenu)
            panLeftMenu.caption = _panLeftMenuCaption
    }

    //----------------------------------
    //  panRightMenuCaption
    //----------------------------------

    private var _panRightMenuCaption:String

    public function get panRightMenuCaption():String
    {
        return _panRightMenuCaption
    }

    public function set panRightMenuCaption(value:String):void
    {
        if (value === _panRightMenuCaption)
            return

        _panRightMenuCaption = value

        if (panRightMenu)
            panRightMenu.caption = _panRightMenuCaption
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ViewportControllerBase
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function view_addedToStageHandler(event:Event):void
    {
        // Context Menu
        menu = new ContextMenu()
        menu.hideBuiltInItems()

        // Fullscreen
        view.stage.addEventListener(FullScreenEvent.FULL_SCREEN,
                                    stage_fullScreenHandler,
                                    false, 0, true)

        // Display state
        if (fullScreen)
            fullScreenMenu = addContextMenuItem(fullScreenMenuEnterCaption,
                                                fullScreenMenu_menuItemSelectHandler)

        if (showAll)
            showAllMenu = addContextMenuItem(showAllMenuCaption,
                                             showAllMenu_menuItemSelectHandler)

        // Zooming
        if (zoomIn)
            zoomInMenu = addContextMenuItem(zoomInMenuCaption,
                                            zoomInMenu_menuItemSelectHandler,
                                            true)

        if (zoomOut)
           zoomOutMenu = addContextMenuItem(zoomOutMenuCaption,
                                            zoomOutMenu_menuItemSelectHandler)

        // Panning
        if (panUp)
            panUpMenu = addContextMenuItem(panUpMenuCaption,
                                           panUpMenu_menuItemSelectHandler,
                                           true)

        if (panDown)
            panDownMenu = addContextMenuItem(panDownMenuCaption,
                                             panDownMenu_menuItemSelectHandler)

        if (panLeft)
            panLeftMenu = addContextMenuItem(panLeftMenuCaption,
                                             panLeftMenu_menuItemSelectHandler)

        if (panRight)
            panRightMenu = addContextMenuItem(panRightMenuCaption,
                                              panRightMenu_menuItemSelectHandler)

        if (view is DisplayObjectContainer)
            DisplayObjectContainer(view).contextMenu = menu
    }

    /**
     * @private
     */
    override protected function view_removedFromStageHandler(event:Event):void
    {
    	if (view && view.stage)
	        view.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,
	                                       stage_fullScreenHandler)


        if (showAll)
            removeContextMenuItem(showAllMenu,
                                  showAllMenu_menuItemSelectHandler)

        // Display state
        if (fullScreen)
            removeContextMenuItem(fullScreenMenu,
                                  fullScreenMenu_menuItemSelectHandler)

        // Zooming
        if (zoomIn)
            removeContextMenuItem(zoomInMenu,
                                  zoomInMenu_menuItemSelectHandler)

        if (zoomOut)
            removeContextMenuItem(zoomOutMenu,
                                  zoomOutMenu_menuItemSelectHandler)

        // Panning
        if (panUp)
            removeContextMenuItem(panUpMenu,
                                  panUpMenu_menuItemSelectHandler)

        if (panDown)
            removeContextMenuItem(panDownMenu,
                                  panDownMenu_menuItemSelectHandler)

        if (panLeft)
            removeContextMenuItem(panLeftMenu,
                                  panLeftMenu_menuItemSelectHandler)

        if (panRight)
            removeContextMenuItem(panRightMenu,
                                  panRightMenu_menuItemSelectHandler)

        menu = null
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers: Context Menu
    //
    //--------------------------------------------------------------------------

    // Display mode

    /**
     * @private
     */
    private function showAllMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        viewport.showAll()
    }

    /**
     * @private
     */
    private function fullScreenMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        FullScreenUtil.toggleFullScreen(view.stage)
    }

    // Zooming

    /**
     * @private
     */
    private function zoomInMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        var origin:Point = getMouseOrigin()
        viewport.zoomBy(zoomInFactor, origin.x, origin.y)
    }

    /**
     * @private
     */
    private function zoomOutMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        var origin:Point = getMouseOrigin()
        viewport.zoomBy(zoomOutFactor, origin.x, origin.y)
    }

    // Panning
    /**
     * @private
     */
    private function panUpMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        var dy:Number = viewport.height * panFactor
        viewport.panBy(0, -dy)
    }

    /**
     * @private
     */
    private function panDownMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        var dy:Number = viewport.height * panFactor
        viewport.panBy(0, dy)
    }

    /**
     * @private
     */
    private function panLeftMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        var dx:Number = viewport.width * panFactor
        viewport.panBy(-dx, 0)
    }

    /**
     * @private
     */
    private function panRightMenu_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        var dx:Number = viewport.width * panFactor
        viewport.panBy(dx, 0)
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function stage_fullScreenHandler(event:FullScreenEvent):void
    {
        if (event.fullScreen)
        {
            if (fullScreenMenu)
                fullScreenMenu.caption = fullScreenMenuExitCaption
        }
        else
        {
            if (fullScreenMenu)
                fullScreenMenu.caption = fullScreenMenuEnterCaption
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getMouseOrigin():Point
    {
        return new Point(view.mouseX / view.width,
                         view.mouseY / view.height)
    }

    /**
     * @private
     */
    private function addContextMenuItem(caption:String,
                                        menuItemSelectHandler:Function,
                                        separatorBefore:Boolean=false,
                                        enabled:Boolean=true,
                                        visible:Boolean=true):ContextMenuItem
    {
        var menuItem:ContextMenuItem = new ContextMenuItem(caption,
                                                           separatorBefore,
                                                           enabled,
                                                           visible)
        menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,
                                  menuItemSelectHandler,
                                  false, 0, true)
        menu.customItems.push(menuItem)
        return menuItem
    }

    /**
     * @private
     */
    private function removeContextMenuItem(menuItem:ContextMenuItem,
                                           menuItemSelectHandler:Function):void
    {
    	// FIXME
    	if (!menu)
    	   return

        var index:int = menu.customItems.indexOf(menuItem)
        if (index == -1)
            throw new IllegalOperationError("Context menu item does not exist.")

        menuItem.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT,
                                     menuItemSelectHandler)
        menu.customItems.splice(index, 1)
        menuItem = null
    }
}

}
