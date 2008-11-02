////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
//  Copyright (c) 2008,      Zoomorama
//                           Olivier Gambier <viapanda@gmail.com>
//                           Daniel Gasienica <daniel@gasienica.ch>
//                           Eric Hubscher <erich@zoomorama.com>
//                           David Marteau <dhmarteau@gmail.com>
//  Copyright (c) 2007,      Rick Companje <rick@companje.nl>
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
package org.openzoom.core
{

import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

//------------------------------------------------------------------------------
//
//  Events
//
//------------------------------------------------------------------------------

[Event(name="resize", type="org.openzoom.events.ViewportEvent")]
[Event(name="change", type="org.openzoom.events.ViewportEvent")]
[Event(name="changeComplete", type="org.openzoom.events.ViewportEvent")]


/**
 * IViewport implementation that is based on the scene coordinate system.
 */
public class SceneViewport extends EventDispatcher implements ISceneViewport
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function SceneViewport( viewport : INormalizedViewport )
	{
		this.viewport = viewport
	}
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var viewport : INormalizedViewport
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IViewport
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  scene
    //----------------------------------
    
    public function get scene() : IScene
    {
    	return viewport.scene
    }
    
    public function set scene( value : IScene ) : void
    {
    	viewport.scene = scene
    }
    
    //----------------------------------
    //  bounds
    //----------------------------------
    
    public function get bounds() : Rectangle
    {
    	return viewport.bounds
    }
    
    public function set bounds( value : Rectangle ) : void
    {
    	viewport.bounds = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: IViewport
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  minZ
    //----------------------------------

    public function get minZ() : Number
    {
        return viewport.minZ
    }
    
    public function set minZ( value : Number ) : void
    {
    	viewport.minZ = value
    }
    
    //----------------------------------
    //  maxZ
    //----------------------------------
    
    public function get maxZ() : Number
    {
        return viewport.maxZ
    }
    
    public function set maxZ( value : Number ) : void
    {
        viewport.maxZ = value
    }
    
    //----------------------------------
    //  scale
    //----------------------------------
    
    public function get scale() : Number
    {
    	return viewport.scale
    }
    
    //----------------------------------
    //  z
    //----------------------------------
    
    public function get z() : Number
    {
        return viewport.z
    }
    
    public function set z( value : Number ) : void
    {
        viewport.z = value
    }
    
    //----------------------------------
    //  x
    //----------------------------------
    
    public function get x() : Number
    {
        return denormalizeX( viewport.x )
    }
    
    public function set x( value : Number ) : void
    {
        viewport.x = normalizeX( value )
    }
    
    //----------------------------------
    //  y
    //----------------------------------
    
    public function get y() : Number
    {
        return denormalizeY( viewport.y )
    }
    
    public function set y( value : Number ) : void
    {
        viewport.y = normalizeY( value )
    }
    
    //----------------------------------
    //  width
    //----------------------------------
    
    public function get width() : Number
    {
        return denormalizeX( viewport.width )
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    public function get height() : Number
    {
        return denormalizeY( viewport.height )
    }
    
    //----------------------------------
    //  left
    //----------------------------------
    
    public function get left() : Number
    {
        return x
    }
    
    //----------------------------------
    //  right
    //----------------------------------
    
    public function get right() : Number
    {
        return x + width
    }
    
    //----------------------------------
    //  top
    //----------------------------------
    
    public function get top() : Number
    {
        return y
    }
    
    //----------------------------------
    //  bottom
    //----------------------------------
    
    public function get bottom() : Number
    {
        return y + height
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewport
    //
    //--------------------------------------------------------------------------
    
    public function contains( x : Number, y : Number ) : Boolean
    {
    	return viewport.contains( normalizeX( x ), normalizeY( y ))
    }
        
    public function intersects( toIntersect : Rectangle ) : Boolean
    {
    	return viewport.intersects( normalizeRectangle( toIntersect))
    }
    
    public function intersection( toIntersect : Rectangle ) : Rectangle
    {
    	return viewport.intersection( normalizeRectangle( toIntersect ))
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------

    public function moveTo( x : Number, y : Number,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        viewport.moveTo(  normalizeX( x ),
                          normalizeY( y ),
                          dispatchChangeEvent )
    }

    public function moveBy( x : Number, y : Number,
                            dispatchChangeEvent : Boolean = true ) : void
    {
        viewport.moveBy( normalizeX( x ),
                         normalizeY( y ),
                         dispatchChangeEvent )
    }

    public function moveCenterTo( x : Number, y : Number,
                                  dispatchChangeEvent : Boolean = true ) : void
    {
        viewport.moveCenterTo( normalizeX( x ),
                               normalizeY( y ),
                               dispatchChangeEvent )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming (content coordinate system)
    //
    //--------------------------------------------------------------------------

    public function zoomTo( z : Number,
                            originX : Number = NaN,
                            originY : Number = NaN,
                            dispatchEvent : Boolean = true ) : void
    {
        viewport.zoomTo( z,
                         isNaN( originX ) ? 0.5 : normalizeX( originX ),
                         isNaN( originY ) ? 0.5 : normalizeY( originY ),
                         dispatchEvent )
    }

    public function zoomBy( factor : Number,
                            originX : Number = NaN,
                            originY : Number = NaN,
                            dispatchEvent : Boolean = true ) : void
    {
        viewport.zoomBy( factor,
                         isNaN( originX ) ? 0.5 : normalizeX( originX ),
                         isNaN( originY ) ? 0.5 : normalizeY( originY ),
                         dispatchEvent )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Navigation
    //
    //--------------------------------------------------------------------------
    
    public function goto( x : Number, y : Number, z : Number,
                          dispatchChangeEvent : Boolean = true ) : void
    {
   	    viewport.goto( normalizeX( x ), normalizeY( y ), z, dispatchChangeEvent )
    }
                   
    public function showArea( area : Rectangle, scale : Number = 1.0,
                              dispatchChangeEvent : Boolean = true ) : void
	{
		viewport.showArea( area, scale, dispatchChangeEvent )  	
	}

    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate transformations
    //
    //--------------------------------------------------------------------------

    public function localToScene( point : Point ) : Point
    {
        return viewport.localToScene( normalizePoint( point ))
    }

    public function sceneToLocal( point : Point ) : Point
    {
    	return viewport.sceneToLocal( normalizePoint( point ))
    }
                       
    //--------------------------------------------------------------------------
    //
    //  Methods: Events
    //
    //--------------------------------------------------------------------------
        
    public function dispatchChangeCompleteEvent() : void
    {
    	viewport.dispatchChangeCompleteEvent()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Coordinate conversion
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */ 
    private function normalizeX( value : Number ) : Number
    {
        return value / scene.width
    }

    /**
     * @private
     */
    private function normalizeY( value : Number ) : Number
    {
        return value / scene.height
    }
    
    /**
     * @private
     */
    private function normalizeRectangle( value : Rectangle ) : Rectangle
    {
        return new Rectangle( normalizeX( value.x ),
                              normalizeY( value.y ),
                              normalizeX( value.width ),
                              normalizeY( value.height ))
    }
    
    /**
     * @private
     */
    private function normalizePoint( value : Point ) : Point
    {
        return new Point( normalizeX( value.x ),
                          normalizeY( value.y ))
    }
    
    /**
     * @private
     */ 
    private function denormalizeX( value : Number ) : Number
    {
        return value * scene.width
    }

    /**
     * @private
     */
    private function denormalizeY( value : Number ) : Number
    {
        return value * scene.height
    }
    
    /**
     * @private
     */
    private function denormalizePoint( value : Point ) : Point
    {
        return new Point( denormalizeX( value.x ),
                          denormalizeY( value.y ))
    }
    
    /**
     * @private
     */
    private function denormalizeRectangle( value : Rectangle ) : Rectangle
    {
        return new Rectangle( denormalizeX( value.x ),
                              denormalizeY( value.y ),
                              denormalizeX( value.width ),
                              denormalizeY( value.height ))
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Debug
    //
    //--------------------------------------------------------------------------
    
    override public function toString() : String
    {
        return "[SceneViewport]" + "\n"
               + "x=" + x + "\n" 
               + "y=" + y  + "\n"
               + "z=" + z + "\n"
               + "w=" + width + "\n"
               + "h=" + height + "\n"
               + "sW=" + scene.width + "\n"
               + "sH=" + scene.height
    }
}

}