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
package org.openzoom.flash.viewport.transformers
{

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.constraints.NullConstraint;

use namespace openzoom_internal;

/**
 * @private
 *
 * Base class for implementations of IViewportTransformer
 * providing a basic getter and setter skeleton.
 */
public class ViewportTransformerBase
{
	include "../../core/Version.as"

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

    public function set target(value:IViewportTransform):void
    {
        _target = value
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

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
    	_viewport = null
    	_target = null
    	_constraint = null
    }
}

}