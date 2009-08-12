package org.openzoom.flash.descriptors
{

import org.openzoom.flash.descriptors.deepzoom.DeepZoomImageDescriptorTest
import org.openzoom.flash.descriptors.djatoka.DjatokaDescriptorTest
import org.openzoom.flash.descriptors.zoomify.ZoomifyDescriptorTest

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class DescriptorSuite
{
    public var deepZoomImageDescriptorTest:DeepZoomImageDescriptorTest
    public var djatokaDescriptorTest:DjatokaDescriptorTest
    public var zoomifyDescriptorTest:ZoomifyDescriptorTest
}

}
