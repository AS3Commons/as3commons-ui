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
package org.as3commons.ui.lifecycle.lifecycle {

	import flash.display.DisplayObject;

	/**
	 * <code>LifeCycle</code> definition.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public interface ILifeCycle {
		
		/**
		 * Registers a display object with the <code>LifeCycle</code> system.
		 * 
		 * @param component The component to be manged by <code>LifeCycle</code>.
		 * @param adapter The <code>LifeCycle</code> component adapter instance.
		 */
		function registerComponent(component : DisplayObject, adapter : LifeCycleAdapter) : void;

		/**
		 * Removes a display object from the <code>LifeCycle</code> registration.
		 * 
		 * @param component The component to remove from the <code>LifeCycle</code> registry.
		 */
		function unregisterComponent(component : DisplayObject) : void;

		/**
		 * Removes all display objects from the <code>LifeCycle</code> registration.
		 */
		function unregisterAllComponents() : void;
		
		/**
		 * Removes all listeners and references of the <code>LifeCycle</code> instance.
		 * 
		 * <p>The <code>LifeCycle</code> is then eligible for garbage collection.</p>
		 */
		function cleanUp() : void;
		
	}
}
