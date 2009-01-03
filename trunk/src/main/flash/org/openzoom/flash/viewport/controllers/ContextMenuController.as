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
package org.openzoom.flash.viewport.controllers
{

import flash.display.DisplayObjectContainer;
import flash.display.StageDisplayState;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.geom.Point;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import org.openzoom.flash.viewport.IViewportController;

/**
 * Viewport controller that uses the context menu.
 */
public class ContextMenuController extends ViewportControllerBase
                                   implements IViewportController
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    // Context Menu
    private static const FULL_SCREEN_MENU_NORMAL_CAPTION : String = "Fullscreen\t\t\tF"
    private static const FULL_SCREEN_MENU_EXIT_CAPTION   : String = "Exit Fullscreenf\t\tF"

    private static const SHOW_ALL_MENU_CAPTION           : String = "Show All\t\t\tH"

    private static const ZOOM_IN_MENU_CAPTION            : String = "Zoom In\t\t\t\tI / +"
    private static const ZOOM_OUT_MENU_CAPTION           : String = "Zoom Out\t\t\tO / -"

    private static const PAN_UP_MENU_CAPTION             : String = "Pan Up\t\t\t\tW / Up"
    private static const PAN_DOWN_MENU_CAPTION           : String = "Pan Down\t\t\tS / Down"
    private static const PAN_LEFT_MENU_CAPTION           : String = "Pan Left\t\t\t\tA / Left"
    private static const PAN_RIGHT_MENU_CAPTION          : String = "Pan Right\t\t\tD / Right"

    // Parameters
    private static const ZOOM_IN_FACTOR                  : Number = 2.0
    private static const ZOOM_OUT_FACTOR                 : Number = 0.3
    private static const PAN_FACTOR                      : Number = 0.1

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
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    // context menu
    private var menu : ContextMenu

    // display mode
    private var showAllMenu : ContextMenuItem
    private var fullScreenMenu : ContextMenuItem

    // zooming
    private var zoomInMenu : ContextMenuItem
    private var zoomOutMenu : ContextMenuItem

    // panning
    private var panDownMenu : ContextMenuItem
    private var panUpMenu : ContextMenuItem
    private var panLeftMenu : ContextMenuItem
    private var panRightMenu : ContextMenuItem

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ViewportControllerBase
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function view_addedToStageHandler( event : Event ) : void
    {
        // Fullscreen
        view.stage.addEventListener( FullScreenEvent.FULL_SCREEN,
                                     stage_fullScreenHandler,
                                     false, 0, true )

        // Context Menu
        menu = new ContextMenu()
        menu.hideBuiltInItems()

        // Display state
        fullScreenMenu = new ContextMenuItem( FULL_SCREEN_MENU_NORMAL_CAPTION )
        fullScreenMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                         fullScreenMenu_menuItemSelectHandler,
                                         false, 0, true )
        menu.customItems.push( fullScreenMenu )

        showAllMenu = new ContextMenuItem( SHOW_ALL_MENU_CAPTION )
        showAllMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                      showAllMenu_menuItemSelectHandler,
                                      false, 0, true )
        menu.customItems.push( showAllMenu )

        // Zooming
        zoomInMenu = new ContextMenuItem( ZOOM_IN_MENU_CAPTION )
        zoomInMenu.separatorBefore = true
        zoomInMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                     zoomInMenu_menuItemSelectHandler,
                                     false, 0, true )
        menu.customItems.push( zoomInMenu )

        zoomOutMenu = new ContextMenuItem( ZOOM_OUT_MENU_CAPTION )
        zoomOutMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                      zoomOutMenu_menuItemSelectHandler,
                                      false, 0, true )
        menu.customItems.push( zoomOutMenu )

        // Panning
        panUpMenu = new ContextMenuItem( PAN_UP_MENU_CAPTION )
        panUpMenu.separatorBefore = true
        panUpMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                    panUpMenu_menuItemSelectHandler,
                                    false, 0, true )
        menu.customItems.push( panUpMenu )

        panDownMenu = new ContextMenuItem( PAN_DOWN_MENU_CAPTION )
        panDownMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                      panDownMenu_menuItemSelectHandler,
                                      false, 0, true )
        menu.customItems.push( panDownMenu )


        panLeftMenu = new ContextMenuItem( PAN_LEFT_MENU_CAPTION )
        panLeftMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                      panLeftMenu_menuItemSelectHandler,
                                      false, 0, true )
        menu.customItems.push( panLeftMenu )

        panRightMenu = new ContextMenuItem( PAN_RIGHT_MENU_CAPTION )
        panRightMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                       panRightMenu_menuItemSelectHandler,
                                       false, 0, true )
        menu.customItems.push( panRightMenu )

        if( view is DisplayObjectContainer )
            DisplayObjectContainer( view ).contextMenu = menu
    }

    /**
     * @private
     */
    override protected function view_removedFromStageHandler( event : Event ) : void
    {
        view.stage.removeEventListener( FullScreenEvent.FULL_SCREEN,
                                        stage_fullScreenHandler )
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers: Context Menu
    //
    //--------------------------------------------------------------------------

    // Display mode
    private function showAllMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        viewport.showAll()
    }

    private function fullScreenMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        toggleFullScreen()
    }

    // Zooming
    private function zoomInMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        var origin : Point = getMouseOrigin()
        viewport.zoomBy( ZOOM_IN_FACTOR, origin.x, origin.y )
    }

    private function zoomOutMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        var origin : Point = getMouseOrigin()
        viewport.zoomBy( ZOOM_OUT_FACTOR, origin.x, origin.y )
    }

    // Panning
    private function panUpMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        var dy : Number = viewport.height * PAN_FACTOR
        viewport.panBy( 0, -dy )
    }

    private function panDownMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        var dy : Number = viewport.height * PAN_FACTOR
        viewport.panBy( 0, dy )
    }

    private function panLeftMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        var dx : Number = viewport.width * PAN_FACTOR
        viewport.panBy( -dx, 0 )
    }

    private function panRightMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        var dx : Number = viewport.width * PAN_FACTOR
        viewport.panBy( dx, 0 )
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function stage_fullScreenHandler( event : FullScreenEvent ) : void
    {
        if( event.fullScreen )
        {
            if( fullScreenMenu )
                fullScreenMenu.caption = FULL_SCREEN_MENU_EXIT_CAPTION
        }
        else
        {
            if( fullScreenMenu )
                fullScreenMenu.caption = FULL_SCREEN_MENU_NORMAL_CAPTION
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function toggleFullScreen() : void
    {
        try
        {
            if( view.stage.displayState == StageDisplayState.NORMAL )
                view.stage.displayState = StageDisplayState.FULL_SCREEN
            else
                view.stage.displayState = StageDisplayState.NORMAL
        }
        catch( error : Error )
        {
            // Do nothing, what else? =)
        }
    }

    private function getMouseOrigin() : Point
    {
        return new Point( view.mouseX / view.width,
                          view.mouseY / view.height )
    }
}

}