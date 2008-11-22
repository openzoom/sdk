package org.openzoom.viewer
{

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

import org.openzoom.core.INormalizedViewport;
import org.openzoom.core.IScene;	

public class MultiScaleScene extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
     public function MultiScaleScene( width : Number, height : Number )
     {
     	frame = createFrame( width, height )
     	addChildAt( frame, 0 )
     }
     
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var frame : Shape
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function createFrame( width : Number, height : Number ) : Shape
    {
    	var background : Shape = new Shape()
    	var g : Graphics = background.graphics
    	g.beginFill( 0x333333, 0.4 )
    	g.drawRect( 0, 0, width, height )
    	g.endFill()
    	return background
    }
}

}