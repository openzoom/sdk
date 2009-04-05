////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.scene
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

/**
 * @inheritDoc
 */
[Event(name="resize", type="flash.events.Event")]


[ExcludeClass]

/**
 * Basic implementation of IMultiScaleScene
 */
public class MultiScaleScene extends Sprite implements IMultiScaleScene,
                                                       IReadonlyMultiScaleScene
{
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
        return super.getChildIndex(child) + 1
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
//          g.beginFill(0x0088FF, 0.2)
            g.drawRect(0, 0, 100, 100)
            g.endFill()
        addChild(frame)
    }
}

}
