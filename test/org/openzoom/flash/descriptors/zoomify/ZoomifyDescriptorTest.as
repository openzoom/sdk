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
package org.openzoom.flash.descriptors.zoomify
{

import org.flexunit.Assert;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.IImagePyramidLevel;

/**
 * Tests the ZoomifyDescriptor implementation for correctness.
 */
public class ZoomifyDescriptorTest
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DESCRIPTOR_XML:XML =
        <IMAGE_PROPERTIES WIDTH="2203" HEIGHT="3290"
         NUMTILES="169" NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />;

    private static const LEVELS:Array =
        [//  width, height, columns, rows
            [ 138,   206,       1,    1],
            [ 276,   412,       2,    2],
            [ 551,   823,       3,    4],
            [1102,  1645,       5,    7],
            [2203,  3290,       9,   13],
        ]

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var descriptor:IImagePyramidDescriptor

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: TestCase
    //
    //--------------------------------------------------------------------------

	[Before]
    public function setUp():void
    {
        descriptor = ZoomifyDescriptor.fromXML("test.xml", DESCRIPTOR_XML)
    }

	[After]
    public function tearDown():void
    {
        descriptor = null
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Tests
    //
    //--------------------------------------------------------------------------

	[Test]
    public function testMaxLevel():void
    {
        Assert.assertEquals("Maximum level correctly computed",
                      4, descriptor.numLevels - 1)
    }
    
	[Test]
    public function testOverlap():void
    {
        Assert.assertEquals("Overlap correct", 0, descriptor.tileOverlap)
    }
    
	[Test]
    public function testLevels():void
    {
       for (var index:int = 0; index < descriptor.numLevels; index++)
       {
              var level:IImagePyramidLevel = descriptor.getLevelAt(index)
           Assert.assertEquals("Width on level "        + level.index,
                         LEVELS[level.index][0], level.width)
           Assert.assertEquals("Height on level "       + level.index,
                         LEVELS[level.index][1], level.height)
           Assert.assertEquals("Column count on level " + level.index,
                         LEVELS[level.index][2], level.numColumns)
           Assert.assertEquals("Row count on level "    + level.index,
                         LEVELS[level.index][3], level.numRows)
       }

    }
    
	[Test]
    public function testGetLevelForSize():void
    {
       Assert.assertEquals("Level computation for given size", descriptor.numLevels - 1,
           descriptor.getLevelForSize(descriptor.width, descriptor.height).index)

       Assert.assertEquals("Level computation for given size", descriptor.numLevels - 2,
           descriptor.getLevelForSize(descriptor.width / 2 - 1, descriptor.height / 2 - 1).index)
    }
}

}