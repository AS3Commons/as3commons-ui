package org.as3commons.ui.lifecycle.lifecycle.core {

	import org.as3commons.collections.Map;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	import flash.display.DisplayObject;

	/**
	 * Registry of <code>LifeCycle</code> components.
	 * 
	 * @author Jens Struwe 26.05.2011
	 */
	public class LifeCycleRegistry {
		
		/**
		 * Map of components to <code>LifeCycle</code> adapters.
		 */
		private var _components : Map;

		/**
		 * <code>LifeCycleRegistry</code> constructor.
		 */
		public function LifeCycleRegistry() {
			_components = new Map();
		}
		
		/**
		 * Registers a component.
		 * 
		 * @param component The component to register.
		 * @param adapter The <code>LifeCycle</code> component adapter.
		 */
		public function registerComponent(component : DisplayObject, adapter : LifeCycleAdapter) : void {
			_components.add(component, adapter);
		}

		/**
		 * Unregisters a component.
		 * 
		 * @param component The component to unregister.
		 */
		public function unregisterComponent(component : DisplayObject) : void {
			_components.removeKey(component);
		}

		/**
		 * Returns <code>true</code> if the given component has already been registered.
		 * 
		 * @param component The component to test.
		 * @return <code>true</code> if registered.
		 */
		public function componentRegistered(component : DisplayObject) : Boolean {
			return _components.hasKey(component);
		}
		
		/**
		 * Returns the adpater for the given component.
		 * 
		 * @param component The component to get the adapter for.
		 * @return The adapter.
		 */
		public function getAdapter(component : DisplayObject) : LifeCycleAdapter {
			return _components.itemFor(component);
		}
		
		/**
		 * Unregisters all components.
		 */
		public function clear() : void {
			_components.clear();
		}

	}
}
