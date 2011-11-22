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
package org.openzoom.flash.descriptors.imgcnv
{

    import flash.geom.Point;

    import org.openzoom.flash.core.openzoom_internal;
    import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
    import org.openzoom.flash.descriptors.IImagePyramidLevel;
    import org.openzoom.flash.descriptors.ImagePyramidDescriptorBase;
    import org.openzoom.flash.descriptors.ImagePyramidLevel;
    import org.openzoom.flash.utils.math.clamp;

    use namespace openzoom_internal;

    /**
     * Descriptor for the
     * <a href="http://bioimage.ucsb.edu/downloads/BioImage%20Convert">BioImage Convert</a>
     * multiscale image format.
     */
    public final class ImgcnvDescriptor extends ImagePyramidDescriptorBase
        implements IImagePyramidDescriptor
    {
        include "../../core/Version.as"

        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------

        private static const DEFAULT_TILE_FORMAT:String = "png"
        private static const DEFAULT_TYPE:String = "image/png"
        private static const DEFAULT_TILE_OVERLAP:uint = 0

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * Constructor.
         */
        public function ImgcnvDescriptor(source:String,
                                         width:uint,
                                         height:uint,
                                         tileSize:uint=256)
        {
            this.source = source

            _width = width
            _height = height

            _tileWidth = _tileHeight = tileSize
            _tileOverlap = DEFAULT_TILE_OVERLAP

            _type = DEFAULT_TYPE
            format = DEFAULT_TILE_FORMAT

            _numLevels = getNumLevels(width, height, tileSize)
            createLevels(width, height, tileSize, numLevels)
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        private var format:String

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  tileSize
        //----------------------------------

        /**
         * Returns the size of a single tile of the image pyramid in pixels.
         */
        public function get tileSize():uint
        {
            return _tileWidth
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
            var maxLevel:int = numLevels - 1
            var paddedLevel = zeroPad(clamp(maxLevel - level, 0, maxLevel), 3)
            var paddedColumn = zeroPad(column, 3)
            var paddedRow = zeroPad(row, 3)

            var url:String = [source, paddedLevel, "_", paddedColumn, "_", paddedRow, ".", format].join("")

            return url
        }

        /**
         * @inheritDoc
         */
        public function getLevelForSize(width:Number, height:Number):IImagePyramidLevel
        {
            var longestSide:Number = Math.max(width, height)
            var log2:Number = (Math.log(longestSide) - Math.log(tileSize)) / Math.LN2
            var maxLevel:uint = numLevels - 1
            var index:int = clamp(Math.ceil(log2), 0, maxLevel)
            var level:IImagePyramidLevel = getLevelAt(index)

            return level
        }

        /**
         * @inheritDoc
         */
        public function clone():IImagePyramidDescriptor
        {
            return new ImgcnvDescriptor(source, width, height, tileSize)
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
            return "[ImgcnvDescriptor]" + "\n" + super.toString()
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: Internal
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         */
        private function getNumLevels(width:uint, height:uint, tileSize:uint):uint
        {
            // How many levels until image fits into a single tile
            return Math.ceil(Math.log(Math.ceil(Math.max(width, height) / tileSize))/Math.LN2) + 1
        }

        /**
         * @private
         */
        private function createLevels(originalWidth:uint,
                                      originalHeight:uint,
                                      tileSize:uint,
                                      numLevels:int):void
        {
            var maxLevel:int = numLevels - 1

            for (var index:int = 0; index <= maxLevel; index++)
            {
                var size:Point = getSize(index)
                var width:uint = size.x
                var height:uint = size.y
                var numColumns:int = Math.ceil(width / tileSize)
                var numRows:int = Math.ceil(height / tileSize)
                var level:IImagePyramidLevel = new ImagePyramidLevel(this,
                    index,
                    width,
                    height,
                    numColumns,
                    numRows)
                addLevel(level)
            }
        }

        /**
         * @private
         */
        private function getScale(level:int):Number
        {
            var maxLevel:int = numLevels - 1
            return Math.pow(0.5, maxLevel - level)
        }

        /**
         * @private
         */
        private function getSize(level:int):Point
        {
            var size:Point = new Point()
            var scale:Number = getScale(level)
            size.x = Math.floor(width * scale)
            size.y = Math.floor(height * scale)

            return size
        }



        /**
         * @private
         */

        private function zeroPad(number:int, length:int):String {
            var result:String = number.toString();

            while (result.length < length)
                result = "0" + result

            return result
        }
    }

}
