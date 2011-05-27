package org.as3commons.ui.lifecycle.lifecycle {

	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 25.05.2011
	 */
	public class LifeCycleAdapter {
		
		private var _lifeCycle : LifeCycle;
		protected var _component : DisplayObject;

		private var _autoUpdates : IOrderedSet;
		protected var _updateKinds : ISet;
		protected var _invalidProperties : ISet;

		private var _initialized : Boolean;

		public function LifeCycleAdapter() {
			_updateKinds = new Set();
			_invalidProperties = new Set();
			_autoUpdates = new LinkedSet();
		}
		
		/*
		 * ILifeCycleAdaper
		 */

		public function get component() : DisplayObject {
			return _component;
		}
		
		public function invalidate(property : String = null) : void {
			if (!_initialized) return;
			i10n.invalidate(_component, property);
		}

		/**
		 * <p>If not initialized, the component will have called its init method immediately.</p>
		 */
		public function validateNow() : void {
			i10n.validateNow(_component);
		}
		
		public function autoUpdateBefore(child : DisplayObject) : void {
			_autoUpdates.add(child);
		}

		public function removeAutoUpdateBefore(child : DisplayObject) : void {
			_autoUpdates.remove(child);
		}

		public function scheduleUpdate(updateKind : String) : void {
			_updateKinds.add(updateKind);
		}
		
		public function cleanUp() : void {
		}

		/*
		 * Internal
		 */

		as3commons_ui function setUp_internal(lifeCycleManager : LifeCycle, component : DisplayObject) : void {
			_lifeCycle = lifeCycleManager;
			_component = component;
			
			if (_component.stage) {
				i10n.invalidate(_component);

			} else {
				_component.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			}
		}

		as3commons_ui function onWillValidate_internal() : void {
			if (_initialized) {
				var iterator : IIterator = _autoUpdates.iterator();
				while (iterator.hasNext()) {
					i10n.validateNow(iterator.next());
				}
			}
		}

		as3commons_ui function onValidate_internal(invalidProperties : ISet) : void {
			if (_initialized) {
				_invalidProperties = invalidProperties;
				prepareUpdate();
				_invalidProperties.clear();
				
				// execute update
				update();
				_updateKinds.clear();
				
			} else {
				init();
				_initialized = true;
			}
		}

		/*
		 * Protected - LifeCycle callbacks
		 */

		protected function init() : void {
		}

		/**
		 * Hook to enable subclasses to define update kinds according to the given property.
		 */
		protected function prepareUpdate() : void {
		}

		protected function update() : void {
		}

		/*
		 * Protected
		 */

		public function isInvalid(property : String) : Boolean {
			if (_invalidProperties.has(Invalidation.ALL_PROPERTIES)) return true;
			return _invalidProperties.has(property);
		}

		public function shouldUpdate(updateKind : String) : Boolean {
			return _updateKinds.has(updateKind);
		}

		/*
		 * Private
		 */

		private function addedToStageHandler(event : Event) : void {
			_component.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_component.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			i10n.invalidate(_component);
		}

		private function removedFromStageHandler(event : Event) : void {
			_component.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			_component.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function get i10n() : Invalidation {
			return _lifeCycle.as3commons_ui::getRenderManager_internal();
		}

	}
}
