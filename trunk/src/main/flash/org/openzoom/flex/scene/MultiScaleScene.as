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
package org.openzoom.flex.scene
{

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;

import mx.components.Group;

import org.openzoom.flash.scene.IMultiScaleScene;
import org.openzoom.flash.scene.IReadonlyMultiScaleScene;

/**
 * MultiScaleScene class based on the Flex framework.
 */
public class MultiScaleScene extends Group
                             implements IMultiScaleScene,
                                        IReadonlyMultiScaleScene
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DEFAULT_SCENE_WIDTH  : Number = 24000
    private static const DEFAULT_SCENE_HEIGHT : Number = 16000

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function MultiScaleScene()
    {
        super()

        var g : Graphics = graphics
            g.beginFill( 0xFF6600, 0.5 )
            g.drawRect( 0, 0, DEFAULT_SCENE_WIDTH, DEFAULT_SCENE_HEIGHT )
            g.endFill()
        tabEnabled = false
        tabChildren = true
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var frame : Shape

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  targetCoordinateSpace
    //----------------------------------

    public function get targetCoordinateSpace() : DisplayObject
    {
        return this
    }

    //----------------------------------
    //  sceneWidth
    //----------------------------------

    private var _sceneWidth : Number = DEFAULT_SCENE_WIDTH
    private var sceneWidthChanged : Boolean = false

   ;[Bindable(event="resize")]

    /**
     * @inheritDoc
     */
    public function get sceneWidth() : Number
    {
        return _sceneWidth
    }

    public function set sceneWidth( value : Number ) : void
    {
        if( _sceneWidth != value )
        {
            _sceneWidth = value
            sceneWidthChanged = true

            invalidateProperties()
            invalidateDisplayList()
        }
    }

    //----------------------------------
    //  sceneHeight
    //----------------------------------

    private var _sceneHeight : Number = DEFAULT_SCENE_HEIGHT
    private var sceneHeightChanged : Boolean = false

   ;[Bindable(event="resize")]

    /**
     * @inheritDoc
     */
    public function get sceneHeight() : Number
    {
        return _sceneHeight
    }

    public function set sceneHeight( value : Number ) : void
    {
//        if( _sceneHeight != value )
//        {
//            _sceneHeight = value
//            sceneHeightChanged = true
//
//            invalidateProperties()
//            invalidateDisplayList()
//        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function createChildren() : void
    {
        if( !frame )
            createFrame()
    }

    /**
     * @private
     */
//    override protected function updateDisplayList( unscaledWidth : Number,
//                                                   unscaledHeight : Number ) : void
//    {
//        super.updateDisplayList( unscaledWidth, unscaledHeight )
//    }

    /**
     * @private
     */
    override protected function commitProperties() : void
    {
        super.commitProperties()

//        if( sceneWidthChanged || sceneHeightChanged )
//        {
//            frame.width = sceneWidth
//            frame.height = sceneHeight
//
//            sceneWidthChanged = sceneHeightChanged = false
//            dispatchEvent( new Event( Event.RESIZE ))
//        }
    }
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function createFrame() : void
    {
        frame = new Shape()
        var g : Graphics = frame.graphics
            g.beginFill( 0xFF6600, 0.5 )
            g.drawRect( 0, 0, 1, 100 )
            g.endFill()
//        addChild( frame )
        addItem( frame )
    }
}

}