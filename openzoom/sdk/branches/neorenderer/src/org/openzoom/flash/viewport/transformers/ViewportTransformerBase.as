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

import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.constraints.NullConstraint;

/**
 * Base class for implementations of IViewportTransformer
 * providing a basic getter and setter skeleton.
 */
public class ViewportTransformerBase
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const NULL_CONSTRAINT:IViewportConstraint = new NullConstraint()

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ViewportTransformerBase()
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

    private var _viewport:INormalizedViewport

    /**
     * @inheritDoc
     */
    public function get viewport():INormalizedViewport
    {
        return _viewport
    }

    public function set viewport(value:INormalizedViewport):void
    {
        _viewport = value

        if (value)
            _target = viewport.transform
        else
            _target = null
    }

    //----------------------------------
    //  constraint
    //----------------------------------

    private var _constraint:IViewportConstraint = NULL_CONSTRAINT

    /**
     * @inheritDoc
     */
    public function get constraint():IViewportConstraint
    {
        return _constraint
    }

    public function set constraint(value:IViewportConstraint):void
    {
        if (value)
            _constraint = value
        else
            _constraint = NULL_CONSTRAINT
    }

    //----------------------------------
    //  target
    //----------------------------------

    protected var _target:IViewportTransform

    /**
     * @inheritDoc
     */
    public function get target():IViewportTransform
    {
        return _target.clone()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function transform(target:IViewportTransform,
                              immediately:Boolean=false):void
    {
        // Copy target and validate to know where to tween to...
        var previousTarget:IViewportTransform = this.target
        _target = constraint.validate(target.clone(), previousTarget)
    }
}

}