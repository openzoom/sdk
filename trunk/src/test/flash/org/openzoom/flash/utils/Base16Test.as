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

import flexunit.framework.TestCase;

import org.openzoom.flash.utils.Base16;

/**
 * Tests the Base16 utility class implementation for correctness.
 */
public class Base16Test extends TestCase
{
    //--------------------------------------------------------------------------
    //
    //  Includes
    //
    //--------------------------------------------------------------------------
    	
    include "Base16Samples.as"
		
    //--------------------------------------------------------------------------
    //
    //  Methods: Tests
    //
    //--------------------------------------------------------------------------
    
    public function testEncode() : void
    {
        for( var i : int = 0; i < SAMPLES.length; i++ )
        {
            var testCase : Array = SAMPLES[ i ]
            assertEquals( "Correct encoding",
                          Base16.encode( testCase[ 0 ] ), testCase[ 1 ] )
        }
    }
	
	public function testDecode() : void
	{
        for( var i : int = 0; i < SAMPLES.length; i++ )
        {
            var testCase : Array = SAMPLES[ i ]
            assertEquals("Correct decoding",
                          testCase[ 0 ], Base16.decode( testCase[ 1 ] ))
        }
	}
}

}

