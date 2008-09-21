////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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
package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.ui.Keyboard;

import org.hasseg.externalMouseWheel.ExternalMouseWheelSupport;
import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.MultiScaleImageDescriptorFactory;
import org.openzoom.viewer.MultiScaleImageViewer;
import org.openzoom.viewer.assets.Sad;
import org.openzoom.viewer.ui.MemoryDisplay;

/**
 * Bootstrapper.
 */
[SWF(width="960", height="680", frameRate="60", backgroundColor="#111111")]
public class OpenZoomViewer extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const FULL_SCREEN_KEY_CODE : uint = 70 // F
    private static const FULL_SCREEN_MENU_NORMAL_CAPTION : String = "Fullscreen                                       F"
    private static const FULL_SCREEN_MENU_EXIT_CAPTION   : String = "Exit Fullscreen                                  F"
    
    private static const SHOW_ALL_MENU_CAPTION           : String = "Show All                                   Space"
    
    private static const ZOOM_IN_MENU_CAPTION            : String = "Zoom In                                     I / +"
    private static const ZOOM_OUT_MENU_CAPTION           : String = "Zoom Out                                 O / -"
    
    private static const MOVE_UP_MENU_CAPTION            : String = "Move Up                                 W / Up"
    private static const MOVE_DOWN_MENU_CAPTION          : String = "Move Down                         S / Down"
    private static const MOVE_LEFT_MENU_CAPTION          : String = "Move Left                              A / Left"
    private static const MOVE_RIGHT_MENU_CAPTION         : String = "Move Right                         D / Right"
    
    private static const DEBUG_MENU_DISABLED_CAPTION     : String = "Show Memory Consumption"
    private static const DEBUG_MENU_ENABLED_CAPTION      : String = "Hide Memory Consumption"
    
    private static const ABOUT_MENU_CAPTION              : String = "Powered by OpenZoom.org"
    
    private static const DEFAULT_IMAGE_NAME              : String = "morocco"
    private static const DEFAULT_SOURCE                  : String = "images/deepzoom/" + DEFAULT_IMAGE_NAME + ".xml"
