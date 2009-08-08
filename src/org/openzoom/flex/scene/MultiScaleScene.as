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
//  Portions created by the Initial Developer are Copyright (c) 2007-2009
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
package org.openzoom.flex.scene
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;

//import mx.components.Group;

import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;

/**
 * @private
 *
 * MultiScaleScene class based on the Flex 4 framework.
 */
public class MultiScaleScene// extends Group
                            // implements IMultiScaleScene,
                            //            IReadonlyMultiScaleScene
{
//    //--------------------------------------------------------------------------
//    //
//    //  Class constants
//    //
//    //--------------------------------------------------------------------------
//
//    private static const DEFAULT_SCENE_WIDTH:Number = 24000
//    private static const DEFAULT_SCENE_HEIGHT:Number = 16000
//
//    //--------------------------------------------------------------------------
//    //
//    //  Constructor
//    //
//    //--------------------------------------------------------------------------
//
//    /**
//     * Constructor.
//     */
//    public function MultiScaleScene()
//    {
//        super()
//
//        var g:Graphics = graphics
//            g.beginFill(0xFF6600, 0.5)
//            g.drawRect(0, 0, DEFAULT_SCENE_WIDTH, DEFAULT_SCENE_HEIGHT)
//            g.endFill()
//        tabEnabled = false
//        tabChildren = true
//    }
//
//    //--------------------------------------------------------------------------
//    //
//    //  Variables
//    //
//    //--------------------------------------------------------------------------
//
//    private var frame:Shape
//
//    //--------------------------------------------------------------------------
//    //
//    //  Properties
//    //
//    //--------------------------------------------------------------------------
//
//    //----------------------------------
//    //  targetCoordinateSpace
//    //----------------------------------
//
//    public function get targetCoordinateSpace():DisplayObject
//    {
//        return this
//    }
//
//    //----------------------------------
//    //  sceneWidth
//    //----------------------------------
//
//    private var _sceneWidth:Number = DEFAULT_SCENE_WIDTH
//    private var sceneWidthChanged:Boolean = false
//
//   ;[Bindable(event="resize")]
//
//    /**
//     * @inheritDoc
//     */
//    public function get sceneWidth():Number
//    {
//        return _sceneWidth
//    }
//
//    public function set sceneWidth(value:Number):void
//    {
//        if (_sceneWidth != value)
//        {
//            _sceneWidth = value
//            sceneWidthChanged = true
//
//            invalidateProperties()
//            invalidateDisplayList()
//        }
//    }
//
//    //----------------------------------
//    //  sceneHeight
//    //----------------------------------
//
//    private var _sceneHeight:Number = DEFAULT_SCENE_HEIGHT
//    private var sceneHeightChanged:Boolean = false
//
//   ;[Bindable(event="resize")]
//
//    /**
//     * @inheritDoc
//     */
//    public function get sceneHeight():Number
//    {
//        return _sceneHeight
//    }
//
//    public function set sceneHeight(value:Number):void
//    {
////        if (_sceneHeight != value)
////        {
////            _sceneHeight = value
////            sceneHeightChanged = true
////
////            invalidateProperties()
////            invalidateDisplayList()
////        }
//    }
//
//    //--------------------------------------------------------------------------
//    //
//    //  Overridden methods: UIComponent
//    //
//    //--------------------------------------------------------------------------
//
//    /**
//     * @private
//     */
//    override protected function createChildren():void
//    {
//        if (!frame)
//            createFrame()
//    }
//
//    /**
//     * @private
//     */
////    override protected function updateDisplayList(unscaledWidth:Number,
////                                                   unscaledHeight:Number):void
////    {
////        super.updateDisplayList(unscaledWidth, unscaledHeight)
////    }
//
//    /**
//     * @private
//     */
//    override protected function commitProperties():void
//    {
//        super.commitProperties()
//
////        if (sceneWidthChanged || sceneHeightChanged)
////        {
////            frame.width = sceneWidth
////            frame.height = sceneHeight
////
////            sceneWidthChanged = sceneHeightChanged = false
////            dispatchEvent(new Event(Event.RESIZE ))
////        }
//    }
//    //--------------------------------------------------------------------------
//    //
//    //  Methods: Internal
//    //
//    //--------------------------------------------------------------------------
//
//    /**
//     * @private
//     */
//    private function createFrame():void
//    {
//        frame = new Shape()
//        var g:Graphics = frame.graphics
//            g.beginFill(0xFF6600, 0.5)
//            g.drawRect(0, 0, 1, 100)
//            g.endFill()
////      addChild(frame)
//        addItem(frame)
//    }
}

}
