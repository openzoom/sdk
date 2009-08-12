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
package org.openzoom.flash.viewport.transformers
{

import org.openzoom.flash.viewport.IViewportTransform
import org.openzoom.flash.viewport.IViewportTransformer

/**
 * The NullTransformer transforms the given viewport without any kind of animation.
 * Null Object Pattern applied to IViewportTransformer.
 */
public final class NullTransformer extends ViewportTransformerBase
                                   implements IViewportTransformer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function NullTransformer()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function stop():void
    {
        // Do nothing
    }

    /**
     * @inheritDoc
     */
    override public function transform(target:IViewportTransform,
                                       immediately:Boolean=false):void
    {
        super.transform(target, immediately)

        viewport.beginTransform()
        viewport.transform = _target
        viewport.endTransform()
    }
}

}
