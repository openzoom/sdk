package org.openzoom.flash.net
{

import flash.events.IEventDispatcher;

/**
 * Interface for loading items.
 */
public interface ILoadingQueue extends IEventDispatcher
{
	function addItem( url : String, context : * = null ) : ILoadingItem
}

}