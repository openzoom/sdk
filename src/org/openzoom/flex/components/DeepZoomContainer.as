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
package org.openzoom.flex.components
{

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.openzoom.flash.core.openzoom_internal;
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor;
import org.openzoom.flash.events.NetworkRequestEvent;
import org.openzoom.flash.net.INetworkQueue;
import org.openzoom.flash.net.INetworkRequest;
import org.openzoom.flash.net.NetworkQueue;
import org.openzoom.flash.renderers.images.ImagePyramidRenderer;

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
 * @private
 *
 * Flex component for displaying single Deep Zoom images (DZI) as well
 * as Deep Zoom collections (DZC) created by Microsoft Deep Zoom Composer,
 * DeepZoomTools.dll, Python Deep Zoom Tools (deepzoom.py) or others.
 */
public final class DeepZoomContainer extends MultiScaleImageBase
{
	include "../../flash/core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace deepzoom = "http://schemas.microsoft.com/deepzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const TYPE_COLLECTION:String = "Collection"
    private static const TYPE_IMAGE:String = "Image"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function DeepZoomContainer()
    {
        super()

        tabEnabled = false
        tabChildren = true

        itemLoadingQueue = new NetworkQueue()
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var urlLoader:URLLoader
    private var items:Array /* of ItemInfo */ = []
    private var itemLoadingQueue:INetworkQueue
    private var numItemsToDownload:int = 0

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  source
    //----------------------------------

    private var _source:Object
    private var sourceChanged:Boolean = false

   ;[Bindable(event="sourceChanged")]

    /**
     * URL to load
     */
    public function get source():Object
    {
        return _source
    }

    public function set source(value:Object):void
    {
        if (_source !== value)
        {
            _source = value

            numItemsToDownload = 0
            items = []
            sourceChanged = true

            invalidateProperties()
            dispatchEvent(new Event("sourceChanged"))
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties()

        if (sourceChanged )
        {
            sourceChanged = false
            load(_source)
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function load(classOrString:Object):void
    {
        // Remove all children
        while (container.numChildren > 0)
            container.removeChildAt(0)

        // URL
        if (classOrString is String)
        {
            urlLoader = new URLLoader(new URLRequest(String(classOrString)))

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

        // Descriptor
        if (classOrString is DeepZoomImageDescriptor)
        {
            createImage(DeepZoomImageDescriptor(classOrString))
        }
    }

    /**
     * @private
     */
    private function loadItems():void
    {
        for each (var item:ItemInfo in items)
        {
            var request:INetworkRequest = itemLoadingQueue.addRequest(item.source,
                                                                      String,
                                                                      item)
            request.addEventListener(NetworkRequestEvent.COMPLETE,
                                     loadingItem_completeHandler)
        }
    }

    /**
     * @private
     */
    private function itemsLoaded():void
    {
        var maxX:Number = 0
        var maxY:Number = 0

        var item:ItemInfo

        // Precompute the normalized maximum
        // dimensions this collection could take up
        for each (item in items)
        {
            var aspectRatio:Number = item.width / item.height

            item.targetX = -item.viewportX / item.viewportWidth
            item.targetY = -item.viewportY / item.viewportWidth
            item.targetWidth  = 1 / item.viewportWidth
            item.targetHeight = item.targetWidth / aspectRatio

            maxX = Math.max(maxX, item.targetX + item.targetWidth)
            maxY = Math.max(maxY, item.targetY + item.targetHeight)
        }

        // Set the scene size in a way that no overflow can occur
        var sceneAspectRatio:Number = maxX / maxY

        if (sceneAspectRatio > 1)
        {
            container.sceneWidth  = DEFAULT_SCENE_DIMENSION
            container.sceneHeight = DEFAULT_SCENE_DIMENSION / sceneAspectRatio
        }
        else
        {
            container.sceneWidth  = DEFAULT_SCENE_DIMENSION * sceneAspectRatio
            container.sceneHeight = DEFAULT_SCENE_DIMENSION
        }

        // Add, size and position items in scene
        for each (item in items)
        {
            var targetX:Number = item.targetX * container.sceneWidth
            var targetY:Number = item.targetY * container.sceneWidth
            var targetWidth:Number = item.targetWidth  * container.sceneWidth
            var targetHeight:Number = item.targetHeight * container.sceneWidth

            var descriptor:DeepZoomImageDescriptor =
                    DeepZoomImageDescriptor.fromXML(item.source, item.xml)
            var renderer:ImagePyramidRenderer = new ImagePyramidRenderer()
            renderer.source = descriptor
            renderer.width = targetWidth
            renderer.height = targetHeight
            renderer.x = targetX
            renderer.y = targetY

            addChild(renderer)
        }

        // Silverlight MultiScaleImage default behavior, I think
        viewport.width = 1
        viewport.panTo(0, 0, true)
    }

    /**
     * @private
     */
    private function createImage(descriptor:DeepZoomImageDescriptor):void
    {
        var aspectRatio:Number = descriptor.width / descriptor.height

        if (aspectRatio > 1)
        {
            container.sceneWidth  = DEFAULT_SCENE_DIMENSION
            container.sceneHeight = DEFAULT_SCENE_DIMENSION / aspectRatio
        }
        else
        {
            container.sceneWidth  = DEFAULT_SCENE_DIMENSION * aspectRatio
            container.sceneHeight = DEFAULT_SCENE_DIMENSION
        }

        var renderer:ImagePyramidRenderer = new ImagePyramidRenderer()
        renderer.source = descriptor
        renderer.width = sceneWidth
        renderer.height = sceneHeight

        addChild(renderer)
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

        var item:ItemInfo
        use namespace deepzoom

        // Collection
        if (data.localName() == TYPE_COLLECTION)
        {
            items = []
            for each (var itemXML:XML in data.Items.*)
            {
                item = ItemInfo.fromXML(source.toString(), itemXML)
                items.push(item)
            }

            numItemsToDownload = items.length
            loadItems()
        }

        // Single image
        if (data.localName() == TYPE_IMAGE)
        {
            var descriptor:DeepZoomImageDescriptor =
                    DeepZoomImageDescriptor.fromXML(source.toString(), new XML(data))
            createImage(descriptor)
        }
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

    /**
     * @private
     */
    private function loadingItem_completeHandler(event:NetworkRequestEvent):void
    {
        numItemsToDownload--
        ItemInfo(event.context).xml = new XML(event.data)

        if (numItemsToDownload == 0)
            itemsLoaded()
    }
}

}


//------------------------------------------------------------------------------
//
//  Internal classes
//
//------------------------------------------------------------------------------

import mx.utils.LoaderUtil
import org.openzoom.flash.utils.uri.resolveURI

/**
 * @private
 *
 * Represents an item in a Deep Zoom collection.
 */
class ItemInfo
{
    //--------------------------------------------------------------------------
    //
    //  Namespaces
    //
    //--------------------------------------------------------------------------

    namespace deepzoom = "http://schemas.microsoft.com/deepzoom/2008"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function ItemInfo()
    {
    }

    /**
     * @private
     */
    public static function fromXML(source:String, data:XML):ItemInfo
    {
        var itemInfo:ItemInfo = new ItemInfo()

        use namespace deepzoom

        itemInfo.id = data.@Id
        itemInfo.source = resolveURI(source, data.@Source)
        itemInfo.width = data.Size.@Width
        itemInfo.height = data.Size.@Height

        if (data.Viewport.length() > 0)
        {
            itemInfo.viewportWidth = data.Viewport.@Width
            itemInfo.viewportX = data.Viewport.@X
            itemInfo.viewportY = data.Viewport.@Y
        }

        return itemInfo
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public var id:uint = 0
    public var source:String
    public var width:uint
    public var height:uint

    public var viewportWidth:Number = 1
    public var viewportX:Number = 0
    public var viewportY:Number = 0

    public var xml:XML

    // FIXME: This probably doesn't belong here
    public var targetX:Number
    public var targetY:Number
    public var targetWidth:Number
    public var targetHeight:Number

    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------

    public function toString():String
    {
        return "[ItemInfo]" + "\n" +
               "id:" + id + "\n" +
               "source:" + source + "\n" +
               "width:" + width + "\n" +
               "height:" + height + "\n" +
               "viewportWidth:" + viewportWidth + "\n" +
               "viewportX:" + viewportX + "\n" +
               "viewportY:" + viewportY
    }
}
