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
package org.openzoom.flash.descriptors
{

import org.openzoom.flash.descriptors.deepzoom.DZIDescriptor;
import org.openzoom.flash.descriptors.openzoom.OpenZoomDescriptor;
import org.openzoom.flash.descriptors.zoomify.ZoomifyDescriptor;


/**
 * Factory for creating multiscale image descriptor from given data.
 */
public class MultiScaleImageDescriptorFactory
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEEPZOOM_NAMESPACE_URI:String =
                            "http://schemas.microsoft.com/deepzoom/2008"
    private static const OPENZOOM_NAMESPACE_URI:String =
                            "http://ns.openzoom.org/openzoom/2008"
    private static const ZOOMIFY_ROOT_TAG_NAME:String = "IMAGE_PROPERTIES"

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    private static var instance:MultiScaleImageDescriptorFactory

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleImageDescriptorFactory(lock:SingletonLock):void
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns an instance of this MultiScaleImageDescriptorFactory.
     */
    public static function getInstance():MultiScaleImageDescriptorFactory
    {
        if (!instance)
            instance = new MultiScaleImageDescriptorFactory(new SingletonLock())

        return instance
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns an instance of IMultiScaleImageDescriptor that is based
     * on the data and source that are given.
     *
     * @return An object of type IMultiScaleImageDescriptor or <code>null</code>
     *         if the factory couldn't create a descriptor from the given data.
     */
    public function getDescriptor(uri:String, data:XML):IImagePyramidDescriptor
    {
        if (data.namespace().uri == OPENZOOM_NAMESPACE_URI)
            return new OpenZoomDescriptor(uri, data)

        if (data.namespace().uri == DEEPZOOM_NAMESPACE_URI)
            return DZIDescriptor.fromXML(uri, data)

        if (data.name() == ZOOMIFY_ROOT_TAG_NAME)
            return new ZoomifyDescriptor(uri, data)

        return null
    }
}

}

//------------------------------------------------------------------------------
//
//  Internal
//
//------------------------------------------------------------------------------

/**
 * @private
 */
class SingletonLock
{
    // Workaround for compile-time singleton enforcement.
}
