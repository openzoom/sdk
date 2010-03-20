////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.descriptors.djatoka
{

import flash.geom.Rectangle;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImagePyramidLevel;
import org.openzoom.flash.utils.math.clamp;

use namespace openzoom_internal;

/**
 * Descriptor for the
 * <a href="http://african.lanl.gov/aDORe/projects/djatoka/">
 * djatoka Image Server</a> by the Los Alamos National Library.
 */
public final class DjatokaDescriptor extends ImagePyramidDescriptorBase
                                     implements IImagePyramidDescriptor
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    // http://apps.sourceforge.net/mediawiki/djatoka/index.php?title=Djatoka_Level_Logic
    private static const DEFAULT_BASE_DIMENSION:Number = 96

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
                                      tileSize:uint=256,
                                      tileOverlap:uint=0,
                                      type:String="image/jpeg",
                                      dwtLevels:int=-1)
    {

        this.imageURL = imageURL
        this.resolverURL = resolverURL
        _width = width
        _height = height

        var side:uint = Math.max(width, height)

        if (dwtLevels > 0) // != -1
        {
            this.dwtLevels = dwtLevels
            var computedBaseDimension:uint = Math.ceil(side * Math.pow(0.5, dwtLevels))
            baseDimension = Math.max(DEFAULT_BASE_DIMENSION, computedBaseDimension)
        }

        var log2:Number = (Math.log(side / baseDimension)) / Math.LN2
        _numLevels = clamp(Math.ceil(log2) + 1, 0, int.MAX_VALUE)

        _tileWidth = _tileHeight = tileSize
        _tileOverlap = tileOverlap
        _type = type

        for (var index:int = 0; index < numLevels; index++)
        {
            var levelWidth:Number = Math.ceil(getScale(index) * width)
            var levelHeight:Number = Math.ceil(getScale(index) * height)
            var level:IImagePyramidLevel =
                            new ImagePyramidLevel(this,
                                                  index,
                                                  levelWidth,
                                                  levelHeight,
                                                  Math.ceil(levelWidth / tileWidth),
                                                  Math.ceil(levelHeight / tileHeight))
            addLevel(level)
        }
    }


    /**
     * Constructor.
     */
    public static function fromJSONMetadata(resolverURL:String,
                                            imageURL:String,
                                            jsonString:String,
                                            tileSize:uint=256,
                                            tileOverlap:uint=0,
                                            type:String="image/jpeg"):DjatokaDescriptor
    {
        var widthPattern:RegExp = /(\Dwidth\D*:\D*)(\d+)/
        var heightPattern:RegExp = /(\Dheight\D*:\D*)(\d+)/
        var dwtLevelsPattern:RegExp = /(\DdwtLevels\D*:\D*)(\d+)/

        try
        {
            var width:uint = widthPattern.exec(jsonString)[2]
            var height:uint = heightPattern.exec(jsonString)[2]
            var dwtLevels:int = dwtLevelsPattern.exec(jsonString)[2]
        }
        catch (error:Error)
        {
            throw new ArgumentError("Failed to parse djatoka metadata JSON.")
        }

        var descriptor:DjatokaDescriptor = new DjatokaDescriptor(resolverURL,
                                                                 imageURL,
                                                                 width,
                                                                 height,
                                                                 tileSize,
                                                                 tileOverlap,
                                                                 type,
                                                                 dwtLevels)

        return descriptor
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var resolverURL:String
    private var imageURL:String

    private var dwtLevels:int = -1
    private var baseDimension:Number = DEFAULT_BASE_DIMENSION

    //--------------------------------------------------------------------------
    //
    //  Methods: IImagePyramidDescriptor
    //
    //--------------------------------------------------------------------------

    public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
    {
        var maxLevel:uint = numLevels - 1
        var longestSide:Number = Math.max(width, height)
        var log2:Number = Math.log(longestSide / baseDimension) / Math.LN2
        var index:int = clamp(Math.ceil(log2), 0, maxLevel)

        return getLevelAt(index)
    }

    public function getTileURL(level:int, column:int, row:int):String
    {
        //http://localhost/adore-djatoka/resolver?
        //       url_ver=Z39.88-2004 &
        //       rft_id={url} &
        //       svc_id=info:lanl-repo/svc/getRegion &
        //       svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000 &
        //       svc.format={type} &
        //       svc.level={level} &
        //       svc.rotate=0 &
        //       svc.region=1596,634,676,1320

        var tileBounds:Rectangle = getTileBounds(level, column, row)
        var currentLevel:IImagePyramidLevel = getLevelAt(level)
        var maxLevel:IImagePyramidLevel = getLevelAt(numLevels - 1)
        tileBounds.x = Math.ceil((tileBounds.x / currentLevel.width) * maxLevel.width)
        tileBounds.y = Math.ceil((tileBounds.y / currentLevel.height) * maxLevel.height)
        var region:String = [tileBounds.y, tileBounds.x, tileBounds.height, tileBounds.width].join(",")

        var url:String = resolverURL + "?" +
                            "url_ver=Z39.88-2004&" +
                            "rft_id=" + imageURL + "&" +
                            "svc_id=info:lanl-repo/svc/getRegion&" +
                            "svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000&" +
                            "svc.format=" + type + "&" +
                            "svc.level=" + level + "&" +
                            "svc.region=" + region
        return url
    }

    public function clone():IImagePyramidDescriptor
    {
        return new DjatokaDescriptor(resolverURL,
                                     imageURL,
                                     width,
                                     height,
                                     tileWidth,
                                     tileOverlap,
                                     type,
                                     dwtLevels)
    }
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Debug
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function toString():String
	{
		return "[DjatokaDescriptor]" + "\n" + super.toString()
	}

    //--------------------------------------------------------------------------
    //
    //  Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getScale(level:int):Number
    {
        var maxLevel:int = numLevels - 1
        return Math.pow(0.5, maxLevel - level)
    }
}

}
