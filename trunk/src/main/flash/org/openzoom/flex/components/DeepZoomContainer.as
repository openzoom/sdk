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
package org.openzoom.flex.components
{

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.openzoom.flash.descriptors.deepzoom.DZIDescriptor;
import org.openzoom.flash.events.LoadingItemEvent;
import org.openzoom.flash.net.ILoadingItem;
import org.openzoom.flash.net.ILoadingQueue;
import org.openzoom.flash.net.LoadingItemType;
import org.openzoom.flash.net.LoadingQueue;
import org.openzoom.flash.renderers.MultiScaleImageRenderer;    

/**
 * Flex component for displaying single Deep Zoom images as well
 * as Deep Zoom collections created by Microsoft Deep Zoom Composer.
 */
public class DeepZoomContainer extends MultiScaleImageBase
{
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
    
    private static const TYPE_COLLECTION : String = "Collection"
    private static const TYPE_IMAGE      : String = "Image"
    
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
        
//      tabEnabled = false
//      tabChildren = true
        
        itemLoadingQueue = new LoadingQueue()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    private var urlLoader : URLLoader
    private var items : Array /* of ItemInfo */ = []
    private var itemLoadingQueue : ILoadingQueue
    private var numItemsToDownload : int = 0
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  source
    //----------------------------------
    
    private var _source : Object
    private var sourceChanged : Boolean = false
    
   ;[Bindable(event="sourceChanged")]
    
    /**
     * URL to load
     */
    public function get source() : Object
    {
        return _source
    }
    
    public function set source( value : Object ) : void
    {
        if (_source !== value)
        {
            _source = value
            
            numItemsToDownload = 0
            items = []
            sourceChanged = true

            invalidateProperties()
            dispatchEvent( new Event( "sourceChanged" ))
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
    override protected function commitProperties() : void
    {
        super.commitProperties()

        if( sourceChanged )
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
    
    private function load( classOrString : Object ) : void
    {
        // Remove all children
        while( container.numChildren > 0 )
            container.removeChildAt( 0 )
        
        // URL
        if( classOrString is String )
        {
            urlLoader = new URLLoader( new URLRequest( String( classOrString )))
            urlLoader.addEventListener( Event.COMPLETE, 
                                        urlLoader_completeHandler,
                                        false, 0, true )
        }
        
        // Descriptor
        if( classOrString is DZIDescriptor )
        {
            createImage( DZIDescriptor( classOrString ))
        }
    }
    
    /**
     * @private
     */ 
    private function loadItems() : void
    {
        for each( var item : ItemInfo in items )
        {
            var loadingItem : ILoadingItem = 
                                 itemLoadingQueue.addItem( item.source,
                                                           LoadingItemType.TEXT,
                                                           item )
            loadingItem.addEventListener( LoadingItemEvent.COMPLETE,
                                          loadingItem_completeHandler )
        }
    }
    
    /**
     * @private
     */ 
    private function itemsLoaded() : void
    {
        var maxX : Number = 0
        var maxY : Number = 0
    	
        var item : ItemInfo
        
        // Precompute the normalized maximum
        // dimensions this collection could take up
    	for each( item in items )
    	{
    		var aspectRatio : Number = item.width / item.height
    		
            item.targetX = -item.viewportX / item.viewportWidth
            item.targetY = -item.viewportY / item.viewportWidth 
    		item.targetWidth  = 1 / item.viewportWidth
    		item.targetHeight = item.targetWidth / aspectRatio
    		
    	    maxX = Math.max( maxX, item.targetX + item.targetWidth )
    	    maxY = Math.max( maxY, item.targetY + item.targetHeight )
    	}
    	
    	// Set the scene size in a way that no overflow can occur
    	var sceneAspectRatio : Number = maxX / maxY
    	
    	if( sceneAspectRatio > 1 )
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
    	for each( item in items )
    	{
    		var targetX      : Number = item.targetX * container.sceneWidth
    		var targetY      : Number = item.targetY * container.sceneWidth
    		var targetWidth  : Number = item.targetWidth  * container.sceneWidth
    		var targetHeight : Number = item.targetHeight * container.sceneWidth
            
//            if( !item.source || !item.data )
//                continue
            
            var descriptor : DZIDescriptor =
                                     new DZIDescriptor( item.source, item.data )
            var renderer : MultiScaleImageRenderer =
                                  new MultiScaleImageRenderer( descriptor,
                                                               container.loader,
                                                               targetWidth,
                                                               targetHeight )
            renderer.x = targetX
            renderer.y = targetY
            
            addChild( renderer )
    	}
            
        // Silverlight MultiScaleImage default behavior, I think
        viewport.width = 1
    	viewport.panTo( 0, 0, true )
    }
    
    /**
     * @private
     */ 
    private function createImage( descriptor : DZIDescriptor ) : void
    {                                   
        var aspectRatio : Number = descriptor.width / descriptor.height
    
        if( aspectRatio > 1 )
        {
            container.sceneWidth  = DEFAULT_SCENE_DIMENSION
            container.sceneHeight = DEFAULT_SCENE_DIMENSION / aspectRatio
        }
        else
        {
            container.sceneWidth  = DEFAULT_SCENE_DIMENSION * aspectRatio
            container.sceneHeight = DEFAULT_SCENE_DIMENSION
        }
        
        var renderer : MultiScaleImageRenderer =
                              new MultiScaleImageRenderer( descriptor,
                                                           container.loader,
                                                           sceneWidth,
                                                           sceneHeight )
        
        addChild( renderer )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */ 
    private function urlLoader_completeHandler( event : Event ) : void
    {
        if( !urlLoader || !urlLoader.data )
            return
        
        var data : XML = new XML( urlLoader.data )
        
        // FIXME: Microsoft Photozoom does not use this namespace?!
        //*
//        if( data.namespace() != deepzoom || data.localName() != TYPE_COLLECTION )
//            return
        
        use namespace deepzoom
        //*/
        
        var item : ItemInfo
        
        if( data.localName() == TYPE_COLLECTION )
        {
            items = []
            for each( var itemXML : XML in data.Items.* )
            {
                item = ItemInfo.fromXML( source.toString(), itemXML )
                items.push( item )
            }
        
	        numItemsToDownload = items.length   
	        loadItems()
        }
        
        if( data.localName() == TYPE_IMAGE )
        {
            var descriptor : DZIDescriptor =
                          new DZIDescriptor( source.toString(), new XML( data ))
            createImage( descriptor )
        }
    }
    
    private function loadingItem_completeHandler( event : LoadingItemEvent ) : void
    {
    	numItemsToDownload--
    	ItemInfo( event.context ).data = new XML( event.data )
    	
    	if( numItemsToDownload == 0 )
            itemsLoaded()
    }
}

}
    
    
//------------------------------------------------------------------------------
//
//  Internal classes
//
//------------------------------------------------------------------------------

import mx.utils.LoaderUtil;

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
    public static function fromXML( source : String, data : XML ) : ItemInfo
    {
        var itemInfo : ItemInfo = new ItemInfo()
        
        use namespace deepzoom
        
        itemInfo.id = data.@Id
        itemInfo.source = LoaderUtil.createAbsoluteURL( source, data.@Source )
        itemInfo.width = data.Size.@Width
        itemInfo.height = data.Size.@Height
        
        if( data.Viewport )
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
    
    public var id : uint = 0
    public var source : String
    public var width : uint
    public var height : uint
    
    public var viewportWidth : Number = 1
    public var viewportX : Number = 0
    public var viewportY : Number = 0
    
    public var data : XML
    
    // FIXME: This probably doesn't belong here
    public var targetX : Number
    public var targetY : Number
    public var targetWidth : Number
    public var targetHeight : Number
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    public function toString() : String
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