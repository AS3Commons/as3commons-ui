package org.as3commons.ui.lifecycle.i10n {

	import flash.display.DisplayObject;

	/**
	 * Invalidation service definition.
	 * 
	 * @author Jens Struwe 09.09.2011
	 */
	public interface II10N {

		/**
		 * Adds a validation phase.
		 * 
		 * <p>The processing order of phases equals the insertion order.</p>
		 * 
		 * @param phaseName Unique name of the phase.
		 * @param order Phase order (I10N.TOP_DOWN or I10N.BOTTOM_UP).
		 * @param loopback Property indicates when the validation cycle should rewind to the first phase.  
		 */
		function addPhase(phaseName : String, order : String, loopback : String = "loopback_after_item") : void;
		
		/**
		 * Starts the service.
		 * 
		 * <p>You need to have added at least one validation phase. Otherwise an error is thrown.</p>
		 */
		function start() : void;

		/**
		 * Registers a display object.
		 * 
		 * <p>You need to start the service before, otherwise an error is thrown.</p>
		 *
		 * <p>You cannot register the same object twice. An error is thrown if you try.</p>
		 *
		 * <p>You cannot reuse an adapter for another display object. An error is thrown if you try.</p>
		 * 
		 * @param displayObject The display object to register.
		 * @param adapter The adapter defining the communication between display object and I10N.
		 */
		function registerDisplayObject(displayObject : DisplayObject, adapter : I10NAdapter) : void;
		
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
