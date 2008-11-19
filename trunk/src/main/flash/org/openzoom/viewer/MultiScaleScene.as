package org.openzoom.viewer
{

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

import org.openzoom.core.INormalizedViewport;
import org.openzoom.core.IScene;	

public class MultiScaleScene extends Sprite implements IScene
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
     public function MultiScaleScene( viewport : INormalizedViewport, width : Number, height : Number )
     {
     	this.viewport = viewport
     	frame = createFrame( width, height )
     	addChildAt( frame, 0 )
     }
     
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var frame : Shape
    private var viewport : INormalizedViewport
    
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