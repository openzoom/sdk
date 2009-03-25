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

import org.openzoom.flash.viewport.ITransformerViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;

/**
 * Null Object Pattern applied to IViewportTransformer.
 * The NullTransformer transforms the given viewport without any kind of animation.
 */
public class NullTransformer implements IViewportTransformer
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
    //  Properties: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  viewport
    //----------------------------------

    private var _viewport:ITransformerViewport

    /**
     * @inheritDoc
     */
    public function get viewport():ITransformerViewport
    {
        return _viewport
    }

    public function set viewport( value:ITransformerViewport ):void
    {
        _viewport = value

        if( value )
            _target = viewport.transform
        else
            _target = null
    }

    //----------------------------------
    //  constraint
    //----------------------------------

    private var _constraint:IViewportConstraint

    /**
     * @inheritDoc
     */
    public function get constraint():IViewportConstraint
    {
        return _constraint
    }

    public function set constraint( value:IViewportConstraint ):void
    {
        _constraint = value
    }

    //----------------------------------
    //  target
    //----------------------------------

    private var _target:IViewportTransform

    /**
     * @inheritDoc
     */
    public function get target():IViewportTransform
    {
        return _target.clone()
//        return viewport.transform
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
    public function transform( targetTransform:IViewportTransform,
                               immediately:Boolean = false ):void
    {
        // copy targetTransform
        _target = targetTransform.clone()

        viewport.beginTransform()
        viewport.transform = _target
        viewport.endTransform()
    }
}

}