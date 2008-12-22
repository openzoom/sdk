////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
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

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import org.hasseg.externalMouseWheel.ExternalMouseWheelSupport;
import org.openzoom.flash.components.MemoryMonitor;
import org.openzoom.flash.components.MultiScaleImage;
import org.openzoom.flash.components.MultiScaleImageBase;
import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;
import org.openzoom.viewer.assets.Sad;
    
/**
 * OpenZoom based viewer for Adobe Photoshop Zoomify export feature.
 */
[SWF(width="960", height="600", frameRate="60", backgroundColor="#000000")]
public class OpenZoomViewer extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_MAX_SCALE_FACTOR     : Number = 2.0
    private static const DEFAULT_VISIBILITY_RATIO     : Number = 0.5
    
    private static const FULL_SCREEN_BACKGROUND_COLOR : uint   = 0x111111
    private static const FULL_SCREEN_KEY_CODE         : uint   = 70 // F
    
    private static const DEBUG_MENU_DISABLED_CAPTION  : String = "Show Memory Consumption\tM"
    private static const DEBUG_MENU_ENABLED_CAPTION   : String = "Hide Memory Consumption\tM"
    private static const DEBUG_MENU_KEY_CODE          : uint   = 77 // M
    
    private static const ABOUT_MENU_CAPTION           : String = "Powered by OpenZoom.org"
    private static const ABOUT_MENU_URL               : String = "http://openzoom.org/"
    
    private static const DEFAULT_SOURE                : String = ""
    private static const DEFAULT_DESCRIPTOR_NAME      : String = "ImageProperties.xml"
    
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
        initializeKeyboardShortcuts()
        
        createChildren()
        loadSource()
        layout()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    // UI
    private var image : MultiScaleImage
    private var memoryMonitor : MemoryMonitor
    private var sad : Sprite
    private var fullScreenBackground : Shape
