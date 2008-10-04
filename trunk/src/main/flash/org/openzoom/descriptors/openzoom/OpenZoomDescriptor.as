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

import flash.utils.Dictionary;

import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.descriptors.MultiScaleImageLevel;
import org.openzoom.utils.math.clamp;

/**
 * OpenZoom Descriptor.
 * <http://openzoom.org/>
 */
public class OpenZoomDescriptor extends MultiScaleImageDescriptorBase
                                implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace openzoom = "http://openzoom.org/2008/ozd"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function OpenZoomDescriptor( source : String, data : XML )
    {
    	use namespace openzoom
    	
        this.data = data

        _source = source        
        parseXML( data )
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var data : XML
    private var levels : Dictionary = new Dictionary()

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImageDescriptor
    //
    //--------------------------------------------------------------------------

    public function getTileURL( level : int, column : uint, row : uint ) : String
    {
        return IMultiScaleImageLevel( levels[ level ] ).getTileURL( column, row )
    }
    
    public function getLevelAt( index : int ) : IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel( levels[ index ] )
    }
    
    
    public function getMinimumLevelForSize( width : Number,
                                            height : Number ) : IMultiScaleImageLevel
    {
    	// TODO
    	var level : IMultiScaleImageLevel
    	
    	for( var i : int = numLevels - 1; i >= 0; i-- )
    	{
        	level = getLevelAt( i )
    		if( level.width < width || level.height < height )
    		  break 
    	}  
    	
        return getLevelAt( clamp( level.index, 0, numLevels - 1 ) ).clone()
    }
    
    public function clone() : IMultiScaleImageDescriptor
    {
        return new OpenZoomDescriptor( source, new XML( data ) )
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[OpenZoomDescriptor]" + "\n" + super.toString()
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
        _tileWidth = data.pyramid.@tileWidth
        _tileHeight = data.pyramid.@tileHeight

        _type = data.pyramid.@type
        _tileOverlap = data.pyramid.@overlap
        
        _numLevels = data.pyramid.level.length()
        
        for each( var level : XML in data.pyramid.level )
        {
        	var uris : Array = []
        	for each( var uri : XML in level.uri )
        	{
        		uris.push( uri.@template.toString() )
        	}
        	
        	levels[ int(level.@index.toString()) ] = new OpenZoomLevel( this, level.@index,
        	                                     level.@width, level.@height,
        	                                     level.@columns, level.@rows,
        	                                     uris )
        }
    }

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
        
        return levels 
    }
}

}