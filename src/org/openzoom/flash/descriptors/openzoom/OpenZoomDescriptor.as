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
package org.openzoom.flash.descriptors.openzoom
{

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;
import org.openzoom.flash.descriptors.IImageSourceDescriptor;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
import org.openzoom.flash.descriptors.ImageSourceDescriptor;
import org.openzoom.flash.utils.math.clamp;
import org.openzoom.flash.utils.uri.resolveURI;

use namespace openzoom_internal;

/**
 * OpenZoom Descriptor.
 * <a href="http://openzoom.org/specs/">http://openzoom.org/specs/</a>
 */
public final class OpenZoomDescriptor extends ImagePyramidDescriptorBase
                                      implements IImagePyramidDescriptor
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace openzoom = "http://ns.openzoom.org/openzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function OpenZoomDescriptor(uri:String, data:XML)
    {
        use namespace openzoom

        this.data = data

        this.source = uri
        parseXML(data)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var data:XML

    //--------------------------------------------------------------------------
    //
    //  Properties: IImagePyramidDescriptor
    //
    //--------------------------------------------------------------------------

    private var _sources:Array = []

    /**
     * @inheritDoc
     */
    override public function get sources():Array
    {
        return _sources.slice(0)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IImagePyramidDescriptor
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function getTileURL(level:int, column:int, row:int):String
    {
        return getLevelAt(level).getTileURL(column, row)
    }

    /**
     * @inheritDoc
     */
    public function getLevelForSize(width:Number,
                                    height:Number):IImagePyramidLevel
    {
        var currentLevel:IImagePyramidLevel

        for (var i:int = numLevels - 1; i >= 0; i--)
        {
            currentLevel = getLevelAt(i)
            if (currentLevel.width <= width || currentLevel.height <= height)
                break
        }

        var maxLevel:uint = numLevels - 1
        var index:int = clamp(i + 1, 0, maxLevel)
        var level:IImagePyramidLevel = getLevelAt(index)

        // FIXME
        if (width / level.width < 0.5)
            level = getLevelAt(Math.max(0, index - 1))

        if (width / level.width < 0.5)
            trace("[OpenZoomDescriptor] getLevelForSize():", width / level.width)

        return level
    }

    /**
     * @inheritDoc
     */
    public function clone():IImagePyramidDescriptor
    {
        return new OpenZoomDescriptor(source, data.copy())
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
        return "[OpenZoomDescriptor]" + "\n" + super.toString()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function parseXML(data:XML):void
    {
        use namespace openzoom

        // Parse sources
        for each (var source:XML in data.source)
        {
            var path:String = this.source.substring(0, this.source.lastIndexOf("/") + 1)
            var sourceUri:String = resolveURI(path, source.@uri)
            var width:uint = source.@width
            var height:uint = source.@height
            var type:String = source.@type

            var descriptor:IImageSourceDescriptor
            descriptor = new ImageSourceDescriptor(sourceUri, width, height, type)

            _sources.push(descriptor)
        }

        // Grrrrh, E4X
        var pyramid:XML = data.pyramid[0]

        _width = pyramid.@width
        _height = pyramid.@height
        _tileWidth = pyramid.@tileWidth
        _tileHeight = pyramid.@tileHeight

        _type = pyramid.@type
        _tileOverlap = pyramid.@tileOverlap

        _numLevels = data.pyramid.level.length()

        if (ImagePyramidOrigin.isValid(pyramid.@origin))
            _origin = pyramid.@origin

        for (var index:int = 0; index < numLevels; index++)
        {
            var level:XML = data.pyramid.level[index]
            var uris:Array = []

            for each (var uri:XML in level.uri)
                uris.push(uri.@template.toString())

            addLevel(new ImagePyramidLevel(this,
                                           this.source,
                                           index,
                                           level.@width,
                                           level.@height,
                                           level.@columns,
                                           level.@rows,
                                           uris,
                                           origin))
        }
    }
}

}
