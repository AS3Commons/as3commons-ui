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

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;
	import org.as3commons.ui.lifecycle.lifecycle.core.I10NAdapter;
	import org.as3commons.ui.lifecycle.lifecycle.core.I10NSelector;
	import org.as3commons.ui.lifecycle.lifecycle.core.LifeCycleRegistry;

	import flash.display.DisplayObject;

	/**
	 * The <code>LifeCycle</code> system.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public class LifeCycle implements ILifeCycle {
		
		/**
		 * Internal <code>LifeCycle</code> registry reference.
		 */
		private var _registry : LifeCycleRegistry;

		/**
		 * Internal <code>Invalidation</code> reference.
		 */
		private var _i10n : Invalidation;

		/**
		 * <code>LifeCycle</code> constructor.
		 */
		public function LifeCycle() {
			_registry = new LifeCycleRegistry();

			_i10n = new Invalidation();
			_i10n.registerAdapter(new I10NSelector(_registry), new I10NAdapter(this));
		}
		
		/*
		 * ILifeCycle
		 */

		/**
		 * @inheritDoc
		 */
		public function registerComponent(component : DisplayObject, adapter : LifeCycleAdapter) : void {
			if (_registry.componentRegistered(component)) throw new Error("You cannot register a component twice.");
			if (adapter.component) throw new Error("You cannot reuse a LifeCycleAdapter instance.");
			
			_registry.registerComponent(component, adapter);
			adapter.as3commons_ui::setUp_internal(_i10n, component);
		}

		/**
		 * @inheritDoc
		 */
		public function unregisterComponent(component : DisplayObject) : void {
			_registry.unregisterComponent(component);
			_i10n.stopValidation(component);
		}

		/**
		 * @inheritDoc
		 */
		public function unregisterAllComponents() : void {
			_registry.clear();
			_i10n.stopAllValidations();
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			_registry.clear();
			_i10n.cleanUp();
		}

		/*
		 * Internal
		 */

		/**
		 * Framework internal method to return an adapter for the given component.
		 * 
		 * @param component The component to get the adapter for.
		 * @return The adapter.
		 */
		as3commons_ui function getAdapter_internal(displayObject : DisplayObject) : LifeCycleAdapter {
			return _registry.getAdapter(displayObject);
		}

	}
}
