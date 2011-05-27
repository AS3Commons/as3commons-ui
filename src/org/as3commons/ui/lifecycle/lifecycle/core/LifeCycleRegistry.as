package org.as3commons.ui.lifecycle.lifecycle.core {

	import org.as3commons.collections.Map;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 26.05.2011
	 */
	public class LifeCycleRegistry {
		
		private var _lifeCycleManager : LifeCycle;
		private var _components : Map;

		public function LifeCycleRegistry() {
			_components = new Map();
		}
		
		public function set lifeCycleManager(lifeCycleManager : LifeCycle) : void {
			_lifeCycleManager = lifeCycleManager;
		}
		
		public function get lifeCycleManager() : LifeCycle {
			return _lifeCycleManager;
		}

		/*
		 * Component
		 */
		
		public function registerComponent(component : DisplayObject, adapter : LifeCycleAdapter) : void {
			_components.add(component, adapter);
		}

		public function unregisterComponent(component : DisplayObject) : void {
			_components.removeKey(component);
		}

		public function componentRegistered(component : DisplayObject) : Boolean {
			return _components.hasKey(component);
		}
		
		public function getAdapter(component : DisplayObject) : LifeCycleAdapter {
			return _components.itemFor(component);
		}
		
		public function clear() : void {
			_components.clear();
		}

	}
}
