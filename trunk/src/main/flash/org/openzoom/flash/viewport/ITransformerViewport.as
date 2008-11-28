package org.openzoom.flash.viewport
{

public interface ITransformerViewport extends IViewport
{
    //----------------------------------
    //  transform
    //----------------------------------
    
    function get transform() : IViewportTransform
    function set transform( value : IViewportTransform ) : void

    //----------------------------------
    //  targetTransform
    //----------------------------------
    
    function get targetTransform() : IViewportTransform
    function set targetTransform( value : IViewportTransform ) : void
}

}