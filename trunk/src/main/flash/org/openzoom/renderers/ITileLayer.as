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
package org.openzoom.renderers
{

import org.openzoom.descriptors.IMultiScaleImageLevel;
	
/**
 * Interface a tile layer has to provide.
 */
public interface ITileLayer
{
    function containsTile( tile : Tile ) : Boolean
    function addTile( tile : Tile ) : Tile
    function removeAllTiles() : void
    
    function get level() : IMultiScaleImageLevel
    function set level( value : IMultiScaleImageLevel ) : void
    
    function get width() : Number
    function set width( value : Number ) : void
    function get height() : Number
    function set height( value : Number ) : void
}

}