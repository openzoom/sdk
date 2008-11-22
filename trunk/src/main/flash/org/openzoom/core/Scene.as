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
package org.openzoom.core
{

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;

public class Scene extends EventDispatcher implements IScene
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function Scene( owner : DisplayObjectContainer, width : Number, height : Number )
    {
    	_owner = owner
        _width = width
        _height = height
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  width
    //----------------------------------
    
    private var _width : Number

    public function get width():Number
    {
        return _width
    }
    
    public function set width( value : Number ) : void
    {
        _width = value
        dispatchEvent( new Event( Event.RESIZE ))
    }

    //----------------------------------
    //  height
    //----------------------------------

    private var _height : Number

    public function get height():Number
    {
        return _height
    }
    
    public function set height( value : Number ) : void
    {
        _height = value
        dispatchEvent( new Event( Event.RESIZE ))
    }

    //----------------------------------
    //  owner
    //----------------------------------

    private var _owner : DisplayObjectContainer

    public function get owner() : DisplayObjectContainer
    {
        return _owner
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public function setSize( width : Number, height : Number ) : void
    {
        _width = width
        _height = height
        dispatchEvent( new Event( Event.RESIZE ))
    }
}

}