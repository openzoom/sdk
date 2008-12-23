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
package org.openzoom.flash.descriptors.openzoom
{

import flash.geom.Rectangle;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageLevelBase;
	

/**
 * @private
 * 
 * Represents a single level of a multi-scale
 * image pyramid described by an OpenZoom descriptor.
 */
internal class MultiScaleImageLevel extends MultiScaleImageLevelBase
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
    public function MultiScaleImageLevel( descriptor : IMultiScaleImageDescriptor,
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
    
    /**
     * @inheritDoc
     */
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
    
    /**
     * @inheritDoc
     */
    public function getTileBounds( column : uint, row : uint ) : Rectangle
    {
        return descriptor.getTileBounds( index, column, row )
    }
    
    /**
     * @inheritDoc
     */
    public function clone() : IMultiScaleImageLevel
    {
        return new MultiScaleImageLevel( descriptor.clone(),
                                         index, width, height,
                                         numColumns, numRows, uris.slice() )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override public function toString() : String
    {
        return "[OpenZoomLevel]" + "\n" + super.toString()
    }
}

}