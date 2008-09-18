////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008 Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.descriptors
{

import flash.utils.Dictionary;	

/**
 * Descriptor for the Microsoft Deep Zoom Image (DZI) format.
 * <http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx>
 */
public class DZIDescriptor extends MultiScaleImageDescriptorBase
                           implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace deepzoom = "http://schemas.microsoft.com/deepzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function DZIDescriptor( source : String, data : XML )
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

    public function getTileURL( index : int, column : uint, row : uint ) : String
    {
        return _source.substring( 0, _source.length - 4 ) + "_files/"
                   + String( index ) + "/" + String( column ) + "_"
                   + String( row ) + "." + format
    }
    
    public function getLevelAt( index : int ) : IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel( levels[ index ] )
    }
    
    
    public function getMinimumLevelForSize( width : Number, height : Number ) : IMultiScaleImageLevel
    {
        var index : int = Math.min( numLevels, Math.ceil( Math.log( Math.max( width, height ) ) / Math.LN2 ) )
        return getLevelAt( index )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[DZIDescriptor]" + "\n" + super.toString()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function parseXML( data : XML ) : void
    {
        use namespace deepzoom

        _width = data.Size.@Width
        _height = data.Size.@Height
        _tileWidth = _tileHeight = data.@TileSize

        _format = data.@Format
        _tileOverlap = data.@Overlap
    }

    private function computeNumLevels( width : Number, height : Number ) : int
    {
        return Math.ceil( Math.log( Math.max( width, height ) ) / Math.LN2 ) + 1
    }
    
    private function computeLevels( width : Number, height : Number,
                                    tileWidth : uint, tileHeight : uint,
                                    numLevels : int ) : Dictionary
    {
        var levels : Dictionary = new Dictionary()

        var w : Number = width
        var h : Number = height

        for( var index : int = numLevels - 1; index >= 0; index-- )
        {
            levels[ index ] = new MultiScaleImageLevel( index, w, h, Math.ceil( w / tileWidth ), Math.ceil( h / tileHeight ) )
            w = Math.ceil( w * 0.5 )
            h = Math.ceil( h * 0.5 )
	    }
	    
//        Twitter on 17.09.2008
//        for(var i:int=max;i>=0;i--){levels[i]=new Level(w,h,Math.ceil(w/tileWidth),Math.ceil(h/tileHeight));w=Math.ceil(w/2);h=Math.ceil(h/2)}
	    
        return levels 
    }
}

}