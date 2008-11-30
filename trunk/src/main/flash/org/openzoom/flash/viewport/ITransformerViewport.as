package org.openzoom.flash.viewport
{

public interface ITransformerViewport extends IViewport
{   
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  transform
    //----------------------------------
    
    function get transform() : IViewportTransform
    function set transform( value : IViewportTransform ) : void

    //--------------------------------------------------------------------------
    //
    //  Methods: Events
    //
    //--------------------------------------------------------------------------
  
    /**
     * Dispatch <code>transformStart</code> event to
     * let all listeners know that a viewport transition has started.
     */
    function beginTransform() : void
        
    /**
     * Dispatch <code>transformEnd</code> event to
     * let all listeners know that a viewport transition has finished.
     */
    function endTransform() : void 
}

}