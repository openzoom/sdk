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
package
{

import flash.display.Sprite;
import flash.utils.getTimer;

[SWF(width="960", height="540", frameRate="60", backgroundColor="#000000")]
public class Performance extends Sprite
{
    private static const NUM_ITERATIONS:int = 1000000

    public function Performance()
    {
        var plainObject:PlainObject = new PlainObject()
        var getterSetterObject:GetterSetterObject = new GetterSetterObject()

        var value:Number

        // Test #1
        var startTime:int = getTimer()

        for (var i:int = 0; i < NUM_ITERATIONS; i++)
        {
            plainObject.value = 5
            value = plainObject.value
        }

        trace(getTimer() - startTime)

        // Test #2
        startTime = getTimer()

        for (var j:int = 0; j < NUM_ITERATIONS; j++)
        {
            getterSetterObject.value = 5
            value = getterSetterObject.value
        }

        trace(getTimer() - startTime)
    }
}

}

class GetterSetterObject
{
    private var _value:Number

    public function get value():Number
    {
        return _value
    }

    public function set value(value:Number):void
    {
        _value = value
    }
}

class PlainObject
{
    public var value:Number
}
