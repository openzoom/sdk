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
package org.openzoom.descriptors
{

import flash.utils.Dictionary;

/**
 * Descriptor for the OpenZoom Image (OZI) format.
 * <http://openzoom.org/>
 */
public class OZIDescriptor extends MultiScaleImageDescriptorBase
                           implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace openzoom = "http://openzoom.org/2008/ozi"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function OZIDescriptor( source : String, data : XML )
    {
        this.data = data

        _source = source        
        parseXML( data )
        _numLevels = computeNumLevels( width, height )
        levels = computeLevels( width, height, tileWidth, tileHeight, numLevels )
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var data : XML
    private var levels : Dictionary 

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------

    public function getTileURL( level : int, column : uint, row : uint ) : String
    {
        return _source.substring( 0, _source.length - 8 )
               + String( level ) + "/" + String( column ) + "-"
               + String( row ) + "." + tileFormat
    }
    
    public function getLevelAt( index : int ) : IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel( levels[ index ] )
    }
    
    
    public function getMinimumLevelForSize( width : Number,
                                            height : Number ) : IMultiScaleImageLevel
    {
    	// FIXME: Some images appear blurry.
    	// For now, just be more generous and return one level higher than necessary…
        var index : int = Math.min( numLevels - 1, Math.ceil( Math.log( Math.min( width, height ) ) / Math.LN2 ) + 1 )
        return IMultiScaleImageLevel( getLevelAt( index ) ).clone()
    }
    
    public function clone() : IMultiScaleImageDescriptor
    {
        return new OZIDescriptor( source, new XML( data ) )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[OZIDescriptor]" + "\n" + super.toString()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function parseXML( data : XML ) : void
    {
        use namespace openzoom

        _width = data.pyramid.@width
        _height = data.pyramid.@height
        _tileWidth = _tileHeight = data.pyramid.@tileSize

        _tileFormat = data.pyramid.@format
        _tileOverlap = data.pyramid.@overlap
    }

    private function computeNumLevels( width : Number, height : Number ) : int
    {
        return Math.ceil( Math.log( Math.max( width, height ) ) / Math.LN2 ) + 1
    }
    
    private function computeLevels( originalWidth : uint, originalHeight : uint,
                                    tileWidth : uint, tileHeight : uint,
                                    numLevels : int ) : Dictionary
    {
        var levels : Dictionary = new Dictionary()

        var width : Number = originalWidth
        var height : Number = originalHeight

        for( var index : int = numLevels - 1; index >= 0; index-- )
        {
            levels[ index ] = new MultiScaleImageLevel( index, width, height,
                                                        Math.ceil( width / tileWidth ),
                                                        Math.ceil( height / tileHeight ) )
            width = Math.ceil( width * 0.5 )
            height = Math.ceil( height * 0.5 )
        }
        
        return levels 
    }
}

}