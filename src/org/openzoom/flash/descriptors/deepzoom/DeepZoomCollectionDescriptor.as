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
package org.openzoom.flash.descriptors.deepzoom
{

import flash.geom.Point;
import flash.geom.Rectangle;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.utils.MIMEUtil;
import org.openzoom.flash.utils.MortonOrder;

use namespace openzoom_internal;

/**
 * @private
 * 
 * Descriptor for the
 * <a href="http://msdn.microsoft.com/en-us/library/cc645077(VS.95).aspx">
 * Microsoft Deep Zoom Collection (DZC) format</a>.
 */
public final class DeepZoomCollectionDescriptor
{
	include "../../core/Version.as"

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
    public function DeepZoomCollectionDescriptor(source:String, xml:XML)
    {
        use namespace deepzoom

        this.source = source
        _tileSize = xml.@TileSize
        _format = xml.@Format
        _maxLevel = xml.@MaxLevel
        _type = MIMEUtil.getContentType(_format)

        var item:CollectionItem
        for each (var itemXML:XML in xml.Items.*)
        {
            item = CollectionItem.fromXML(source, itemXML)
            items.push(item)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var source:String
    private var items:Array = []

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  format
    //----------------------------------

    private var _format:String

    public function get format():String
    {
        return _format
    }

    //----------------------------------
    //  numItems
    //----------------------------------

    public function get numItems():int
    {
        return items.length
    }

    //----------------------------------
    //  maxLevel
    //----------------------------------

    private var _maxLevel:int = 0

    /**
     * Maximum level of the collection image pyramid
     */
    public function get maxLevel():int
    {
        return _maxLevel
    }

    //----------------------------------
    //  type
    //----------------------------------

    private var _type:String

    /**
     * MIME type of the collection
     */
    public function get type():String
    {
        return type
    }

    //----------------------------------
    //  tileSize
    //----------------------------------

    private var _tileSize:uint

    /**
     * Tile size of the collection image pyramid.
     */
    public function get tileSize():uint
    {
        return _tileSize
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns the URL of the tile of a collection item specified
     * by its Morton number and level.
     */
    public function getTileURL(mortonNumber:uint, level:int):String
    {
        var basePath:String = source.substring(0, source.lastIndexOf("."))
        var path:String = basePath + "_files"

        var position:Point = MortonOrder.getPosition(mortonNumber)
        var size:uint = Math.pow(2, level)
        var column:int = Math.floor((position.x * size) / tileSize)
        var row:int = Math.floor((position.y * size) / tileSize)

        return [path, "/", level, "/", column, "_", row, ".", format].join("")
    }

    /**
     * Returns the bounds (position and dimensions) of the tile of
     * a collection item specified by its Morton number and level.
     */
    public function getTileBounds(mortonNumber:uint, level:int):Rectangle
    {
        return new Rectangle()
    }

    public function getItemBounds(mortonNumber:uint):Rectangle
    {
        var item:CollectionItem = getItemAt(mortonNumber)
        return item.bounds.clone()
    }

    public function getDescriptor(mortonNumber:uint):DeepZoomImageDescriptor
    {
        return null
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function getItemAt(index:int):CollectionItem
    {
        return items[index]
    }

    /**
     * @private
     */
    private function getScale(level:int):Number
    {
        // 1 / (1 << maxLevel - level)
        return Math.pow(0.5, maxLevel - level)
    }

//    /**
//     * @private
//     */
//    private function getSize(level:int):Point
//    {
//        var size:Point = new Point()
//        var scale:Number = getScale(level)
//        size.x = Math.ceil(width * scale)
//        size.y = Math.ceil(height * scale)
//
//        return size
//    }
}

}

import flash.geom.Rectangle
import org.openzoom.flash.utils.uri.resolveURI

//------------------------------------------------------------------------------
//
//  Internal classes
//
//------------------------------------------------------------------------------

/**
 * Represents a single item from the collection.
 */
class CollectionItem
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
    public function CollectionItem()
    {
        // Do nothing
    }

    /**
     * Create collection item from XML
     */
    public static function fromXML(source:String, xml:XML):CollectionItem
    {
        use namespace deepzoom

        var item:CollectionItem = new CollectionItem()

        item.id = xml.@Id
        item.n = xml.@N
        item.source = resolveURI(source, xml.@Source)
        item.width = xml.Size.@Width
        item.height = xml.Size.@Height

        var aspectRatio:Number = item.width / item.height
        item.bounds = new Rectangle(0, 0, 1, 1 / aspectRatio)

        if (xml.Viewport)
        {
            item.viewportWidth = xml.Viewport.@Width
            item.viewportX = xml.Viewport.@X
            item.viewportY = xml.Viewport.@Y

            item.bounds.x = -item.viewportX / item.viewportWidth
            item.bounds.y = -item.viewportY / item.viewportWidth
            item.bounds.width = 1 / item.viewportWidth
            item.bounds.height = item.bounds.width / aspectRatio
        }

        return item
    }

    public var source:String

    public var id:uint
    public var n:uint
    public var width:uint
    public var height:uint

    public var viewportWidth:Number = 1
    public var viewportX:Number = 0
    public var viewportY:Number = 0

    public var bounds:Rectangle
}