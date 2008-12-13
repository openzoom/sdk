package org.openzoom.flash.net
{

/**
 * @private
 */
public interface ILoaderClient
{
    function get loader() : ILoadingQueue
    function set loader( value : ILoadingQueue ) : void		
}

}