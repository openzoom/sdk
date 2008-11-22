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
package org.openzoom.components.flex
{

import mx.core.UIComponent;

import org.openzoom.core.IMultiScaleScene;
import org.openzoom.core.IViewport;
import org.openzoom.core.MultiScaleScene;	

public class MultiScaleContainer extends UIComponent implements IMultiScaleContainer
{   
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function MultiScaleContainer()
	{
		_scene = new MultiScaleScene( 100, 100 )
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleContainer
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  scene
    //----------------------------------
	
	private var _scene : MultiScaleScene
	
    public function get scene() : IMultiScaleScene
    {
    	return _scene
    }

    //----------------------------------
    //  sceneWidth
    //----------------------------------
    
    public function get sceneWidth() : Number
    {
        return _scene.sceneWidth
    }
    
    public function set sceneWidth( value : Number ) : void
    {
    	_scene.sceneWidth = value
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------
    
    public function get sceneHeight() : Number
    {
        return _scene.sceneHeight
    }
    
    public function set sceneHeight( value : Number ) : void
    {
    	_scene.sceneHeight = value
    }

    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : IViewport
    
    public function get viewport() : IViewport
    {
    	return _viewport
    }
}

}