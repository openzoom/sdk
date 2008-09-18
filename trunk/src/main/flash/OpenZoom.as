////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//  Copyright (c) 2008 Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package
{

import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.openzoom.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.descriptors.IMultiScaleImageLevel;
import org.openzoom.descriptors.MultiScaleImageDescriptorFactory;

/**
 * Bootstrapper.
 */
[SWF(width="960", height="680", frameRate="60", backgroundColor="#222222")]
public class OpenZoom extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
	/**
	 * Constructor.
	 */
    public function OpenZoom()
    {
    	stage.align = StageAlign.TOP_LEFT
    	stage.scaleMode = StageScaleMode.NO_SCALE
    	
    	source = "images/deepzoom/morocco.xml"
//    	source = "images/zoomify/morocco/ImageProperties.xml"
    	
        descriptorLoader = new URLLoader()
        descriptorLoader.addEventListener( Event.COMPLETE, loader_completeHandler )
        descriptorLoader.load( new URLRequest( source ) )
	}
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
	private var source : String
	private var descriptor : IMultiScaleImageDescriptor
	private var descriptorLoader : URLLoader

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    	
	private function loader_completeHandler( event : Event ) : void
	{
        var factory : MultiScaleImageDescriptorFactory = MultiScaleImageDescriptorFactory.getInstance()
        descriptor = factory.getDescriptor( source, new XML( descriptorLoader.data ) )
	  	
//	  	testSingleLevel( descriptor.numLevels - 2 )
	    testAllLevels( 200 )
	}
	
	private function testSingleLevel( level : int ) : void
	{
        var image : Sprite = loadImage( descriptor, level )
        addChild( image )
	}
	
	private function testAllLevels( spacing : Number ) : void
	{     
      for( var i : int = 0; i < descriptor.numLevels; i++ )
      {
          var maxLevel : uint = descriptor.numLevels - 1
          var level : uint =  maxLevel - i
          var image : Sprite = loadImage( descriptor, level )
          image.scaleX = image.scaleY = spacing / descriptor.getLevelAt( level ).width
          image.x = i * spacing

          addChild( image )
      }
	}
	
	private function loadImage( descriptor : IMultiScaleImageDescriptor, index : int ) : Sprite
	{
        var level : IMultiScaleImageLevel = descriptor.getLevelAt( index )
        var numColumns : uint = level.numColumns
        var numRows : uint = level.numRows

        var tileLayer : Sprite = new Sprite()
  
        for( var column : uint = 0; column < numColumns; column++ )
        {
            for( var row : uint = 0; row < numRows; row++ )
            {
                var tileLoader : Loader = new Loader()
                tileLoader.load( new URLRequest( descriptor.getTileURL( index, column, row ) ) )
                
                var position : Point = descriptor.getTilePosition( index, column, row )
                tileLoader.x = position.x
                tileLoader.y = position.y
                                
                tileLayer.addChild( tileLoader )
            }
        }
        
        return tileLayer
	}
}

}