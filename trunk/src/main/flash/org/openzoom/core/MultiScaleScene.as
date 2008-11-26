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
package org.openzoom.core
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;	

public class MultiScaleScene extends Sprite implements IMultiScaleScene,
                                                       IReadonlyMultiScaleScene
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
     public function MultiScaleScene( width : Number, height : Number,
                                      backgroundColor : uint = 0x000000,
                                      backgroundAlpha : Number = 0.0 )
     {
     	this.backgroundColor = backgroundColor
     	this.backgroundAlpha = backgroundAlpha
     	
     	frame = createFrame()
     	drawFrame( width, height )
     	
     	super.addChildAt( frame, 0 )
     }
     
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var frame : Shape
    private var backgroundColor : uint = 0x000000
    private var backgroundAlpha : Number = 0.0
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObject
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  numChildren
    //----------------------------------
    
    override public function get numChildren():int
    {
        return super.numChildren - 1
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DisplayObject
    //
    //--------------------------------------------------------------------------
    
    override public function addChildAt( child : DisplayObject, index : int ) : DisplayObject
    {
    	return super.addChildAt( child, index + 1 )
    }
    
    override public function removeChildAt( index : int ) : DisplayObject
    {
    	return super.removeChildAt( index + 1 )
    }
    
    override public function setChildIndex( child : DisplayObject, index : int ) : void
    {
    	super.setChildIndex( child, index + 1 )
    }
    
    override public function getChildAt( index : int ) : DisplayObject
    {
    	return super.getChildAt( index + 1 )
    }
    
    override public function getChildIndex( child : DisplayObject ) : int
    {
        return super.getChildIndex( child ) + 1	
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleScene
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  owner
    //----------------------------------
    
    public function get targetCoordinateSpace() : DisplayObject
    {
    	return this
    }
    
    //----------------------------------
    //  sceneWidth
    //----------------------------------
    
    public function get sceneWidth() : Number
    {
        return frame.width
    }
    
    public function set sceneWidth( value : Number ) : void
    {
    	drawFrame( value, sceneHeight )
    }
    
    //----------------------------------
    //  sceneHeight
    //----------------------------------
    
    public function get sceneHeight() : Number
    {
        return frame.height
    }
    
    public function set sceneHeight( value : Number ) : void
    {
        drawFrame( sceneWidth, value )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleScene
    //
    //--------------------------------------------------------------------------
    
    public function setSize( width : Number, height : Number ) : void
    {
    	drawFrame( width, height )
    	dispatchEvent( new Event( Event.RESIZE ))
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

//    public function clear() : void
//    {
//    	while( numChildren > 1 )
//    	   removeChildAt( numChildren - 1 )
//    }
    
    private function drawFrame( width : Number, height : Number ) : void
    {
        var g : Graphics = frame.graphics
        g.clear()
        g.beginFill( backgroundColor, backgroundAlpha )
        g.drawRect( 0, 0, width, height )
        g.endFill()
    }
    
    private function createFrame() : Shape
    {
    	var background : Shape = new Shape()
    	return background
    }
}

}