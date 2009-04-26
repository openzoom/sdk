////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.flash.viewport.transformers
{
import com.flashdynamix.motion.TweensyTimelineZero;
import com.flashdynamix.motion.TweensyZero;

import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;

/**
 * TweensyZeroTransformer is an implementation of IViewportTransformer based on the
 * <a href="http://code.google.com/p/tweensy/">TweensyZero animation library</a>.
 */
public class TweensyZeroTransformer extends ViewportTransformerBase
                                    implements IViewportTransformer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function TweensyZeroTransformer()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var shadowTransform:IViewportTransform
    private var timeline:TweensyTimelineZero
    private var done:Boolean = true

    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function transform(target:IViewportTransform,
                                       immediately:Boolean=false):void
    {
        super.transform(target, immediately)

        if (immediately)
        {
            stop()
            viewport.beginTransform()
//            shadowTransform = _target.clone()
            viewport.transform = _target
            viewport.endTransform()
        }
        else
        {
            shadowTransform = viewport.transform

            if (done)
            {
            	done = false
                viewport.beginTransform()
            }

            timeline = TweensyZero.to(shadowTransform,
                                     {x: _target.x,
                                      y: _target.y,
                                      width: _target.width},
                                      2)

            timeline.onUpdate = updateTransform
            timeline.onComplete = endTransform
        }
    }

    /**
     * @inheritDoc
     */
    public function stop():void
    {
        TweensyZero.pause()
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Helper
    //
    //--------------------------------------------------------------------------

    private function updateTransform():void
    {
        viewport.transform = shadowTransform
    }
    
    private function endTransform():void
    {
    	viewport.endTransform()
    	done = true
    }
}

}
