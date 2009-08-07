package
{

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;

[SWF(width="480", height="480", frameRate="60", backgroundColor="#222222")]
public class ImagesCrossDomain extends Sprite
{
    private var loader:Loader
    private static const DEFAULT_URL:String = "http://a0.ortho.tiles.virtualearth.net/tiles/a12022103300.jpeg?g=275"

    public function ImagesCrossDomain()
    {
        loader = new Loader()
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
                                                  contentLoaderInfo_completeHandler,
                                                  false, 0, true)
        loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                                  contentLoaderInfo_errorHandler,
                                                  false, 0, true)
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
                                                  contentLoaderInfo_errorHandler,
                                                  false, 0, true)
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,
                                                  contentLoaderInfo_errorHandler,
                                                  false, 0, true)
        var request:URLRequest = new URLRequest(DEFAULT_URL)
        loader.load(request)
    }

    private function contentLoaderInfo_completeHandler(event:Event):void
    {
        // This works…
        addChild(loader)

        // …that doesn't.
//      var bitmap:Bitmap = loader.content as Bitmap
//      bitmap.smoothing // Forget about this!
//      addChild(bitmap)
    }

    private function contentLoaderInfo_errorHandler(event:Event):void
    {
        trace("Oops, something went wrong…")
    }
}

}
