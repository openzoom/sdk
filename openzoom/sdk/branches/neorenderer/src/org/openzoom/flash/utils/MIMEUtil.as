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
 * Utility for working with file extensions and MIME types.
 */
public class MIMEUtil
{
	/**
	 * Returns the official MIME type for the given file extension without a dot.
	 */
    public static function getContentType(extension:String):String
    {
        var type:String

        switch (extension)
        {
            case "jpg":
               type = "image/jpeg"
               break
               
            case "jpeg":
               type = "image/jpeg"
               break

            case "png":
               type = "image/png"
               break

            default:
               throw new ArgumentError("Unknown extension: " + extension)
               break
        }

        return type
    }
}

}
