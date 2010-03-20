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
package
{

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
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
        var cli:LoaderInfo = loader.contentLoaderInfo
        cli.addEventListener(Event.COMPLETE,
                             contentLoaderInfo_completeHandler,
                             false, 0, true)
        cli.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                             contentLoaderInfo_errorHandler,
                             false, 0, true)
        cli.addEventListener(IOErrorEvent.IO_ERROR,
                             contentLoaderInfo_errorHandler,
                             false, 0, true)
        cli.addEventListener(IOErrorEvent.NETWORK_ERROR,
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
