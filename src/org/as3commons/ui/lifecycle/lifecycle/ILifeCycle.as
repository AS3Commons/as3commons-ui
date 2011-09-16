package org.as3commons.ui.lifecycle.lifecycle {

	import flash.display.DisplayObject;

	/**
	 * LifeCycle service definition.
	 * 
	 * @author Jens Struwe 16.09.2011
	 */
	public interface ILifeCycle {

		/**
		 * Registers a display object.
		 * 
		 * <p>You cannot register the same object twice. An error is thrown if you try.</p>
		 *
		 * <p>You cannot reuse an adapter for another display object. An error is thrown if you try.</p>
		 * 
		 * @param displayObject The display object to register.
		 * @param adapter The adapter defining the communication between display object and LifeCycle.
		 */
		function registerDisplayObject(displayObject : DisplayObject, adapter : LifeCycleAdapter) : void;
		
		/**
		 * Unregisters a display object.
		 * 
		 * <p>You usually call this method before removing a display object from the application.</p>
		 * 
		 * <p>Any references to that object are being removed when called.</p>
		 * 
		 * @param displayObject The display object to unregister.
		 */
		function unregisterDisplayObject(displayObject : DisplayObject) : void;
		
		/**
		 * Validates all invalid objects immediately.
		 * 
		 * <p>You cannot all this method during a running validation cycle. An error
		 * is thrown if you try.</p>
		 */
		function validateNow() : void;
		
		/**
		 * Flag to indicate if the validation cycle is currently running.
		 */
		function get validationIsRunning() : Boolean;

		/**
		 * The current validation phase.
		 * 
		 * <p><code>null</code> if the validation cycle is not running.</p>
		 */
		function get currentPhaseName() : String;

		/**
		 * The current object being validated.
		 * 
		 * <p><code>null</code> if the validation cycle is not running.</p>
		 */
		function get currentDisplayObject() : DisplayObject;

		/**
		 * Removes all objects from the service.
		 */
		function cleanUp() : void;
		
	}
}
