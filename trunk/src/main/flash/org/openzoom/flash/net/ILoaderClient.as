package org.openzoom.flash.net
{

public interface ILoaderClient
{
    function get loader() : LoadingQueue
    function set loader( value : LoadingQueue ) : void		
}

}