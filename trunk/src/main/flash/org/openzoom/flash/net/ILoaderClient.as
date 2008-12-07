package org.openzoom.flash.net
{

/**
 * @private
 */
public interface ILoaderClient
{
    function get loader() : LoadingQueue
    function set loader( value : LoadingQueue ) : void		
}

}