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
package org.openzoom.flash.viewport.constraints
{

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;

use namespace openzoom_internal;

/**
 * Provides basic bounds checking by ensuring that a certain ratio of the scene
 * is always visible.
 */
public final class VisibilityConstraint implements IViewportConstraint
{
	include "../../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_VISIBILITY_RATIO:Number = 0.5

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function VisibilityConstraint()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  visibilityRatio
    //----------------------------------

    private var _visibilityRatio:Number = DEFAULT_VISIBILITY_RATIO


    /**
     * Indicates the minimal ratio that has to visible of the scene.
     */
    public function get visibilityRatio():Number
    {
        return _visibilityRatio
    }

    public function set visibilityRatio(value:Number):void
    {
       _visibilityRatio = value
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportConstraint
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function validate(transform:IViewportTransform,
                             target:IViewportTransform):IViewportTransform
    {
        // FIXME: Issue 5
        // http://code.google.com/p/open-zoom/issues/detail?id=5

        var x:Number = transform.x
        var y:Number = transform.y

        // scene is wider than viewport
        if (transform.width < 1)
        {
            // horizontal bounds checking:
            // the viewport sticks out on the left:
            // align it with the left margin
            if (transform.x + transform.width * (1 - visibilityRatio) < 0)
                x = -transform.width * (1 - visibilityRatio)

           // the viewport sticks out on the right:
           // align it with the right margin
           if (transform.x + transform.width * visibilityRatio > 1)
               x = 1 - transform.width * visibilityRatio
        }
        else
        {
            if (transform.x > (1 - visibilityRatio))
                x = 1 - visibilityRatio

            if (transform.x + transform.width * (1 - visibilityRatio) < 0)
                x = -transform.width * (1 - visibilityRatio)
        }

        // scene is taller than viewport
        if (transform.height < 1)
        {
            // vertical bounds checking:
            // the viewport sticks out at the top:
            // align it with the top margin
            if (transform.y + transform.height * (1 - visibilityRatio) < 0)
                y = -transform.height * (1 - visibilityRatio)

            // the viewport sticks out at the bottom:
            // align it with the bottom margin
            if (transform.y + transform.height * visibilityRatio > 1)
                y = 1 - transform.height * visibilityRatio
        }
        else
        {
            if (transform.y > (1 - visibilityRatio))
                y = 1 - visibilityRatio

            if (transform.y + transform.height * (1 - visibilityRatio) < 0)
                y = -transform.height * (1 - visibilityRatio)
        }

        // validate bounds
        transform.panTo(x, y)

        // return validated transform
        return transform
    }
}

}
