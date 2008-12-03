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
package org.openzoom.flash.descriptors.deepzoom
{

import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.descriptors.MultiScaleImageLevel;
import org.openzoom.flash.utils.math.clamp;

/**
 * Descriptor for the
 * <a href="http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx">
 * Microsoft Deep Zoom Image (DZI) format.</a>
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

        this.source = source        
        parseXML( data )
        _numLevels = computeNumLevels( width, height )
        levels = computeLevels( width, height, tileWidth, tileHeight, numLevels )
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var extension : String
    private var data : XML
    private var levels : Dictionary 

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */ 
    public function getTileURL( level : int, column : uint, row : uint ) : String
    {
    	var path : String  = source.substring( 0, source.length - 4 ) + "_files"
        return [ path, "/", level, "/", column, "_", row, ".", extension ].join("")
    }
    
    /**
     * @inheritDoc
     */
    public function getLevelAt( index : int ) : IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel( levels[ index ] )
    }
    
    /**
     * @inheritDoc
     */
    public function getMinLevelForSize( width : Number,
                                            height : Number ) : IMultiScaleImageLevel
    {
        var index : int = clamp( Math.ceil( Math.log( Math.max( width, height )) / Math.LN2 ), 0, numLevels - 1 )
        return IMultiScaleImageLevel( getLevelAt( index ) ).clone()
    }
    
    /**
     * @inheritDoc
     */
    public function clone() : IMultiScaleImageDescriptor
    {
        return new DZIDescriptor( source, new XML( data ) )
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
        return "[DZIDescriptor]" + "\n" + super.toString()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function parseXML( data : XML ) : void
    {
        use namespace deepzoom

        _width = data.Size.@Width
        _height = data.Size.@Height
        _tileWidth = _tileHeight = data.@TileSize

        extension = data.@Format
        
        switch( extension )
        {
        	case "jpg":
        	   _type = "image/jpeg"
        	   break
        	   
        	case "png":
        	   _type = "image/png"
        	   break
        }
        
        _tileOverlap = data.@Overlap
    }

    /**
     * @private
     */ 
    private function computeNumLevels( width : Number, height : Number ) : int
    {
        return Math.ceil( Math.log( Math.max( width, height ) ) / Math.LN2 ) + 1
    }
    
    /**
     * @private
     */ 
    private function computeLevels( originalWidth : uint, originalHeight : uint,
                                    tileWidth : uint, tileHeight : uint,
                                    numLevels : int ) : Dictionary
    {
        var levels : Dictionary = new Dictionary()

        var width  : uint = originalWidth
        var height : uint = originalHeight

        for( var index : int = numLevels - 1; index >= 0; index-- )
        {
            levels[ index ] = new MultiScaleImageLevel( this, index, width, height,
                                                        Math.ceil( width / tileWidth ),
                                                        Math.ceil( height / tileHeight ) )
            width = ( width + 1 ) >> 1
            height = ( height + 1 ) >> 1
//            width = Math.ceil( width * 0.5 )
//            height = Math.ceil( height * 0.5 )
        }
        
//        Twitter on 17.09.2008
//        for(var i:int=max;i>=0;i--){levels[i]=new Level(w,h,Math.ceil(w/tileWidth),Math.ceil(h/tileHeight));w=Math.ceil(w/2);h=Math.ceil(h/2)}
        
        return levels 
    }
}

}