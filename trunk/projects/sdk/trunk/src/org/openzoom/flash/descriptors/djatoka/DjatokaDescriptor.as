////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.flash.descriptors.djatoka
{

import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorBase;
import org.openzoom.flash.descriptors.MultiScaleImageLevel;
import org.openzoom.flash.utils.math.clamp;

public class DjatokaDescriptor extends MultiScaleImageDescriptorBase
                               implements IMultiScaleImageDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_BASE_LEVEL:uint = 6 // 2^6 = 64

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function DjatokaDescriptor(resolverURL:String,
                                      imageURL:String,
                                      width:uint,
                                      height:uint,
                                      tileSize:uint = 256,
                                      tileOverlap:uint = 0,
                                      type:String="image/jpeg")
    {

        levels = new Dictionary()
        this.url = imageURL
        this.resolverURL = resolverURL
        _width = width
        _height = height
        _numLevels = clamp(Math.ceil(Math.log(Math.max(width, height)) / Math.LN2)
                            - DEFAULT_BASE_LEVEL + 1, 0, int.MAX_VALUE)

        _tileWidth = _tileHeight = tileSize
        _tileOverlap = tileOverlap
        _type = type

        for (var index:int = 0; index < numLevels; index++)
        {
            var levelWidth:Number = Math.ceil(getScale(index) * width)
            var levelHeight:Number = Math.ceil(getScale(index) * height)
            var level:IMultiScaleImageLevel =
                            new MultiScaleImageLevel(this,
                                                     index,
                                                     levelWidth,
                                                     levelHeight,
                                                     Math.ceil(levelWidth / tileWidth),
                                                     Math.ceil(levelHeight / tileHeight))
            levels[index] = level
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var resolverURL:String

    private var url:String
    private var levels:Dictionary

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function getLevelAt(index:int):IMultiScaleImageLevel
    {
        return IMultiScaleImageLevel(levels[index])
    }

    public function getMinLevelForSize(width:Number, height:Number):IMultiScaleImageLevel
    {
    	var index:int = clamp(Math.ceil(Math.log(Math.max(width, height)) / Math.LN2)
    	                             - DEFAULT_BASE_LEVEL, 0, numLevels - 1)
        return IMultiScaleImageLevel(getLevelAt(index)).clone()
    }

    public function getTileURL(level:int, column:uint, row:uint):String
    {
        //http://african.lanl.gov/adore-djatoka/resolver?
        //       url_ver=Z39.88-2004 &
        //       rft_id={url} &
        //       svc_id=info:lanl-repo/svc/getRegion &
        //       svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000 &
        //       svc.format={type} &
        //       svc.level={level} &
        //       svc.rotate=0 &
        //       svc.region=1596,634,676,1320

    	var tileBounds:Rectangle = getTileBounds(level, column, row)
    	var currentLevel:IMultiScaleImageLevel = getLevelAt(level)
    	var maxLevel:IMultiScaleImageLevel = getLevelAt(numLevels - 1)
    	tileBounds.x = Math.ceil((tileBounds.x / currentLevel.width) * maxLevel.width)
    	tileBounds.y = Math.ceil((tileBounds.y / currentLevel.height) * maxLevel.height)
    	var region:String = [tileBounds.y, tileBounds.x, tileBounds.height, tileBounds.width].join(",")
    	
    	var url:String =  resolverURL + "?" +
				               "url_ver=Z39.88-2004&" +
				               "rft_id=" + url + "&" +
				               "svc_id=info:lanl-repo/svc/getRegion&" +
				               "svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000&" +
				               "svc.format=" + type + "&" +
				               "svc.level=" + level + "&" +
				               "svc.rotate=0&" +
				               "svc.region=" + region
        return url
    }

    override public function getTileBounds(level:int, column:uint, row:uint):Rectangle
    {
    	var currentLevel:IMultiScaleImageLevel = levels[level] as IMultiScaleImageLevel
    	
    	var offsetX:uint = (column == 0) ? 0:tileOverlap
    	var offsetY:uint = (row    == 0) ? 0:tileOverlap
    	var x:uint = (column * tileWidth)  - offsetX
    	var y:uint = (row    * tileHeight) - offsetY
    	
    	var w:uint = tileWidth +  (column == 0 ? 1 : 2) * tileOverlap
    	var h:uint = tileHeight + (row    == 0 ? 1 : 2) * tileOverlap
    	w = Math.min(w, currentLevel.width - x)
    	h = Math.min(h, currentLevel.height - y)
    	
    	var bounds:Rectangle = new Rectangle(x, y, w, h)
        return bounds
    }

    public function clone():IMultiScaleImageDescriptor
    {
        return new DjatokaDescriptor(resolverURL, url,
                                     width, height,
                                     tileWidth, tileOverlap,
                                     type)
    }

    //--------------------------------------------------------------------------
    //
    //  Internal
    //
    //--------------------------------------------------------------------------

    private function getScale(level:int):Number
    {
        var maxLevel:int = numLevels - 1
        return Math.pow(0.5, maxLevel - level)
    }
}

}