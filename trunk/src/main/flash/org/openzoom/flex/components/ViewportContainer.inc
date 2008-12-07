////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
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

/**
 * @private
 */

import flash.geom.Point;


    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleImage
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  zoom
    //----------------------------------
    
    [Bindable]
    
    /**
     * @inheritDoc
     */
    public function get zoom() : Number
    {
        return viewport.zoom    
    }
    
    public function set zoom( value : Number ) : void
    {
        viewport.zoom = value
    }
    
    //----------------------------------
    //  scale
    //----------------------------------
    
    [Bindable]
    
    /**
     * @inheritDoc
     */
    public function get scale() : Number
    {
        return viewport.zoom    
    }
    
    public function set scale( value : Number ) : void
    {
        viewport.scale = value
    }
    
    //----------------------------------
    //  viewportX
    //----------------------------------
    
    [Bindable]
    
    /**
     * @inheritDoc
     */
    public function get viewportX() : Number
    {
        return viewport.x    
    }
    
    public function set viewportX( value : Number ) : void
    {
        viewport.x = value
    }
    
    //----------------------------------
    //  viewportY
    //----------------------------------
    
    [Bindable]
    
    /**
     * @inheritDoc
     */
    public function get viewportY() : Number
    {
        return viewport.y
    }
    
    public function set viewportY( value : Number ) : void
    {
        viewport.y = value
    }
    
    //----------------------------------
    //  viewportWidth
    //----------------------------------
    
    [Bindable]
    
    /**
     * @inheritDoc
     */
    public function get viewportWidth() : Number
    {
        return viewport.width   
    }
    
    public function set viewportWidth( value : Number ) : void
    {
        viewport.width = value
    }
    
    //----------------------------------
    //  viewportHeight
    //----------------------------------
    
    [Bindable]
    
    /**
     * @inheritDoc
     */
    public function get viewportHeight() : Number
    {
        return viewport.height
    }
    
    public function set viewportHeight( value : Number ) : void
    {
        viewport.height = value
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImage
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    public function zoomTo( zoom : Number,
                            transformX : Number,
                            transformY : Number,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomTo( zoom, transformX, transformY, immediately )
    }

    /**
     * @inheritDoc
     */
    public function zoomBy( factor : Number,
                            transformX : Number,
                            transformY : Number,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomBy( factor, transformX, transformY, immediately )
    }

    /**
     * @inheritDoc
     */
    public function panTo( x : Number, y : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panTo( x, y, immediately )
    }
                    
    /**
     * @inheritDoc
     */
    public function panBy( deltaX : Number, deltaY : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panBy( deltaX, deltaY, immediately )
    }
                    
    /**
     * @inheritDoc
     */
    public function localToScene( point : Point ) : Point
    {
        return viewport.localToScene( point )
    }
                    
    /**
     * @inheritDoc
     */
    public function sceneToLocal( point : Point ) : Point
    {
        return viewport.sceneToLocal( point )
    }