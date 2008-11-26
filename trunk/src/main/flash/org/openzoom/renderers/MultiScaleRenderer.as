package org.openzoom.renderers
{
import flash.display.Sprite;

import org.openzoom.core.INormalizedViewport;
import org.openzoom.events.ViewportEvent;

public class MultiScaleRenderer extends Sprite implements IMultiScaleRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */ 
    public function MultiScaleRenderer()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleRenderer
    //
    //--------------------------------------------------------------------------
        
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : INormalizedViewport
    
    public function get viewport() : INormalizedViewport
    {
        return _viewport
    }
    
    public function set viewport( value : INormalizedViewport ) : void
    {
        if( viewport === value )
            return
        
        // remove old event listener
        if( viewport )
        {
            viewport.removeEventListener( ViewportEvent.TRANSFORM_START,
                                          viewport_transformStartHandler )
            viewport.removeEventListener( ViewportEvent.TRANSFORM_UPDATE,
                                          viewport_transformUpdateHandler )
            viewport.removeEventListener( ViewportEvent.TRANSFORM_END,
                                          viewport_transformEndHandler )
        }
        
        _viewport = value
        
        // register new event listener
        if( viewport )
        {
            viewport.addEventListener( ViewportEvent.TRANSFORM_START,
                                       viewport_transformStartHandler, false, 0, true )
            viewport.addEventListener( ViewportEvent.TRANSFORM_UPDATE,
                                       viewport_transformUpdateHandler, false, 0, true )
            viewport.addEventListener( ViewportEvent.TRANSFORM_END,
                                       viewport_transformEndHandler, false, 0, true )
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    protected function viewport_transformStartHandler( event : ViewportEvent ) : void
    {
    }
    
    protected function viewport_transformUpdateHandler( event : ViewportEvent ) : void
    {
    }
    
    protected function viewport_transformEndHandler( event : ViewportEvent ) : void
    {
    }
}

}