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
package org.openzoom.flash.viewport.controllers
{

import flash.display.DisplayObject;
import flash.events.Event;

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportController;

/**
 * Base class for viewport controllers.
 */
public class ViewportControllerBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
    * Constructor.
    */
    public function ViewportControllerBase() : void
    {
    }
        
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
  
    //----------------------------------
    //  view
    //----------------------------------
  
    private var _view : DisplayObject
    
    public function get view() : DisplayObject
    {
        return _view
    }

    public function set view( value : DisplayObject ) : void
    {
        if( view === value )
            return

        if( !value )
            view_removedFromStageHandler( null )
  
        _view = value
        
        if( value )
        {
            view.addEventListener( Event.ADDED_TO_STAGE, view_addedToStageHandler, false, 0, true )
            view.addEventListener( Event.REMOVED_FROM_STAGE, view_removedFromStageHandler, false, 0, true )
      
            if( view.stage )
                view_addedToStageHandler( null )
        }
    }
    
    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport : INormalizedViewport
        
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
    
    public function set viewport( value : INormalizedViewport ) : void
    {
        _viewport = value
    }
  
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
      
    protected function view_addedToStageHandler( event : Event ) : void
    {
    }
      
    protected function view_removedFromStageHandler( event : Event ) : void
    {
    }
}

}