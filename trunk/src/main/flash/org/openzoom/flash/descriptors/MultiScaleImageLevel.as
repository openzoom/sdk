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
package org.openzoom.flash.descriptors
{

import flash.geom.Rectangle;

/**
 * The MultiScaleImageLevel class represents a single level of a
 * multi-scale image pyramid. It is a default implementation of IMultiScaleImageLevel.
 */
public class MultiScaleImageLevel extends MultiScaleImageLevelBase
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
                                          numColumns : uint, numRows : uint )
    {
    	this.descriptor = descriptor
    	
        super( index, width, height, numColumns, numRows )
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */ 
    private var descriptor : IMultiScaleImageDescriptor
    
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
        return descriptor.getTileURL( index, column, row )
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
        return new MultiScaleImageLevel( descriptor, index, width, height, numColumns, numRows )
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
        return "[MultiScaleImageLevel]" + "\n" + super.toString()
    }
}

}