//  private var sceneNavigator : SceneNavigator
    
    // Context menu
    private var debugMenu : ContextMenuItem
    private var aboutMenu : ContextMenuItem
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Initialization
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function initializeStage() : void
    {
    	if( stage )
        {
            stage.align = StageAlign.TOP_LEFT
            stage.scaleMode = StageScaleMode.NO_SCALE
            stage.addEventListener( Event.RESIZE,
                                    stage_resizeHandler,
                                    false, 0, true )
            stage.addEventListener( FullScreenEvent.FULL_SCREEN,
                                    stage_fullScreenHandler,
                                    false, 0, true )
        }
        
        // Enable Mac OS X mouse wheel support
        ExternalMouseWheelSupport.getInstance( stage )
    }
    
    /**
     * @private
     */
    private function initializeKeyboardShortcuts() : void
    {
        stage.addEventListener( KeyboardEvent.KEY_DOWN,
                                stage_keyDownHandler,
                                false, 0, true )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Children
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function createChildren() : void
    {
    	if( !fullScreenBackground )
            createFullScreenBackground()
            
        if( !sad )
            createSad()
            
        if( !image )
            createImage()
        
        if( !memoryMonitor )
            createMemoryMonitor()
    }
    
    /**
     * @private
     */
    private function createFullScreenBackground() : void
    {
        fullScreenBackground = new Shape()
        var g : Graphics = fullScreenBackground.graphics
	        g.beginFill( 0x000000 )
	        g.drawRect( 0, 0, 100, 100 )
	        g.endFill()
	        
        fullScreenBackground.visible = false
        addChild( fullScreenBackground )
    }
    
    /**
     * @private
     */
    private function createSad() : void
    {
        sad = new Sad()
        sad.visible = false
        addChild( sad )
    }
    
    /**
     * @private
     */
    private function createImage() : void
    {
        image = new MultiScaleImage()
        
        configureTransformer( image )        
        configureControllers( image )
        configureListeners( image )
        
        addChild( image )
        
        // Important that this happens after attachment
        configureContextMenu( image )
    }
    
    /**
     * @private
     */
    private function createMemoryMonitor() : void
    {
        memoryMonitor = new MemoryMonitor()
        memoryMonitor.visible = false
        addChild( memoryMonitor )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Image configuration
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function configureTransformer( image : MultiScaleImage ) : void
    {
        image.transformer = new TweenerTransformer()
    }
    
    /**
     * @private
     */
    private function configureControllers( image : MultiScaleImage ) : void
    {
        var keyboardController : KeyboardController = new KeyboardController() 
        var mouseController : MouseController = new MouseController() 
        var contextMenuController : ContextMenuController =
                                                     new ContextMenuController()
         
        image.controllers = [ mouseController,
                              keyboardController,
                              contextMenuController ]
    }
    
    /**
     * @private
     */
    private function configureConstraints( image : MultiScaleImage ) : void
    {
    	// Prevent image from zooming out
        var zoomConstraint : ZoomConstraint = new ZoomConstraint()
            zoomConstraint.minZoom = 1
        
        
        // Center at minimum zoom level
        var centerConstraint : CenterConstraint = new CenterConstraint()
        
        
        // Prevent from zooming in more than the original size of the image
        var scaleConstraint : ScaleConstraint = new ScaleConstraint()
        
        var imageWidth : Number
        var imageHeight : Number
        var defaultDimension : Number = MultiScaleImageBase.DEFAULT_SCENE_DIMENSION
         
        if( image.source && image.source is IMultiScaleImageDescriptor )
        {
        	var descriptor : IMultiScaleImageDescriptor =
        	                          IMultiScaleImageDescriptor( image.source )
            imageWidth  = descriptor.width
            imageHeight = descriptor.height
            var maxScale : Number = Math.max( imageWidth / defaultDimension,
                                              imageHeight / defaultDimension )
            scaleConstraint.maxScale = DEFAULT_MAX_SCALE_FACTOR * maxScale
        }
        
        // Prevent image from disappearing from the viewport
        var visibilityConstraint : VisibilityConstraint = new VisibilityConstraint()
            visibilityConstraint.visibilityRatio = DEFAULT_VISIBILITY_RATIO
        
        
        // Chain all constraints together
        var compositeContraint : CompositeConstraint = new CompositeConstraint()
            compositeContraint.constraints = [ centerConstraint,
                                               visibilityConstraint,
                                               zoomConstraint,
                                               scaleConstraint, ]
        // Apply constraints
        image.constraint = compositeContraint
    }
    
    /**
     * @private
     */
    private function configureListeners( image : MultiScaleImage ) : void
    {
    	image.addEventListener( Event.COMPLETE,
    	                        image_completeHandler,
    	                        false, 0, true )
        image.addEventListener( IOErrorEvent.IO_ERROR,
                                image_ioErrorHandler,
                                false, 0, true )
        image.addEventListener( SecurityErrorEvent.SECURITY_ERROR,
                                image_securityErrorHandler,
                                false, 0, true )
    }
    
    /**
     * @private
     */ 
    private function configureContextMenu( image : MultiScaleImage ) : void
    {    
        var menu : ContextMenu
        
        if( image.contextMenu && image.contextMenu.customItems )
            menu = image.contextMenu
        else
            menu = new ContextMenu()
            
        menu.hideBuiltInItems()    
        
        debugMenu = new ContextMenuItem( DEBUG_MENU_ENABLED_CAPTION, true )
        debugMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                    debugMenu_menuItemSelectHandler,
                                    false, 0, true )
        menu.customItems.push( debugMenu )
        
        aboutMenu = new ContextMenuItem( ABOUT_MENU_CAPTION )
        aboutMenu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
                                    aboutMenu_menuItemSelectHandler,
                                    false, 0, true )
        menu.customItems.push( aboutMenu )
        
        image.contextMenu = menu
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function loadSource() : void
    {
        var path : String = getParameter( OpenZoomViewerParameters.SOURCE,
                                          DEFAULT_SOURE )
        
        image.source = path + "/" + DEFAULT_DESCRIPTOR_NAME
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Layout
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function layout() : void
    {
        if( sad )
        {
            sad.width = stage.stageWidth / 2
            sad.height = stage.stageHeight / 2
            
            var scale : Number = Math.min( sad.scaleX, sad.scaleY )
            sad.scaleX = sad.scaleY = scale
            
            sad.x = ( stage.stageWidth  - sad.width )  / 2
            sad.y = ( stage.stageHeight - sad.height ) / 2
        }
        
        if( fullScreenBackground )
        {
            fullScreenBackground.width = stage.stageWidth
            fullScreenBackground.height = stage.stageHeight
        }
        
        if( image )
            image.setActualSize( stage.stageWidth, stage.stageHeight )
        
        if( memoryMonitor )
        {
            memoryMonitor.x = stage.stageWidth  - memoryMonitor.width
            memoryMonitor.y = stage.stageHeight - memoryMonitor.height
        }
        
//      if( sceneNavigator )
//      {
//          sceneNavigator.x = stage.stageWidth  - sceneNavigator.width - 10
//          sceneNavigator.y = 10
//      }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function toggleFullScreen() : void
    {
        if( stage.displayState == StageDisplayState.NORMAL )
            stage.displayState = StageDisplayState.FULL_SCREEN
        else
            stage.displayState = StageDisplayState.NORMAL
    }
    
    /**
     * @private
     */
    private function toggleMemoryDisplay() : void
    {
        memoryMonitor.visible = !memoryMonitor.visible
        
        if( debugMenu )
        {
	        if( memoryMonitor.visible )
	            debugMenu.caption = DEBUG_MENU_ENABLED_CAPTION
	        else
	            debugMenu.caption = DEBUG_MENU_DISABLED_CAPTION
        }
    }
    
    /**
     * @private
     */
    private function showSad() : void
    {
        sad.visible = true
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function stage_resizeHandler( event : Event ) : void
    {
        layout()
    }
    
    /**
     * @private
     */
    private function stage_keyDownHandler( event : KeyboardEvent ) : void
    {
        if( event.keyCode == FULL_SCREEN_KEY_CODE )
            toggleFullScreen()
            
        if( event.keyCode == DEBUG_MENU_KEY_CODE )
            toggleMemoryDisplay()
    }
    
    /**
     * @private
     */
    private function stage_fullScreenHandler( event : FullScreenEvent ) : void
    {
    	if( event.fullScreen )
            fullScreenBackground.visible = true
    	else
            fullScreenBackground.visible = false
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers: Image
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function image_completeHandler( event : Event ) : void
    {
        configureConstraints( image )
    }
    
    /**
     * @private
     */
    private function image_ioErrorHandler( event : IOErrorEvent ) : void
    {
        showSad()
    }
    
    /**
     * @private
     */
    private function image_securityErrorHandler( event : SecurityErrorEvent ) : void
    {
        showSad()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers: Context menu
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function debugMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
    	toggleMemoryDisplay()
    }
    
    /**
     * @private
     */
    private function aboutMenu_menuItemSelectHandler( event : ContextMenuEvent ) : void
    {
        navigateToURL( new URLRequest( ABOUT_MENU_URL ), "_blank" )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Parameters
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function getParameter( name : String, defaultValue : * ) : *
    {
        if( loaderInfo.parameters.hasOwnProperty( name ) )
        {
            var value : * = loaderInfo.parameters[ name ]
            return value
        }
        
        return defaultValue
    }
}

}