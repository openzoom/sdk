/*

    MultiScaleImage Component
    OpenZoom SDK Example
    http://openzoom.org/

    Developed by Daniel Gasienica <daniel@gasienica.ch>
    License: MPL 1.1/GPL 3/LGPL 3

*/
package
{

import fl.controls.Button;
import fl.controls.Slider;
import fl.events.SliderEvent;

// Imports
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;

import org.openzoom.flash.components.MultiScaleImage;
import org.openzoom.flash.components.SceneNavigator;
import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.gigapan.GigaPanDescriptor;
import org.openzoom.flash.events.ViewportEvent;
import org.openzoom.flash.viewport.constraints.CenterConstraint;
import org.openzoom.flash.viewport.constraints.CompositeConstraint;
import org.openzoom.flash.viewport.constraints.ScaleConstraint;
import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
import org.openzoom.flash.viewport.constraints.ZoomConstraint;
import org.openzoom.flash.viewport.controllers.ContextMenuController;
import org.openzoom.flash.viewport.controllers.KeyboardController;
import org.openzoom.flash.viewport.controllers.MouseController;
import org.openzoom.flash.viewport.transformers.TweenerTransformer;


public class MultiScaleImageFlashCS5Example extends Sprite
{
    public function MultiScaleImageFlashCS5Example()
    {
        // Setup stage
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.addEventListener(Event.RESIZE, stage_resizeHandler)


        // Create MultiScaleImage component
        image = new MultiScaleImage()

        // Listen for complete event that marks that the
        // loading of the image descriptor has finished
        image.addEventListener(Event.COMPLETE, image_completeHandler)

        // Add transformer for smooth zooming
        var transformer:TweenerTransformer = new TweenerTransformer()
        transformer.easing = "easeOutElastic"
        transformer.duration = 1.5 // seconds
        image.transformer = transformer

        // Add controllers for interactivity
        image.controllers = [new MouseController(),
                             new KeyboardController(),
                             new ContextMenuController()]


        // Create a composite constraint that can group
        // multiple constraint since the API of the MultiScaleImage
        // component only allows us to assign one constraint
        var constraint:CompositeConstraint = new CompositeConstraint()

        // Constrain the zoom to always show
        // the image at least at half its size
        var zoomConstraint:ZoomConstraint = new ZoomConstraint()
        zoomConstraint.minZoom = 0.5

        // Prepare a scale constraint that allows us to prevent
        // zooming in beyond the original scale of the image.
        // Note that we can only set the right maximum scale
        // after the image descriptor has loaded
        scaleConstraint = new ScaleConstraint()

        // Constrain the image to be centered when zooming out
        var centerConstraint:CenterConstraint = new CenterConstraint()

        // Ensure that at least 60% of the image
        // in both dimension is always visible
        var visibilityConstraint:VisibilityConstraint = new VisibilityConstraint()
        visibilityConstraint.visibilityRatio = 0.6

        // Group all the constraints in the composite constraint
        constraint.constraints = [zoomConstraint,
                                  scaleConstraint,
                                  centerConstraint,
                                  visibilityConstraint]

        // Apply composite constraint to component
        image.constraint = constraint

        // Set the source image
        image.source = GigaPanDescriptor.fromID(5322, 154730, 36408)

        image.viewport.addEventListener(ViewportEvent.TRANSFORM_UPDATE, viewport_transformHandler)

        sceneNavigator = new SceneNavigator()
        sceneNavigator.viewport = image.viewport


        // Configure buttons
        showAllButton.addEventListener(MouseEvent.CLICK, showAllButton_clickHandler)
        zoomInButton.addEventListener(MouseEvent.CLICK, zoomInButton_clickHandler)
        zoomOutButton.addEventListener(MouseEvent.CLICK, zoomOutButton_clickHandler)
        zoomSlider.addEventListener(SliderEvent.CHANGE, zoomSlider_changeHandler)


        // Layout the component
        layout()
        addChild(image)
        addChild(sceneNavigator)

        // Set the child index to 0 so the image appears
        // as background, behind the buttons
        setChildIndex(image, 0)
    }

    private var image:MultiScaleImage
    private var sceneNavigator:SceneNavigator
    private var scaleConstraint:ScaleConstraint;

    public var showAllButton:Button
    public var zoomInButton:Button
    public var zoomOutButton:Button
    public var zoomSlider:Slider

    // Event handlers
    private function stage_resizeHandler(event:Event):void
    {
        layout()
    }

    private function image_completeHandler(event:Event):void
    {
        var descriptor:IMultiScaleImageDescriptor = image.source as IMultiScaleImageDescriptor

        if (descriptor)
        {
            scaleConstraint.maxScale = descriptor.width / image.sceneWidth
                                 // or descriptor.height / image.sceneHeight,
                                 // as they're supposed to be the same
        }
    }

    private function zoomOutButton_clickHandler(event:Event):void
    {
        // Zoom out by a factor of 2
        image.zoom /= 2
    }

    private function zoomInButton_clickHandler(event:Event):void
    {
        // Zoom in by a factor of 1.8
        image.zoom *= 1.8
    }

    private function showAllButton_clickHandler(event:Event):void
    {
        image.showAll()
    }

    private function zoomSlider_changeHandler(event:SliderEvent):void
    {
        image.zoom = Math.pow(2, zoomSlider.value)
    }

    private function viewport_transformHandler(event:ViewportEvent):void
    {
        zoomSlider.value = Math.log(image.zoom) / Math.LN2
    }

    // Layout
    private function layout():void
    {
        if (image)
        {
            image.width = stage.stageWidth
            image.height = stage.stageHeight
        }

        if (sceneNavigator)
        {
            sceneNavigator.x = 10
            sceneNavigator.y = 10
        }

        zoomSlider.x = 20
        zoomSlider.y = (stage.stageHeight - zoomSlider.height) / 3

        zoomInButton.x = stage.stageWidth - zoomInButton.width - 10
        zoomInButton.y = stage.stageHeight - zoomInButton.height - 10

        zoomOutButton.x = zoomInButton.x - zoomOutButton.width - 4
        zoomOutButton.y = zoomInButton.y

        showAllButton.x = zoomOutButton.x - showAllButton.width - 4
        showAllButton.y = zoomOutButton.y
    }
}

}
