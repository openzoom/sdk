////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.descriptors
{

/**
 * The MultiScaleImageDescriptorFactory creates MultiScaleImageDescriptor objects.
 */
public class MultiScaleImageDescriptorFactory
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEEPZOOM_NAMESPACE_URI : String = "http://schemas.microsoft.com/deepzoom/2008"
    private static const OPENZOOM_NAMESPACE_URI : String = "http://openzoom.org/2008/ozi"
    private static const ZOOMIFY_ROOT_TAG_NAME : String = "IMAGE_PROPERTIES"
  
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
    private static var instance : MultiScaleImageDescriptorFactory
  
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
  
    /**
     * Constructor.
     */
    public function MultiScaleImageDescriptorFactory( lock : SingletonLock ) : void
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    public static function getInstance() : MultiScaleImageDescriptorFactory
    {
        if( !instance )
            instance = new MultiScaleImageDescriptorFactory( new SingletonLock() )

        return instance
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public function getDescriptor( source : String,
                                   data : XML ) : IMultiScaleImageDescriptor
    {
        if( data.namespace().uri == OPENZOOM_NAMESPACE_URI )
            return new OZIDescriptor( source, data )
        if( data.namespace().uri == DEEPZOOM_NAMESPACE_URI )
            return new DZIDescriptor( source, data )
        else if( data.name() == ZOOMIFY_ROOT_TAG_NAME )
            return new ZoomifyDescriptor( source, data )
    
        return null
    }
}

}

//------------------------------------------------------------------------------
//
//  Internal
//
//------------------------------------------------------------------------------

class SingletonLock
{
    // Workaround for compile-time singleton enforcement.
}