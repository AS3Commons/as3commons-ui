package org.as3commons.ui.lifecycle.lifecycle {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;
	import org.as3commons.ui.lifecycle.lifecycle.core.I10NAdapter;
	import org.as3commons.ui.lifecycle.lifecycle.core.I10NSelector;
	import org.as3commons.ui.lifecycle.lifecycle.core.LifeCycleRegistry;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class LifeCycle {
		
		private var _registry : LifeCycleRegistry;
		private var _renderManager : Invalidation;

		public function LifeCycle() {
			_registry = new LifeCycleRegistry();
			_registry.lifeCycleManager = this;

			_renderManager = new Invalidation();
			_renderManager.register(new I10NSelector(_registry), new I10NAdapter(this));
		}

		/*
		 * Registry
		 */

		public function registerComponent(component : DisplayObject, adapter : LifeCycleAdapter) : void {
			if (_registry.componentRegistered(component)) throw new Error("You cannot register a component twice.");
			if (adapter.component) throw new Error("You cannot reuse a LifeCycleAdapter instance.");
			
			_registry.registerComponent(component, adapter);
			adapter.as3commons_ui::setUp_internal(this, component);
		}

		public function unregisterComponent(component : DisplayObject) : void {
			_registry.unregisterComponent(component);
		}

		public function clear() : void {
			_registry.clear();
			_renderManager.clear();
		}

		public function cleanUp() : void {
			_registry.clear();
			_renderManager.cleanUp();
		}

		/*
		 * Internal
		 */

		as3commons_ui function getAdapter_internal(displayObject : DisplayObject) : LifeCycleAdapter {
			return _registry.getAdapter(displayObject);
		}

		as3commons_ui function getRenderManager_internal() : Invalidation {
			return _renderManager;
		}

	}
}
