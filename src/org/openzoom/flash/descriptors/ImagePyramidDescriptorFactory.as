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
package org.openzoom.flash.descriptors
{

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.descriptors.openzoom.OpenZoomDescriptor;
import org.openzoom.flash.descriptors.zoomify.ZoomifyDescriptor;

use namespace openzoom_internal;


/**
 * Factory for creating multiscale image descriptors from given data.
 */
public class ImagePyramidDescriptorFactory
{
    include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEEPZOOM_2008_NAMESPACE_URI:String =
                            "http://schemas.microsoft.com/deepzoom/2008"
    private static const DEEPZOOM_2009_NAMESPACE_URI:String =
                            "http://schemas.microsoft.com/deepzoom/2009"
    private static const OPENZOOM_NAMESPACE_URI:String =
                            "http://ns.openzoom.org/openzoom/2008"
    private static const ZOOMIFY_ROOT_TAG_NAME:String = "IMAGE_PROPERTIES"

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    private static var instance:ImagePyramidDescriptorFactory

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ImagePyramidDescriptorFactory(lock:SingletonLock):void
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
    public static function getInstance():ImagePyramidDescriptorFactory
    {
        if (!instance)
            instance = new ImagePyramidDescriptorFactory(new SingletonLock())

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
    public function getDescriptor(source:String, xml:XML):IImagePyramidDescriptor
    {
        if (xml.namespace().toString() == OPENZOOM_NAMESPACE_URI)
            return new OpenZoomDescriptor(source, xml)

        if (xml.namespace().toString() == DEEPZOOM_2008_NAMESPACE_URI)
            return DeepZoomImageDescriptor.fromXML(source, xml)

        if (xml.namespace().toString() == DEEPZOOM_2009_NAMESPACE_URI)
            return DeepZoomImageDescriptor.fromXML(source, xml)

        if (xml.name().toString() == ZOOMIFY_ROOT_TAG_NAME)
            return ZoomifyDescriptor.fromXML(source, xml)

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
