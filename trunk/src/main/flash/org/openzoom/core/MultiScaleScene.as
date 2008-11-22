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

public class MultiScaleScene extends Sprite implements IMultiScaleScene
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
     public function MultiScaleScene( width : Number, height : Number )
     {
     	frame = createFrame()
     	resizeFrame( width, height )
     	addChildAt( frame, 0 )
     }
     
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var frame : Shape
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  owner
    //----------------------------------
    
    public function get owner() : DisplayObject
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
    	resizeFrame( value, sceneHeight )
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
        resizeFrame( sceneWidth, value )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleScene
    //
    //--------------------------------------------------------------------------
    
    public function setSize( width : Number, height : Number ) : void
    {
    	resizeFrame( width, height )
    	dispatchEvent( new Event( Event.RESIZE ))
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function resizeFrame( width : Number, height : Number ) : void
    {
        var g : Graphics = frame.graphics
        g.clear()
        g.beginFill( 0x333333, 0.4 )
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