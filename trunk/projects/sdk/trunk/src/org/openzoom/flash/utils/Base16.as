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
package org.openzoom.flash.utils
{

/**
 * Simple Base16 encoder/decoder.
 *
 * @see http://tools.ietf.org/html/rfc3548
 */
public final class Base16
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns the decoded value of the Base16 encoded String <code>value</code>.
     */
    public static function decode(value:String,
                                   ignoreCase:Boolean = false):String
    {
        var result:String = ""
        var l:int = value.length

//        if (l % 2 != 0)
//            throw new ArgumentError("Argument is not a valid Base16 encoded String.")

        for (var i:int = 0; i < l; i += 2)
        {
            var s:int = parseInt(value.substr(i, 2), 16)
            result += String.fromCharCode(s)
        }

        return result
    }

    /**
     * Returns the Base16 encoded String of <code>value</code>.
     */
    public static function encode(value:String):String
    {
        var result:String = ""
        var l:int = value.length

        for (var i:int = 0; i < l; i++)
            result += value.charCodeAt(i).toString(16)

        return result.toUpperCase()
    }
}

}
