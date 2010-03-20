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
package org.openzoom.flash.components
{

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.IImagePyramidDescriptor;
import org.openzoom.flash.descriptors.ImagePyramidDescriptorFactory;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;
import org.openzoom.flash.utils.uri.resolveURI;

use namespace openzoom_internal;

/**
 *  Dispatched when the image has successfully loaded.
 *
 *  @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

/**
 *  Dispatched when an IO error has occured while loading the image.
 *
 *  @eventType flash.events.IOErrorEvent.IO_ERROR
 */
[Event(name="ioError", type="flash.events.IOErrorEvent")]

/**
 *  Dispatched when an security error has occured while loading the image.
 *
 *  @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

/**
 * Flash component for displaying a single multiscale image.
 * Inspired by the <a href="http://msdn.microsoft.com/en-us/library/system.windows.controls.multiscaleimage(VS.95).aspx">
 * Microsoft Silverlight Deep Zoom MultiScaleImage control.</a>
 * This implementation has built-in support for Zoomify, Deep Zoom and OpenZoom images.
 * Basic keyboard and mouse navigation can be added by specifying viewport controllers through the <code>controllers</code> property.
 * The animation can be customized by adding a viewport transformer through the <code>transformer</code> property.
 * Zoom, visibility or custom constraints can be added through the <code>constraint</code> property.
 */
public final class MultiScaleImage extends MultiScaleImageBase
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleImage()
    {
        super()

        tabEnabled = false
        tabChildren = true
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var url:String
    private var urlLoader:URLLoader

    private var image:ImagePyramidRenderer

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------

    private var _source:IImagePyramidDescriptor

    /**
     * Source of this image. Either a URL as String or an
     * instance of IMultiScaleImageDescriptor.
     *
     * @see org.openzoom.flash.descriptors.IMultiScaleImageDescriptor
     */
    public function get source():Object
    {
        return _source
    }

    public function set source(value:Object):void
    {
        if (value is String)
        {
            if (String(value) === url)
                return

            url = String(value)

            if (loaderInfo)
                url = resolveURI(loaderInfo.url, String(value))

            urlLoader = new URLLoader(new URLRequest(url))

            urlLoader.addEventListener(Event.COMPLETE,
                                       urlLoader_completeHandler,
                                       false, 0, true )
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR,
                                       urlLoader_ioErrorHandler,
                                       false, 0, true )
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                       urlLoader_securityErrorHandler,
                                       false, 0, true )
        }
        
        if (_source)
        {
            _source = null

            if (container.numChildren > 0)
                container.removeChildAt(0)
        }

        if (value is IImagePyramidDescriptor)
        {
            _source = IImagePyramidDescriptor(value)
            addImage(_source)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function addImage(descriptor:IImagePyramidDescriptor):void
    {
        var aspectRatio:Number = descriptor.width / descriptor.height
        var sceneWidth:Number
        var sceneHeight:Number

        if (aspectRatio > 1)
        {
            sceneWidth  = DEFAULT_SCENE_DIMENSION
            sceneHeight = DEFAULT_SCENE_DIMENSION / aspectRatio
        }
        else
        {
            sceneWidth  = DEFAULT_SCENE_DIMENSION * aspectRatio
            sceneHeight = DEFAULT_SCENE_DIMENSION
        }

        // resize scene
        container.sceneWidth = sceneWidth
        container.sceneHeight = sceneHeight

        // create renderer
        image = createImage(descriptor,
                            sceneWidth,
                            sceneHeight)

        container.addChild(image)
        container.showAll(true)
        dispatchEvent(new Event(Event.COMPLETE))
    }

    /**
     * @private
     */
    private function createImage(descriptor:IImagePyramidDescriptor,
                                 width:Number,
                                 height:Number):ImagePyramidRenderer
    {
        var image:ImagePyramidRenderer = new ImagePyramidRenderer()
        image.source = descriptor
        image.width = width
        image.height = height
        return image
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function urlLoader_completeHandler(event:Event):void
    {
        if (!urlLoader || !urlLoader.data)
            return

        var data:XML = new XML(urlLoader.data)
        var factory:ImagePyramidDescriptorFactory =
                                  ImagePyramidDescriptorFactory.getInstance()
        var descriptor:IImagePyramidDescriptor = factory.getDescriptor(url, data)

        source = descriptor
    }

    /**
     * @private
     */
    private function urlLoader_ioErrorHandler(event:IOErrorEvent):void
    {
        dispatchEvent(event)
    }

    /**
     * @private
     */
    private function urlLoader_securityErrorHandler(event:SecurityErrorEvent):void
    {
        dispatchEvent(event)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    override public function dispose():void
    {
    	image.dispose()
    	image = null
    	
    	try
    	{
	    	urlLoader.close()
    	}
    	catch(error:Error)
    	{
    		// Do nothing
    	}
    	
    	urlLoader = null
    	
    	super.dispose()
    }
}

}
