package org.openzoom.flash.net
{

import flash.events.IEventDispatcher;

/**
 *  Dispatched when an item successfully finished loading.
 *
 *  @eventType org.openzoom.events.LoadingItemEvent.COMPLETE
 */
[Event(name="complete", type="org.openzoom.events.LoadingItemEvent")]

/**
 *  Dispatched when an item caused an error during loading.
 *
 *  @eventType org.openzoom.events.LoadingItemEvent.ERROR
 */
[Event(name="error", type="org.openzoom.events.LoadingItemEvent")]

/**
 * Interface for loading items.
 */
public interface ILoadingItem extends IEventDispatcher
{
    function load() : void
//    function cancel() : void
}

}