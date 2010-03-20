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

/**
 *  @private
 *
 *  This class is used to link additional classes into openzoom.swc
 *  beyond those that are found by dependency analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class OpenZoomSDK
{
    // Flash components
import org.openzoom.flash.components.MemoryMonitor; org.openzoom.flash.components.MemoryMonitor
import org.openzoom.flash.components.MultiScaleImage; org.openzoom.flash.components.MultiScaleImage
import org.openzoom.flash.components.SceneNavigator; SceneNavigator
import org.openzoom.flash.components.Spinner; Spinner

    // Descriptors
import org.openzoom.flash.descriptors.deepzoom.DeepZoomCollectionDescriptor; DeepZoomCollectionDescriptor
import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptor; DeepZoomImageDescriptor
import org.openzoom.flash.descriptors.djatoka.DjatokaDescriptor; DjatokaDescriptor
import org.openzoom.flash.descriptors.gigapan.GigaPanDescriptor; GigaPanDescriptor
import org.openzoom.flash.descriptors.openstreetmap.OpenStreetMapDescriptor; OpenStreetMapDescriptor
import org.openzoom.flash.descriptors.openzoom.OpenZoomDescriptor; OpenZoomDescriptor
import org.openzoom.flash.descriptors.rosettaproject.RosettaDiskBackDescriptor; RosettaDiskBackDescriptor
import org.openzoom.flash.descriptors.rosettaproject.RosettaDiskFrontDescriptor; RosettaDiskFrontDescriptor
import org.openzoom.flash.descriptors.virtualearth.VirtualEarthDescriptor; VirtualEarthDescriptor
import org.openzoom.flash.descriptors.zoomify.ZoomifyDescriptor; ZoomifyDescriptor

    // Utils
import org.openzoom.flash.utils.Base16; Base16
import org.openzoom.flash.utils.Cache; Cache
import org.openzoom.flash.utils.ExternalMouseWheel; ExternalMouseWheel
import org.openzoom.flash.utils.FullScreenUtil; FullScreenUtil
import org.openzoom.flash.utils.ICache; ICache
import org.openzoom.flash.utils.ICacheItem; ICacheItem
import org.openzoom.flash.utils.IComparable; IComparable
import org.openzoom.flash.utils.IDisposable; IDisposable
import org.openzoom.flash.utils.MIMEUtil; MIMEUtil
import org.openzoom.flash.utils.MortonOrder; MortonOrder

    // Viewport constraints
import org.openzoom.flash.viewport.constraints.CenterConstraint; CenterConstraint
import org.openzoom.flash.viewport.constraints.CompositeConstraint; CompositeConstraint
import org.openzoom.flash.viewport.constraints.FillConstraint; FillConstraint
import org.openzoom.flash.viewport.constraints.MapConstraint; MapConstraint
import org.openzoom.flash.viewport.constraints.NullConstraint; NullConstraint
import org.openzoom.flash.viewport.constraints.ScaleConstraint; ScaleConstraint
import org.openzoom.flash.viewport.constraints.VisibilityConstraint; VisibilityConstraint
import org.openzoom.flash.viewport.constraints.ZoomConstraint; ZoomConstraint

    // Viewport controllers
import org.openzoom.flash.viewport.controllers.ContextMenuController; ContextMenuController
import org.openzoom.flash.viewport.controllers.KeyboardController; KeyboardController
import org.openzoom.flash.viewport.controllers.MouseController; MouseController

    // Viewport transformers
import org.openzoom.flash.viewport.transformers.NullTransformer; NullTransformer
import org.openzoom.flash.viewport.transformers.SmoothTransformer; SmoothTransformer
import org.openzoom.flash.viewport.transformers.TweenerTransformer; TweenerTransformer
import org.openzoom.flash.viewport.transformers.TweensyZeroTransformer; TweensyZeroTransformer

    // Viewport
import org.openzoom.flash.viewport.SceneViewport; SceneViewport

    // Flex components
import org.openzoom.flex.components.DeepZoomContainer; DeepZoomContainer
import org.openzoom.flex.components.MemoryMonitor; org.openzoom.flex.components.MemoryMonitor
import org.openzoom.flex.components.MultiScaleImage; org.openzoom.flex.components.MultiScaleImage
}

}
