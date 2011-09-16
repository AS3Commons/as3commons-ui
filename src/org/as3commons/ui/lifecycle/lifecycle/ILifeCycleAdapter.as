package org.as3commons.ui.lifecycle.lifecycle {

	import flash.display.DisplayObject;

	/**
	 * LifeCycle adapter definition.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public interface ILifeCycleAdapter {
		
		/**
		 * The object associated with this adapter.
		 */
		function get displayObject() : DisplayObject;

		/**
		 * The nest level of the object.
		 * 
		 * <p>The nest level is set to <code>-1</code> if the object is not in the
		 * display list or the adapter is not registered.</p>
		 */
		function get nestLevel() : int;
		
		/**
		 * Method to test if the object is invalid for at least one phase.
		 */
		function isInvalidForAnyPhase() : Boolean;

		/**
		 * Invalidates the object for the validation phase.
		 * 
		 * <p>The optional <code>property</code> argument may be used to declare only parts
		 * of a component to be invalid.</p>
		 * 
		 * <p>If <code>property</code> is not set, the system assumes the wish of a full validation. In that
		 * case a test for <code>isInvalid()</code> will return <code>true</code> for any property.</p>
		 * 
		 * @param property An optional property to invalidate.
		 */
		function invalidate(property : String = null) : void;

		/**
		 * Method to test if the object is invalid for validation phase.
		 * 
		 * <p>If no <code>property</code> is given, the method checks if the object
		 * is invalid for at least one property.</p>
		 * 
		 * @param property A property to test.
		 */
		function isInvalid(property : String = null) : Boolean;
		
		/**
		 * Invalidates the object for the calculate defaults phase.
		 * 
		 * <p>The optional <code>property</code> argument may be used to declare only parts
		 * of a component to be validated.</p>
		 * 
		 * <p>If <code>property</code> is not set, the system assumes the wish of a full validation. In that
		 * case a test for <code>defaultIsInvalid()</code> will return <code>true</code> for any property.</p>
		 * 
		 * @param property An optional property to invalidate.
		 */
		function invalidateDefaults(property : String = null) : void;

		/**
		 * Method to test if the object is invalid for the calculate defaults phase.
		 * 
		 * <p>If no <code>property</code> is given, the method checks if the object
		 * is invalid for at least one property.</p>
		 * 
		 * @param property A property to test.
		 */
		function defaultIsInvalid(property : String = null) : Boolean;
		
		/**
		 * Schedules a rendering in the render phase.
		 * 
		 * <p>The optional <code>property</code> argument may be used to declare only parts
		 * of a component to be rendered.</p>
		 * 
		 * <p>If <code>property</code> is not set, the system assumes the wish of a full rendering. In that
		 * case a test for <code>shouldRender()</code> will return <code>true</code> for any property.</p>
		 * 
		 * @param property An optional render property.
		 */
		function scheduleRendering(property : String = null) : void;

		/**
		 * Method to test if the object is invalid for the render phase.
		 * 
		 * <p>If no <code>property</code> is given, the method checks if the object
		 * is invalid for at least one property.</p>
		 * 
		 * @param property A property to test.
		 */
		function shouldRender(property : String = null) : Boolean;
		
		/**
		 * Validates the objects immediately.
		 * 
		 * <p>You cannot all this method during a running validation cycle. An error
		 * is thrown if you try.</p>
		 * 
		 * <p>The display list of the current object including all invalid children gets validated.</p>
		 * 
		 * <p>Invalidating non-children during a <code>validateNow()</code> run will skip those components
		 * and schedule them to the next usual validation cycle.</p>
		 */
		function validateNow() : void;

	}
}
