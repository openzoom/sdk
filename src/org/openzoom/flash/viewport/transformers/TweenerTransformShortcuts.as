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

import caurina.transitions.Tweener;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.viewport.IViewportTransform;

use namespace openzoom_internal;

[ExcludeClass]
/**
 * @private
 */
internal final class TweenerTransformShortcuts
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
    public function TweenerTransformShortcuts()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     * Registers all the special properties to the Tweener class,
     * so the Tweener knows what to do with them.
     */
    public static function init(): void {

        // transform splitter properties
        Tweener.registerSpecialPropertySplitter("_transform",
                                                _transform_splitter)

        // transform normal properties
        Tweener.registerSpecialProperty("_transform_x",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["x"])
        Tweener.registerSpecialProperty("_transform_y",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["y"])
        Tweener.registerSpecialProperty("_transform_left",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["left"])
        Tweener.registerSpecialProperty("_transform_right",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["right"])
        Tweener.registerSpecialProperty("_transform_top",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["top"])
        Tweener.registerSpecialProperty("_transform_bottom",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["bottom"])
        Tweener.registerSpecialProperty("_transform_width",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["width"])
        Tweener.registerSpecialProperty("_transform_height",
                                        _transform_property_get,
                                        _transform_property_set,
                                        ["height"])
    }

    public static function _transform_splitter(value:IViewportTransform,
                                               parameters:Array,
                                               extra:Object=null):Array
    {
        var array:Array = new Array()

        if (!value)
        {
            array.push({name: "_transform_x", value: 0})
            array.push({name: "_transform_y", value:  0})
            array.push({name: "_transform_width", value: 100})
            array.push({name: "_transform_height", value: 100})
        }
        else
        {
            array.push({name: "_transform_x", value: value.x})
            array.push({name: "_transform_y", value: value.y})
            array.push({name: "_transform_width", value: value.width})
            array.push({name: "_transform_height", value: value.height})
        }

        return array
    }

    public static function _transform_property_get(obj:Object,
                                                   parameters:Array,
                                                   extra:Object=null):Number
    {
        return obj.transform[parameters[0]]
    }

    public static function _transform_property_set(obj:Object,
                                                   value:Number,
                                                   parameters:Array,
                                                   extra:Object=null):void
    {
        var t:IViewportTransform = obj.transform
        t[parameters[0]] = value
        obj.transform = t
    }
}

}
