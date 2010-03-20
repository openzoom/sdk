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
package org.openzoom.flash.scene
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

import org.openzoom.flash.core.openzoom_internal;

use namespace openzoom_internal;

/**
 * @inheritDoc
 */
[Event(name="resize", type="flash.events.Event")]


[ExcludeClass]
/**
 * @private
 *
 * Basic implementation of IMultiScaleScene
 */
public class MultiScaleScene extends Sprite
						     implements IMultiScaleScene,
                                        IReadonlyMultiScaleScene
{
	include "../core/Version.as"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleScene(width:Number,
                                    height:Number,
                                    backgroundColor:uint=0x000000,
                                    backgroundAlpha:Number=0)
    {
         this.backgroundColor = backgroundColor
         this.backgroundAlpha = backgroundAlpha

         createFrame()

         setFrameSize(width, height)
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var frame:Shape
    private var backgroundColor:uint = 0x000000
    private var backgroundAlpha:Number = 0

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObject
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  numChildren
    //----------------------------------

    /**
     * @inheritDoc
     */
    override public function get numChildren():int
    {
        return super.numChildren - 1
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DisplayObject
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function addChildAt(child:DisplayObject,
                                        index:int):DisplayObject
    {
        return super.addChildAt(child, index + 1)
    }

    /**
     * @inheritDoc
     */
    override public function removeChildAt(index:int):DisplayObject
    {
        return super.removeChildAt(index + 1)
    }

    /**
     * @inheritDoc
     */
    override public function setChildIndex(child:DisplayObject,
                                           index:int):void
    {
        super.setChildIndex(child, index + 1)
    }

    /**
     * @inheritDoc
     */
    override public function getChildAt(index:int):DisplayObject
    {
        return super.getChildAt(index + 1)
    }

    /**
     * @inheritDoc
     */
    override public function getChildIndex(child:DisplayObject):int
    {
        return super.getChildIndex(child) - 1
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleScene
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  targetCoordinateSpace
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get targetCoordinateSpace():DisplayObject
    {
        return this
    }

    //----------------------------------
    //  sceneWidth
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get sceneWidth():Number
    {
        return frame.width
    }

    public function set sceneWidth(value:Number):void
    {
        setFrameSize(value, sceneHeight)
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get sceneHeight():Number
    {
        return frame.height
    }

    public function set sceneHeight(value:Number):void
    {
        setFrameSize(sceneWidth, value)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleScene
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function setActualSize(width:Number, height:Number):void
    {
        setFrameSize(width, height)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function setFrameSize(width:Number, height:Number):void
    {
        if (width == sceneWidth && height == sceneHeight)
            return

        frame.width = width
        frame.height = height

        dispatchEvent(new Event(Event.RESIZE))
    }

    /**
     * @private
     */
    private function createFrame():void
    {
        frame = new Shape()
        var g:Graphics = frame.graphics
            g.beginFill(backgroundColor, backgroundAlpha)
            g.drawRect(0, 0, 100, 100)
            g.endFill()
        addChild(frame)
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IDisposable
    //
    //--------------------------------------------------------------------------
    
    public function dispose():void
    {
        while (super.numChildren > 0)
        	super.removeChildAt(0)

        frame = null
    }
}

}
