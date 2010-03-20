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

import org.flexunit.Assert
import org.openzoom.flash.descriptors.IImagePyramidDescriptor
import org.openzoom.flash.descriptors.IImagePyramidLevel

/**
 * Tests the DeepZoomImageDescriptor implementation for correctness.
 */
public class DeepZoomImageDescriptorTest
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DESCRIPTOR_XML:XML =
        <Image xmlns="http://schemas.microsoft.com/deepzoom/2008"
               TileSize="100" Overlap="0" Format="jpg">
            <Size Width="2592" Height="3872"/>
        </Image>;

    private static const LEVELS:Array =
        [// width, height, columns, rows
            [1,      1,       1,    1],
            [2,      2,       1,    1],
            [3,      4,       1,    1],
            [6,      8,       1,    1],
            [11,    16,       1,    1],
            [21,    31,       1,    1],
            [41,    61,       1,    1],
            [81,   121,       1,    2],
            [162,   242,       2,    3],
            [324,   484,       4,    5],
            [648,   968,       7,   10],
            [1296,  1936,      13,   20],
            [2592,  3872,      26,   39],
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
        descriptor = DeepZoomImageDescriptor.fromXML("test.xml", DESCRIPTOR_XML)
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
        Assert.assertEquals("Maximum level correctly computed", 12, descriptor.numLevels - 1)
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
            Assert.assertEquals("Width on level "        + level.index, LEVELS[level.index][0], level.width)
            Assert.assertEquals("Height on level "       + level.index, LEVELS[level.index][1], level.height)
            Assert.assertEquals("Column count on level " + level.index, LEVELS[level.index][2], level.numColumns)
            Assert.assertEquals("Row count on level "    + level.index, LEVELS[level.index][3], level.numRows)
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

