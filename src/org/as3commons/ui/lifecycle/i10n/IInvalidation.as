/**
 * Copyright 2011 The original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.ui.lifecycle.i10n {

	import flash.display.DisplayObject;

	/**
	 * <code>Invalidation</code> definition.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public interface IInvalidation {
		
		/**
		 * Registers an <code>adapter</code> together with a <code>selector</code> in the <code>Invalidation</code> system.
		 * 
		 * @param selector The selector to decide for what items the adapter should be considered.
		 * @param adapter The adapter defining custom validation methods.
		 */
		function registerAdapter(selector : II10NSelector, adapter : II10NApapter) : void;
		
		/**
		 * Removes an <code>adapter</code> and its <code>selector</code> from the <code>Invalidation</code> system.
		 * 
		 * @param selector The selector with that the adapter had been registered.
		 * @param adapter The adapter to unregister.
		 */
		function unregisterAdapter(selector : II10NSelector, adapter : II10NApapter) : void;

		/**
		 * Starts an invalidation process for the specified component.
		 * 
		 * <p>The method will simply return if no adapter could be found for the given display object.</p>
		 * 
		 * <p>The optional <code>property</code> argument may be used to declare only parts
		 * of a component to be updated.</p>
		 * 
		 * <p>The system will collect all given invalidation properties and pass the final
		 * list to the <code>validate()</code> method of the adapter found for the display object.</p>
		 * 
		 * <p>If <code>property</code> is not set, the system assumes the wish of a full update. In that
		 * case the list of update properties given to the <code>validate()</code> method of the adapter
		 * will contain only the property <code>Invalidation.ALL_PROPERTIES</code>.</p>
		 * 
		 * @param displayObject The component to invalidate.
		 * @param property An optional invalidation property.
		 */
		function invalidate(displayObject : DisplayObject, property : String = null) : void;

		/**
		 * Performs an immediate update of the given component.
		 * 
		 * <p>The method will simply return if no adapter could be found for the given display object.</p>
		 * 
		 * @param displayObject The component to invalidate.
		 */
		function validateNow(displayObject : DisplayObject) : void;

		/**
		 * Removes immediately a component from the validation queue.
		 * 
		 * <p>If invoked, the adapter methods <code>willValidate()</code> and <code>validate()</code>
		 * won't be called at all.</p>
		 * 
		 * @param displayObject The component to remove from the validation queue.
		 */
		function stopValidation(displayObject : DisplayObject) : void;

		/**
		 * Clears the validation queue.
		 */
		function stopAllValidations() : void;

		/**
		 * Removes all listeners and references of the <code>Invalidation</code> instance.
		 * 
		 * <p>The <code>Invalidation</code> is then eligible for garbage collection.</p>
		 */
		function cleanUp() : void;

	}
}
