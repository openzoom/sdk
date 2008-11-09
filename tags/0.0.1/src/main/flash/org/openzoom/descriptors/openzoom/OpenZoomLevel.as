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
package org.openzoom.descriptors.openzoom
{

import flash.geom.Point;

import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.descriptors.MultiScaleImageLevelBase;
	

/**
 * The OpenZoomLevel class represents a single level of a multi-scale image pyramid.
 */
public class OpenZoomLevel extends MultiScaleImageLevelBase
                           implements IMultiScaleImageLevel
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */ 
    public function OpenZoomLevel( descriptor : IMultiScaleImageDescriptor,
                                   index : int, width : uint, height : uint,
                                   numColumns : uint, numRows : uint, uris : Array )
    {
    	this.descriptor = descriptor
    	this.uris = uris
    	
        super( index, width, height, numColumns, numRows )
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var uris : Array /* of String */
    private var descriptor : IMultiScaleImageDescriptor
    private static var  uriIndex : uint = 0
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageLevel
    //
    //--------------------------------------------------------------------------
    
    public function getTileURL( column : uint, row : uint ) : String
    {
        if( uris && uris.length > 0 )
        {
            if( ++uriIndex >= uris.length )
                uriIndex = 0
                
        	var uri : String =  String( uris[ uriIndex ] )
        	return uri.replace( /{column}/, column ).replace( /{row}/, row )
        }
        
        return ""
    }
    
    public function getTilePosition( column : uint, row : uint ) : Point
    {
        return descriptor.getTilePosition( column, row )
    }
    
    public function clone() : IMultiScaleImageLevel
    {
        return new OpenZoomLevel( descriptor.clone(), this.index, width, height, numColumns, numRows, uris.slice() )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    override public function toString() : String
    {
        return "[OpenZoomLevel]" + "\n" + super.toString()
    }
}

}