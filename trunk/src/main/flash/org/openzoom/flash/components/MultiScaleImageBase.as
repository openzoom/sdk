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
package org.openzoom.flash.components
{

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.ContextMenu;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransformer;

/**
 * @private
 * 
 * Base class for MultiScaleImage and DeepZoomContainer.
 */
public class MultiScaleImageBase extends Sprite implements IMultiScaleImage
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
   
    public static const DEFAULT_SCENE_DIMENSION  : Number = 16384 // 2^14
    
    private static const DEFAULT_VIEWPORT_WIDTH  : Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT : Number = 600
    
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function MultiScaleImageBase()
	{
		createChildren()
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    protected var container : MultiScaleContainer
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  sceneWidth
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneWidth
     */ 
    public function get sceneWidth() : Number
    {
    	return container ? container.scene.sceneWidth : NaN
    }
    
    //----------------------------------
    //  sceneHeight
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneHeight
     */ 
    public function get sceneHeight() : Number
    {
    	return container ? container.scene.sceneHeight : NaN
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Viewport
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    /**
     * Viewport of this image.
     */ 
    public function get viewport() : INormalizedViewport
    {
        return container.viewport
    }
    
    //----------------------------------
    //  transformer
    //----------------------------------
    
    /**
     * Viewport transformer. Transformers are used to create the transitions
     * between transformations of the viewport.
     * 
     * @see org.openzoom.flash.viewport.transformers.TweenerTransformer
     * @see org.openzoom.flash.viewport.transformers.NullTransformer
     */ 
    public function get transformer() : IViewportTransformer
    {
    	return viewport.transformer
    }
    
    public function set transformer( value : IViewportTransformer ) : void
    {
    	if( transformer !== value )
	        viewport.transformer = value
    }
    
    //----------------------------------
    //  constraint
    //----------------------------------
    
    /**
     * Viewport transformer constraint. Constraints are used to control
     * the positions and zoom levels the viewport can reach.
     * 
     * @see org.openzoom.flash.viewport.constraints.VisibilityConstraint
     * @see org.openzoom.flash.viewport.constraints.ZoomConstraint
     * @see org.openzoom.flash.viewport.constraints.ScaleConstraint
     * @see org.openzoom.flash.viewport.constraints.CompositeConstraint
     * @see org.openzoom.flash.viewport.constraints.NullConstraint 
     */ 
    public function get constraint() : IViewportConstraint
    {
    	return viewport.transformer.constraint
    }
    
    public function set constraint( value : IViewportConstraint ) : void
    {
        if( constraint !== value )
            viewport.transformer.constraint = value
    }
    
    //----------------------------------
    //  controllers
    //----------------------------------
    
    /**
     * Controllers of type IViewportController applied to this MultiScaleImage.
     * For example, viewport controllers are used to navigate the MultiScaleImage
     * by mouse or keyboard.
     * 
     * @see org.openzoom.flash.viewport.controllers.MouseController
     * @see org.openzoom.flash.viewport.controllers.KeyboardController
     * @see org.openzoom.flash.viewport.controllers.ContextMenuController
     */
    public function get controllers() : Array
    {
    	return container.controllers
    }
    
    public function set controllers( value : Array ) : void
    {
    	container.controllers = value
    }
    
	//--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function createChildren() : void
    {
    	if( !container )
            createContainer()    
    }
    
    /**
     * @private
     */
    private function createContainer() : void
    {
        container = new MultiScaleContainer()
        super.addChild( container )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObject
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  width
    //----------------------------------
    
    override public function get width() : Number
    {
        return container.width
    }
  
    override public function set width( value : Number ) : void
    {
        setActualSize( value, height )
    }
  
    //----------------------------------
    //  height
    //----------------------------------    
  
    override public function get height() : Number
    {
        return container.height
    }
  
    override public function set height( value : Number ) : void
    {
        setActualSize( width, value )
    }
    
    //----------------------------------
    //  contextMenu
    //----------------------------------
    
    override public function get contextMenu() : ContextMenu
    {
        return container.contextMenu
    }
  
    override public function set contextMenu( value : ContextMenu ) : void
    {
    	container.contextMenu = value
    }
  
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    public function setActualSize( width : Number, height : Number ) : void
    {
    	if( this.width == width && this.height == height )
            return
        
        container.setActualSize( width, height )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleImage
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  zoom
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoom
     */
    public function get zoom() : Number
    {
        return viewport.zoom
    }
    
    public function set zoom( value : Number ) : void
    {
        viewport.zoom = value
    }
    
    //----------------------------------
    //  scale
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#scale
     */
    public function get scale() : Number
    {
        return viewport.zoom    
    }
    
    public function set scale( value : Number ) : void
    {
        viewport.scale = value
    }
    
    //----------------------------------
    //  viewportX
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#x
     */

    public function get viewportX() : Number
    {
        return viewport.x    
    }
    
    public function set viewportX( value : Number ) : void
    {
        viewport.x = value
    }
    
    //----------------------------------
    //  viewportY
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    public function get viewportY() : Number
    {
        return viewport.y
    }
    
    public function set viewportY( value : Number ) : void
    {
        viewport.y = value
    }
    
    //----------------------------------
    //  viewportWidth
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    public function get viewportWidth() : Number
    {
        return viewport.width   
    }
    
    public function set viewportWidth( value : Number ) : void
    {
        viewport.width = value
    }
    
    //----------------------------------
    //  viewportHeight
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    public function get viewportHeight() : Number
    {
        return viewport.height
    }
    
    public function set viewportHeight( value : Number ) : void
    {
        viewport.height = value
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImage
    //
    //--------------------------------------------------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomTo()
     */
    public function zoomTo( zoom : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomTo( zoom, transformX, transformY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomBy()
     */
    public function zoomBy( factor : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomBy( factor, transformX, transformY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panTo()
     */
    public function panTo( x : Number, y : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panTo( x, y, immediately )
    }
                    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#panBy()
     */
    public function panBy( deltaX : Number, deltaY : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panBy( deltaX, deltaY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomToBounds()
     */
    public function zoomToBounds( bounds : Rectangle,
                                  scale : Number = 1.0,
                                  immediately : Boolean = false ) : void
    {
        viewport.zoomToBounds( bounds, scale, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showAll()
     */
    public function showAll( immediately : Boolean = false ) : void
    {
        viewport.showAll( immediately )
    }
                    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#localToScene()
     */
    public function localToScene( point : Point ) : Point
    {
        return viewport.localToScene( point )
    }
                    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#sceneToLocal()
     */
    public function sceneToLocal( point : Point ) : Point
    {
        return viewport.sceneToLocal( point )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */ 
    override public function addChild( child : DisplayObject ) : DisplayObject
    {
    	return container.addChild( child )
    }
    
    /**
     * @inheritDoc
     */ 
    override public function removeChild( child : DisplayObject ) : DisplayObject
    {
    	return container.removeChild( child )
    }
    
    /**
     * @inheritDoc
     */ 
    override public function get numChildren():int
    {
        return container ? container.numChildren : 0
    }
}

}