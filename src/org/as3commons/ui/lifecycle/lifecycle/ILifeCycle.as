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
