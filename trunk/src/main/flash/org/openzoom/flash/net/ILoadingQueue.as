package org.openzoom.flash.net
{

import flash.events.IEventDispatcher;

/**
 * Interface for loading items.
 */
public interface ILoadingQueue extends IEventDispatcher
{
	/**
	 * Add item to loading queue.
	 * 
	 * @param url URL of the item to load
	 * @param type Content type of the item to load
	 * @param context Arbitrary data attached to the item for later identification.
	 */
	function addItem( url : String,
	                  type : String,
	                  context : * = null ) : ILoadingItem
}

}