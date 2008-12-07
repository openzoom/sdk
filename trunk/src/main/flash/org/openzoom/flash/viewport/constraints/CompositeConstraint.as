package org.openzoom.flash.viewport.constraints
{

import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;

/**
 * CompositeConstraint allows you to apply many different constraints
 * at the same time. This class follows the Composite Design Pattern.
 */
public class CompositeConstraint implements IViewportConstraint
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
	/**
	 * Constructor.
	 */
    public function CompositeConstraint()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  constraints
    //----------------------------------
    
    private var _constraints : Array /* of IViewportConstraint */ = []
    
    public function get constraints() : Array
    {
    	return _constraints.slice()
    }
    
    public function set constraints( value : Array ) : void
    {
    	_constraints = value.slice()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportConstraint
    //
    //--------------------------------------------------------------------------
    
    public function validate( transform : IViewportTransform ) : IViewportTransform
    {    	
    	for each( var constraint : IViewportConstraint in constraints )
    		transform = constraint.validate( transform )

        return transform
    }
}

}