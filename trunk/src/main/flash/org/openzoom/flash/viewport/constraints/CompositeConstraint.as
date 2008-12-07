package org.openzoom.flash.viewport.constraints
{

import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransform;

[DefaultProperty("constraints")]
/**
 * CompositeConstraint allows you to apply many different constraints
 * at the same time. This class is an implementation of the
 * Composite Design Pattern by the GoF.
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
    
    /**
     * An array of constraints that are applied succe
     */
    public function get constraints() : Array
    {
    	return _constraints.slice( 0 )
    }
    
    public function set constraints( value : Array ) : void
    {
    	_constraints = value.slice( 0 )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportConstraint
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    public function validate( transform : IViewportTransform ) : IViewportTransform
    {    	
    	for each( var constraint : IViewportConstraint in constraints )
    		transform = constraint.validate( transform )

        return transform
    }
}

}