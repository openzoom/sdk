package org.openzoom.flash.viewport.transformers
{

import caurina.transitions.Tweener;

import org.openzoom.flash.viewport.IViewportTransform;

public class TweenerTransformShortcuts
{

    public function TweenerTransformShortcuts()
    {
    }

    /**
     * Registers all the special properties to the Tweener class, so the Tweener knows what to do with them.
     */
    public static function init(): void {
    	
        // transform splitter properties
        Tweener.registerSpecialPropertySplitter("_transform", _transform_splitter);

        // transform normal properties
        Tweener.registerSpecialProperty("_transform_x",        _transform_property_get, _transform_property_set, ["x"]);
        Tweener.registerSpecialProperty("_transform_y",        _transform_property_get, _transform_property_set, ["y"]);
        Tweener.registerSpecialProperty("_transform_left",     _transform_property_get, _transform_property_set, ["left"]);
        Tweener.registerSpecialProperty("_transform_right",    _transform_property_get, _transform_property_set, ["right"]);
        Tweener.registerSpecialProperty("_transform_top",      _transform_property_get, _transform_property_set, ["top"]);
        Tweener.registerSpecialProperty("_transform_bottom",   _transform_property_get, _transform_property_set, ["bottom"]);
        Tweener.registerSpecialProperty("_transform_width",    _transform_property_get, _transform_property_set, ["width"]);
        Tweener.registerSpecialProperty("_transform_height",   _transform_property_get, _transform_property_set, ["height"]);
    }



    // ----------------------------------------------------------------------------------------------------------------------------------

    // _transform



    /**

     * Splits the _transform parameter into specific transform variables

     *

     * @param       p_value             Rectangle   The original _transform rectangle

     * @return                          Array       An array containing the .name and .value of all new properties

     */

    public static function _transform_splitter(p_value:IViewportTransform, p_parameters:Array, p_extra:Object = null):Array {
        var nArray:Array = new Array();
        if (p_value == null) {
            nArray.push({name:"_transform_x", value:0});
            nArray.push({name:"_transform_y", value:0});
            nArray.push({name:"_transform_width", value:100});
            nArray.push({name:"_transform_height", value:100});
        } else {
            nArray.push({name:"_transform_x", value:p_value.x});
            nArray.push({name:"_transform_y", value:p_value.y});
            nArray.push({name:"_transform_width", value:p_value.width});
            nArray.push({name:"_transform_height", value:p_value.height});
        }

        return nArray;
    }

    // ----------------------------------------------------------------------------------------------------------------------------------
    // _transform_*

    /**
     * _transform_*
     * Generic function for the properties of the transform object
     */
    public static function _transform_property_get (p_obj:Object, p_parameters:Array, p_extra:Object = null):Number {
        return p_obj.transform[p_parameters[0]];
    }

    public static function _transform_property_set (p_obj:Object, p_value:Number, p_parameters:Array, p_extra:Object = null): void {
        var rect:IViewportTransform = p_obj.transform;
        rect[p_parameters[0]] = p_value;
        p_obj.transform = rect;
    }
}

}