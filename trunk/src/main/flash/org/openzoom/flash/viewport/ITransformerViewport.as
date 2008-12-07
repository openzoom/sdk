package org.openzoom.flash.viewport
{

/**
 * Represents a viewport that can be animated / transformed.
 */
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
    
    /**
     * Transformation that is currently applied to the viewport
     */ 
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