//    private static const DEFAULT_SOURCE                  : String = "images/zoomify/" + DEFAULT_IMAGE_NAME + "/ImageProperties.xml"
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function OpenZoomViewer()
    {
        initializeStage()
        initializeContextMenu()
        initializeKeyboardShortcuts()
        
        createChildren()
        
        source = getParameter( OpenZoomViewerParameters.SOURCE, DEFAULT_SOURCE )        
        loadDescriptor( source )
        
        layout()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var source : String
    private var descriptor : IMultiScaleImageDescriptor
    private var descriptorLoader : URLLoader
    
    // UI
    private var viewer : MultiScaleImageViewer
    private var memoryDisplay : MemoryDisplay
    private var sad : Sprite
    
    // context menu
    private var menu : ContextMenu

    // display mode    
    private var fullScreenMenu : ContextMenuItem
    private var showAllMenu : ContextMenuItem
    
    // zooming
    private var zoomInMenu : ContextMenuItem
    private var zoomOutMenu : ContextMenuItem
    
    // panning
    private var moveDownMenu : ContextMenuItem
    private var moveUpMenu : ContextMenuItem
    private var moveLeftMenu : ContextMenuItem
    private var moveRightMenu : ContextMenuItem
    
    // extra
    private var debugMenu : ContextMenuItem
    private var aboutMenu : ContextMenuItem
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function initializeStage() : void
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener( Event.RESIZE, stage_resizeHandler )
        
        // Enable Mac OS X mouse wheel support
        ExternalMouseWheelSupport.getInstance( stage )
    }
    
    private function initializeContextMenu() : void
    {
        menu = new ContextMenu()
        menu.hideBuiltInItems()
        
        // display state    
        fullScreenMenu = new ContextMenuItem( FULL_SCREEN_MENU_NORMAL_CAPTION )
        fullScreenMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                         fullScreenMenu_menuItemSelectHandler )
        menu.customItems.push( fullScreenMenu )
        
        showAllMenu = new ContextMenuItem( SHOW_ALL_MENU_CAPTION )
        showAllMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                      showAllMenu_menuItemSelectHandler )
        menu.customItems.push( showAllMenu )
        
        // zooming
        zoomInMenu = new ContextMenuItem( ZOOM_IN_MENU_CAPTION )
        zoomInMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                     zoomInMenu_menuItemSelectHandler )
        menu.customItems.push( zoomInMenu )
        
        zoomOutMenu = new ContextMenuItem( ZOOM_OUT_MENU_CAPTION )
        zoomOutMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                      zoomOutMenu_menuItemSelectHandler )
        menu.customItems.push( zoomOutMenu )
        
        // panning
        moveUpMenu = new ContextMenuItem( MOVE_UP_MENU_CAPTION )
        moveUpMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                     moveUpMenu_menuItemSelectHandler )
        menu.customItems.push( moveUpMenu )
        
        moveDownMenu = new ContextMenuItem( MOVE_DOWN_MENU_CAPTION )
        moveDownMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                       moveDownMenu_menuItemSelectHandler )
        menu.customItems.push( moveDownMenu )
        
        
        moveLeftMenu = new ContextMenuItem( MOVE_LEFT_MENU_CAPTION )
        moveLeftMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                       moveLeftMenu_menuItemSelectHandler )
        menu.customItems.push( moveLeftMenu )
        
        moveRightMenu = new ContextMenuItem( MOVE_RIGHT_MENU_CAPTION )
        moveRightMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                        moveRightMenu_menuItemSelectHandler )
        menu.customItems.push( moveRightMenu )
        
        // extra
        debugMenu = new ContextMenuItem( DEBUG_MENU_DISABLED_CAPTION )
        debugMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                    debugMenu_menuItemSelectHandler )
        menu.customItems.push( debugMenu )
        
        aboutMenu = new ContextMenuItem( ABOUT_MENU_CAPTION )
        aboutMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                    aboutMenu_menuItemSelectHandler )
        menu.customItems.push( aboutMenu )
        
        contextMenu = menu
    }
    
    private function initializeKeyboardShortcuts() : void
    {
        stage.addEventListener( KeyboardEvent.KEY_DOWN, stage_keyDownHandler, false, 0, true )
    }
    
    private function loadDescriptor( url : String ) : void
    {
        descriptorLoader = new URLLoader()
        descriptorLoader.addEventListener( Event.COMPLETE,
                                           descriptorLoader_completeHandler )
        descriptorLoader.addEventListener( IOErrorEvent.IO_ERROR,
                                           descriptorLoader_ioErrorHandler )
        descriptorLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR,
                                           descriptorLoader_securityErrorHandler )
        descriptorLoader.load( new URLRequest( url ) )
    }
    
    private function createChildren() : void
    {
        memoryDisplay = new MemoryDisplay()
        memoryDisplay.visible = false
        addChild( memoryDisplay )
        
        sad = new Sad()
        sad.visible = false
        addChildAt( sad, 0 )
    }

    private function createMultiScaleImageViewer( descriptor : IMultiScaleImageDescriptor ) : MultiScaleImageViewer
    {
        var viewer : MultiScaleImageViewer = new MultiScaleImageViewer( descriptor )
        viewer.setSize( stage.stageWidth, stage.stageHeight )
            
        return viewer
    }
    
    private function layout() : void
    {
        if( viewer )
            viewer.setSize( stage.stageWidth, stage.stageHeight )
        
        if( memoryDisplay )
        {
            memoryDisplay.x = stage.stageWidth  - memoryDisplay.width
            memoryDisplay.y = stage.stageHeight - memoryDisplay.height
        }
        
        if( sad )
        {
            sad.width = stage.stageWidth / 2
            sad.height = stage.stageHeight / 2
            
            var scale : Number = Math.min( sad.scaleX, sad.scaleY )
            sad.scaleX = sad.scaleY = scale
            
            sad.x = ( stage.stageWidth  - sad.width ) / 2
            sad.y = ( stage.stageHeight - sad.height ) / 2
        }
    }
    
    private function toggleFullScreen() : void
    {
        if( stage.displayState == StageDisplayState.NORMAL )
        {
           stage.displayState = StageDisplayState.FULL_SCREEN
                       
           if( fullScreenMenu )
               fullScreenMenu.caption = FULL_SCREEN_MENU_EXIT_CAPTION
        }
        else
        {            
           stage.displayState = StageDisplayState.NORMAL
           
           if( fullScreenMenu )
               fullScreenMenu.caption = FULL_SCREEN_MENU_NORMAL_CAPTION
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function stage_resizeHandler( event : Event ) : void
    {
        layout()
    }
    
    private function stage_keyDownHandler( event : KeyboardEvent ) : void
    {
        if( event.keyCode == FULL_SCREEN_KEY_CODE || event.keyCode == Keyboard.ESCAPE )
            toggleFullScreen()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers: Descriptor Loader
    //
    //--------------------------------------------------------------------------
    
    private function descriptorLoader_completeHandler( event : Event ) : void
    {
        var factory : MultiScaleImageDescriptorFactory = MultiScaleImageDescriptorFactory.getInstance()
        descriptor = factory.getDescriptor( source, new XML( descriptorLoader.data ) )

        viewer = createMultiScaleImageViewer( descriptor )
        addChildAt( viewer, 0 )
    }
    
    private function descriptorLoader_ioErrorHandler( event : IOErrorEvent ) : void
    {
        sad.visible = true    
    }
    
    private function descriptorLoader_securityErrorHandler( event : SecurityErrorEvent ) : void
    {
        sad.visible = true    
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers: Context menu
    //
    //--------------------------------------------------------------------------
    
    // display state    
    private function fullScreenMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        toggleFullScreen()      
    }
    
    private function showAllMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        if( viewer )
            viewer.showAll()
    }
    
    // zooming
    private function zoomInMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        if( viewer )
            viewer.zoomIn()
    }
    
    private function zoomOutMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        if( viewer )
            viewer.zoomOut()
    }
    
    // panning
    private function moveUpMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        if( viewer )
            viewer.moveUp()
    }
    
    private function moveDownMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        if( viewer )
            viewer.moveDown()
    }
    
    private function moveLeftMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        if( viewer )
            viewer.moveLeft()
    }
    
    private function moveRightMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        if( viewer )
            viewer.moveRight()
    }
    
    // extra
    private function debugMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        memoryDisplay.visible = !memoryDisplay.visible
        
        if( memoryDisplay.visible )
            debugMenu.caption = DEBUG_MENU_ENABLED_CAPTION
        else
            debugMenu.caption = DEBUG_MENU_DISABLED_CAPTION
    }
    
    private function aboutMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        navigateToURL( new URLRequest( "http://openzoom.org/" ), "_blank" )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Parameters
    //
    //--------------------------------------------------------------------------
    
    private function getParameter( name : String, defaultValue : * ) : *
    {
        if( loaderInfo.parameters.hasOwnProperty( name ) )
        {
            var value : String = loaderInfo.parameters[ name ]
            return value
        }
        
        return defaultValue
    }
}

}