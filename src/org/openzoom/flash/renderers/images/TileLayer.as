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
//  Portions created by the Initial Developer are Copyright (c) 2007-2009
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
package org.openzoom.flash.renderers.images
{

import caurina.transitions.Tweener;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.descriptors.IImagePyramidLevel;

[ExcludeClass]
/**
 * @private
 *
 * Layer for holding tiles.
 */
public class TileLayer extends Sprite implements ITileLayer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_TILE_SHOW_DURATION:Number = 2.5

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function TileLayer(width:Number, height:Number,
                              level:IImagePyramidLevel)
    {
        _level = level

        // FIXME
//      scaleXFactor = width  / level.width
//      scaleYFactor = height / level.height

        mouseEnabled = false
        mouseChildren = false

        createFrame(width, height)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    // TODO: Consider using Sprite because of event propagation.
    private var frame:Shape
    private var data:IImagePyramidLevel
    private var scaleFactorX:Number = 1
    private var scaleFactorY:Number = 1

    private var tiles:Dictionary = new Dictionary(true)

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _level:IImagePyramidLevel

    public function get level():IImagePyramidLevel
    {
        return _level
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function containsTile(tile:Tile):Boolean
    {
        return tiles[tile.hashCode]
    }

    public function addTile(tile:Tile):Tile
    {
        if (tile.level != level.index)
        {
            trace("[TileLayer]: Adding Tile from wrong level.")
            return null
        }

        // return if tile already added
        if (tiles[tile.hashCode])
           return null

        // store reference to tile
        tiles[tile.hashCode] = tile

        // add tile
        var tileBitmap:Bitmap = tile.bitmap

        var bounds:Rectangle = level.getTileBounds(tile.column, tile.row)

        tileBitmap.scaleX = scaleFactorX
        tileBitmap.scaleY = scaleFactorY

        tileBitmap.x = bounds.x * scaleFactorX
        tileBitmap.y = bounds.y * scaleFactorY


        if (tileBitmap.x >= level.width || tileBitmap.y >= level.height)
            trace("[TileLayer]: Wrong tile positioning")


        var tileBitmapRight:Number = tileBitmap.x + tileBitmap.width
        var tileBitmapBottom:Number = tileBitmap.y + tileBitmap.height

        var horizontalOverflow:Boolean = tileBitmapRight > level.width
        var verticalOverflow:Boolean = tileBitmapBottom > level.height

        // Crop tiles that are too large
        if (horizontalOverflow || verticalOverflow)
        {
            trace("[TileLayer]: Overflow")

            if (horizontalOverflow)
                trace("[TileLayer]: horizontalOverflow:", level.width, tileBitmapRight, tile.toString(), bounds)

            if (verticalOverflow)
                trace("[TileLayer]: verticalOverflow:", level.height, tileBitmapBottom, tile.toString(), bounds)

            // TODO: Check bounds with new descriptor API
            var cropBitmapData:BitmapData =
                   new BitmapData(Math.min(level.width - tileBitmap.x, tileBitmap.width),
                                  Math.min(level.height - tileBitmap.y, tileBitmap.height),
                                  true)
            cropBitmapData.copyPixels(tileBitmap.bitmapData,
                                      cropBitmapData.rect,
                                      new Point(0, 0))
            var croppedTileBitmap:Bitmap = new Bitmap(cropBitmapData)
            croppedTileBitmap.x = tileBitmap.x
            croppedTileBitmap.y = tileBitmap.y
            croppedTileBitmap.scaleX = tileBitmap.scaleX
            croppedTileBitmap.scaleY = tileBitmap.scaleY
            tileBitmap = croppedTileBitmap
        }

        if (tileBitmap.x + tileBitmap.width > level.width ||
            tileBitmap.y + tileBitmap.height > level.height)
            trace("[TileLayer]: Bad cropping")


        // FIXME: Debug coloring
//        var colorTransform:ColorTransform = tileBitmap.transform.colorTransform
//        colorTransform.color = Math.random() * 0xFFFFFF
//        tileBitmap.transform.colorTransform = colorTransform


        // TODO: Refactor
        tileBitmap.smoothing = true
        tileBitmap.alpha = 0

        addChild(tileBitmap)

        // TODO: Remove dependency on Tweener
        Tweener.addTween(tileBitmap, {alpha: 1, time: DEFAULT_TILE_SHOW_DURATION})

        return tile
    }

    public function removeAllTiles():void
    {
        // Keep Frame
        while (numChildren > 1)
          removeChildAt(1)

        tiles = new Dictionary(true)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function createFrame(width:Number, height:Number):void
    {
        frame = new Shape()
        var g:Graphics = frame.graphics
        g.beginFill(0x000000, 0)
        g.drawRect(0, 0, width, height)
        g.endFill()

        addChild(frame)
    }
}

}
