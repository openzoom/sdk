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
package org.openzoom.examples.powerLawScaling.renderers
{

import org.openzoom.examples.powerLawScaling.Pin;
import org.openzoom.flash.events.RendererEvent;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.renderers.Renderer;

public class AdvancedPinRenderer extends Renderer
{
	public function AdvancedPinRenderer()
	{
        addEventListener(RendererEvent.ADDED_TO_SCENE,
                         addedToSceneHandler,
                         false, 0, true)
	}
	
	private function addedToSceneHandler(event:RendererEvent):void
	{
        viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE,
                                  viewport_transformUpdateHandler,
                                  false, 0, true)
        addChild(new Pin())
        layout()
	}
	
	private function viewport_transformUpdateHandler(event:ViewportEvent):void
	{
		layout()
	}
	
	private function layout():void
	{
		// Inspired by «Powerlaw scaling of synchronized content with Deep Zoom»
		// http://blogs.msdn.com/lutzg/archive/2008/11/03/powerlaw-scaling-of-synchronized-content-with-deep-zoom.aspx
        var factor:Number = Math.log(1 / viewport.width) / Math.LN2
        var scale:Number = Math.pow(0.02 * (factor + 1), 2) + 0.01
		scaleX = scaleY = scale / viewport.scale * 16
	}
}

}