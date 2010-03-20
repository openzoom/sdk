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
package org.openzoom.flash.renderers.images
{

import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.renderers.Renderer;
import org.openzoom.flash.utils.IDisposable;

use namespace openzoom_internal;

/**
 * @private
 *
 * Image pyramid renderer.
 */
public final class ImagePyramidRenderer extends Renderer
                                        implements IDisposable
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ImagePyramidRenderer()
    {
        openzoom_internal::tileLayer = new Shape()
        addChild(openzoom_internal::tileLayer)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var tileCache:Dictionary /* of ImagePyramidTile */ = new Dictionary()
    openzoom_internal var tileLayer:Shape

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------

    private var _source:*

    public function get source():*
    {
        return _source
    }

    public function set source(value:*):void
    {
        if (_source === value)
           return

        _source = value
    }

    //----------------------------------
    //  width
    //----------------------------------

    private var _width:Number = 0

    override public function get width():Number
    {
        return _width
    }

    override public function set width(value:Number):void
    {
        if (value === _width)
           return

        _width = value

        updateDisplayList()
    }

    //----------------------------------
    //  height
    //----------------------------------

    private var _height:Number = 0

    override public function get height():Number
    {
        return _height
    }

    override public function set height(value:Number):void
    {
        if (value === _height)
           return

        _height = value

        updateDisplayList()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function updateDisplayList():void
    {
        var g:Graphics = graphics
        g.clear()
        g.beginFill(0x000000, 0)
        g.drawRect(0, 0, _width, _height)
        g.endFill()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    openzoom_internal function getTile(level:int, column:int, row:int):ImagePyramidTile
    {
        var descriptor:IImagePyramidDescriptor = _source as IImagePyramidDescriptor

        if (!descriptor)
           trace("[ImagePyramidRenderer] getTile: Source undefined")

        if (!descriptor.existsTile(level, column, row))
            return null

		var tileHash:String = getTileHash(level, column, row)
        var tile:ImagePyramidTile = tileCache[tileHash]

        if (!tile)
        {
            var url:String = descriptor.getTileURL(level, column, row)
            var bounds:Rectangle = descriptor.getTileBounds(level, column, row)

            tile = new ImagePyramidTile(level, column, row, url, bounds)
            tileCache[tileHash] = tile
        }

        return tile
    }
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Hash
	//
	//--------------------------------------------------------------------------
	
	private function getTileHash(level:int, column:int, row:int):String
	{
		return [level, column, row].join("-")
	}

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------

    public function dispose():void
    {
        tileCache = null
        removeChild(openzoom_internal::tileLayer)
        openzoom_internal::tileLayer = null
    }
}

}
