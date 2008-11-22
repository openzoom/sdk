package org.openzoom.components.flex
{

import org.openzoom.core.IMultiScaleScene;
import org.openzoom.core.IViewport;
	

public interface IMultiScaleContainer
{
    function get scene() : IMultiScaleScene
    function get viewport() : IViewport
    
    function get sceneWidth() : Number	
    function set sceneWidth( value : Number ) : void
    	
    function get sceneHeight() : Number	
    function set sceneHeight( value : Number ) : void
}

}