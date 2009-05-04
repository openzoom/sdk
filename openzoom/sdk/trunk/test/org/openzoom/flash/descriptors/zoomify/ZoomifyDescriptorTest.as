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

import flexunit.framework.TestCase;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;

/**
 * Tests the ZoomifyDescriptor implementation for correctness.
 */
public class ZoomifyDescriptorTest extends TestCase
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
            [  137,   205,       1,    1],
            [  275,   411,       2,    2],
            [  550,   822,       3,    4],
            [ 1101,  1645,       5,    7],
            [ 2203,  3290,       9,   13],
       ]

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var descriptor:IMultiScaleImageDescriptor

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: TestCase
    //
    //--------------------------------------------------------------------------

    override public function setUp():void
    {
        descriptor = new ZoomifyDescriptor("test.xml", DESCRIPTOR_XML)
    }

    override public function tearDown():void
    {
        descriptor = null
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Tests
    //
    //--------------------------------------------------------------------------

    public function testMaxLevel():void
    {
        assertEquals("Maximum level correctly computed",
                      4, descriptor.numLevels - 1)
    }

    public function testOverlap():void
    {
        assertEquals("Overlap correct", 0, descriptor.tileOverlap)
    }

    public function testLevels():void
    {
       for (var index:int = 0; index < descriptor.numLevels; index++)
       {
              var level:IMultiScaleImageLevel = descriptor.getLevelAt(index)
           assertEquals("Width on level "        + level.index,
                         LEVELS[level.index][0], level.width)
           assertEquals("Height on level "       + level.index,
                         LEVELS[level.index][1], level.height)
           assertEquals("Column count on level " + level.index,
                         LEVELS[level.index][2], level.numColumns)
           assertEquals("Row count on level "    + level.index,
                         LEVELS[level.index][3], level.numRows)
       }

    }

    public function testGetMinimumLevelForSize():void
    {
       assertEquals("Level computation for given size", descriptor.numLevels - 1,
           descriptor.getMinLevelForSize(descriptor.width, descriptor.height).index)

       assertEquals("Level computation for given size", descriptor.numLevels - 3,
           descriptor.getMinLevelForSize(descriptor.width / 2 - 1, descriptor.height / 2 - 1).index)
    }
}

}