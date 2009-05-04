package org.openzoom.examples.powerLawScaling.renderers
{

import org.openzoom.examples.powerLawScaling.Pin;
import org.openzoom.flash.renderers.ScaleInvariantRenderer;

public class SimplePinRenderer extends ScaleInvariantRenderer
{
	public function SimplePinRenderer()
	{
        addChild(new Pin())
	}
}

}