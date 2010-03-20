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
package org.openzoom.flash.descriptors
{

import flash.geom.Rectangle

/**
 * Interface of a level of a multiscale image pyramid.
 */
public interface IImagePyramidLevel
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  index
    //----------------------------------

    /**
     * Returns the index of this level which is in the range [0, numLevels)
     */
    function get index():int

    //----------------------------------
    //  width
    //----------------------------------

    /**
     * Returns the width of this level in pixels.
     */
    function get width():uint

    //----------------------------------
    //  height
    //----------------------------------

    /**
     * Returns the height of this level in pixels.
     */
    function get height():uint

    //----------------------------------
    //  numColumns
    //----------------------------------

    /**
     * Returns the number of columns of tiles for this level.
     */
    function get numColumns():int

    //----------------------------------
    //  numRows
    //----------------------------------

    /**
     * Returns the number of rows of tiles for this level.
     */
    function get numRows():int

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns the URL of the tile at the specified position.
     */
    function getTileURL(column:int, row:int):String

    /**
     * Returns the bounds of the specified tile.
     */
    function getTileBounds(column:int, row:int):Rectangle

    /**
     * Returns a copy of this object.
     */
    function clone():IImagePyramidLevel
}

}
