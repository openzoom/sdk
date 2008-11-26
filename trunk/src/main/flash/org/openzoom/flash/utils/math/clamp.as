////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.flash.utils.math
{
    public function clamp( value : Number,
                           minimum : Number = 0,
                           maximum : Number = 1 ) : Number
    {
        // Equivalent but, according to some article I read once upon a time,
        // faster than: Math.max( minimum, Math.min( value, maximum ) )
        // I know, I know, premature optimization… =)
        return ( value < minimum ) ? minimum : ( value > maximum ? maximum : value )
    }
}