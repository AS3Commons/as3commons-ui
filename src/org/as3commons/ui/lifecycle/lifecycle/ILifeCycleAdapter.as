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
		 * Returns a list of all invalidated properties.
		 * 
		 * @return List of all invalidated properties.
		 */
		function invalidPropertiesToArray() : Array;

		/**
		 * Invalidates the object for the measurement phase.
		 */
		function requestMeasurement() : void;

		/**
		 * Method to test if the object is invalid for the measurement phase.
		 * 
		 * @return <code>true</code> if the component is scheduled to the measurement phase.
		 */
		function shouldMeasure() : Boolean;

		/**
		 * Schedules to the update phase.
		 * 
		 * <p>The optional <code>property</code> argument may be used to declare only parts
		 * of a component to be updated.</p>
		 * 
		 * <p>If <code>property</code> is not set, the system assumes the wish of a full update. In that
		 * case a test for <code>shouldUpdate()</code> will return <code>true</code> for any property.</p>
		 * 
		 * @param property An optional update property.
		 */
		function scheduleUpdate(property : String = null) : void;

		/**
		 * Returns a list of all scheduled updates.
		 * 
		 * @return List of all scheduled updates.
		 */
		function scheduledUpdatesToArray() : Array;

		/**
		 * Method to test if the object is invalid for the update phase.
		 * 
		 * <p>If no <code>property</code> is given, the method checks if the object
		 * is invalid for at least one property.</p>
		 * 
		 * @param property A property to test.
		 * @return <code>true</code> if the update is scheduled.
		 */
		function shouldUpdate(property : String = null) : Boolean;
		
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
