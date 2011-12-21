package org.as3commons.ui.lifecycle.i10n {

	import flash.display.DisplayObject;

	/**
	 * Invalidation adapter definition.
	 * 
	 * @author Jens Struwe 09.09.2011
	 */
	public interface II10NAdapter {
		
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
		 * Invalidates the object for the given phase.
		 * 
		 * <p>The optional <code>property</code> argument may be used to declare only parts
		 * of a component to be invalid.</p>
		 * 
		 * <p>If <code>property</code> is not set, the system assumes the wish of a full validation. In that
		 * case a test for <code>isInvalid(phaseName)</code> will return <code>true</code> for any property.</p>
		 * 
		 * @param phaseName The name of the phase to invalidate the object for.
		 * @param property An optional invalidation property.
		 */
		function invalidate(phaseName : String, property : String = null) : void;

		/**
		 * Method to test if a property has been invalidated beforehand.
		 * 
		 * <p>If no phase name is given, the method checks if the object is invalid for
		 * at least one phase.</p>
		 * 
		 * <p>If no <code>property</code> is given, the method checks if the object is invalid for
		 * at least one property of the given phase.</p>
		 * 
		 * @param phaseName A phase name to test.
		 * @param property A property to test.
		 * @return <code>true</code> if the object is invalid regarding the given properties.
		 */
		function isInvalid(phaseName : String = null, property : String = null) : Boolean;

		/**
		 * Returns a list of all properties invalidated for the specified phase. 
		 * 
		 * @param phaseName A phase name to test.
		 * @return List of all invalidated properties.
		 */
		function invalidPropertiesToArray(phaseName : String) : Array;
		
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
