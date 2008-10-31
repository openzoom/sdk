////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
//  Copyright (c) 2008, Zoomorama
//                      Olivier Gambier <viapanda@gmail.com>
//                      Daniel Gasienica <daniel@gasienica.ch>
//                      Eric Hubscher <erich@zoomorama.com>
//                      David Marteau <dhmarteau@gmail.com>
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
import flash.events.Event;

/**
 * Base class for viewport controllers.
 */
public class ViewportControllerBase implements IViewportController
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
        // ViewportControllerBase is an abstract class.
        // Please extend it with your own, concrete controller.
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