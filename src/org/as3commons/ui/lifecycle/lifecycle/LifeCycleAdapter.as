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

	import flash.events.Event;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;

	import flash.display.DisplayObject;

	/**
	 * <code>LifeCycle</code> basic component adapter.
	 * 
	 * @author Jens Struwe 25.05.2011
	 */
	public class LifeCycleAdapter implements ILifeCycleAdapter {
		
		/**
		 * Callback for the init event.
		 */
		protected var _initHandler : Function;

		/**
		 * Callback for the prepare update event.
		 */
		protected var _drawHandler : Function;

		/**
		 * Callback for the prepare update event.
		 */
		protected var _initCompleteHandler : Function;

		/**
		 * Callback for the prepare update event.
		 */
		protected var _prepareUpdateHandler : Function;

		/**
		 * Callback for the update event.
		 */
		protected var _updateHandler : Function;

		/**
		 * Callback for the clean up event.
		 */
		protected var _cleanUpHandler : Function;

		/**
		 * Internal Invalidation instance.
		 */
		protected var _i10n : Invalidation;

		/**
		 * Display object to manage by this adapter.
		 */
		protected var _component : DisplayObject;

		/**
		 * List of components to be updated beforehand.
		 */
		protected var _autoUpdates : IOrderedSet;

		/**
		 * List of invalid properties.
		 */
		protected var _invalidProperties : ISet;

		/**
		 * List of update kinds.
		 */
		protected var _updateKinds : ISet;

		/**
		 * Flag to decide if init or update is to perform.
		 */
		protected var _initialized : Boolean;

		/**
		 * <code>LifeCycleAdapter</code> constructor.
		 */
		public function LifeCycleAdapter() {
		}
		
		/*
		 * ILifeCycleAdaper
		 */

		/**
		 * @inheritDoc
		 */
		public function get component() : DisplayObject {
			return _component;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get initialized() : Boolean {
			return _initialized;
		}

		/**
		 * @inheritDoc
		 */
		public function autoUpdateBefore(child : DisplayObject) : void {
			if (child == _component) return;
			
			if (!_autoUpdates) _autoUpdates = new LinkedSet();
			_autoUpdates.add(child);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAutoUpdateBefore(child : DisplayObject) : void {
			_autoUpdates.remove(child);
			if (!_autoUpdates.size) _autoUpdates = null;
		}

		/**
		 * @inheritDoc
		 */
		public function invalidate(property : String = null) : void {
			if (!_initialized) return;
			
			_i10n.invalidate(_component, property);
		}

		/**
		 * @inheritDoc
		 */
		public function validateNow() : void {
			_i10n.validateNow(_component);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isInvalid(property : String) : Boolean {
			if (!_invalidProperties) return false;
			if (_invalidProperties.has(Invalidation.ALL_PROPERTIES)) return true;
			return _invalidProperties.has(property);
		}

		/**
		 * @inheritDoc
		 */
		public function scheduleUpdate(updateKind : String) : void {
			if (!_updateKinds) _updateKinds = new Set();
			_updateKinds.add(updateKind);
		}
		
		/**
		 * @inheritDoc
		 */
		public function shouldUpdate(updateKind : String) : Boolean {
			if (!_updateKinds) return false;
			return _updateKinds.has(updateKind);
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			_component.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_i10n.stopValidation(_component);

			if (_cleanUpHandler != null) {
				_cleanUpHandler(this);
			} else {
				onCleanUp();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function set initHandler(initHandler : Function) : void {
			_initHandler = initHandler;
		}

		/**
		 * @inheritDoc
		 */
		public function set drawHandler(drawHandler : Function) : void {
			_drawHandler = drawHandler;
		}

		/**
		 * @inheritDoc
		 */
		public function get initCompleteHandler() : Function {
			return _initCompleteHandler;
		}

		/**
		 * @inheritDoc
		 */
		public function set prepareUpdateHandler(prepareUpdateHandler : Function) : void {
			_prepareUpdateHandler = prepareUpdateHandler;
		}

		/**
		 * @inheritDoc
		 */
		public function set updateHandler(updateHandler : Function) : void {
			_updateHandler = updateHandler;
		}

		/**
		 * @inheritDoc
		 */
		public function set cleanUpHandler(cleanUpHandler : Function) : void {
			_cleanUpHandler = cleanUpHandler;
		}

		/*
		 * Internal
		 */

		/**
		 * Framework internal method to set up a component.
		 * 
		 * @param i10n <code>Invalidation</code> reference.
		 * @return component The component using this adapter.
		 */
		as3commons_ui function setUp_internal(i10n : Invalidation, component : DisplayObject) : void {
			_i10n = i10n;
			_component = component;
			
			if (_component.stage) {
				initComponent();
			} else {
				_component.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			}
		}

		/**
		 * Framework internal callback for the <code>Invalidation</code> will validate event.
		 */
		as3commons_ui function willValidate_internal() : void {
			if (!_initialized) return;
			
			if (!_autoUpdates) return;
			var iterator : IIterator = _autoUpdates.iterator();
			while (iterator.hasNext()) {
				_i10n.validateNow(iterator.next());
			}
		}

		/**
		 * Framework internal callback for the <code>Invalidation</code> validate event.
		 */
		as3commons_ui function validate_internal(invalidProperties : ISet) : void {
			if (_initialized) {
				// prepare update
				_invalidProperties = invalidProperties;
				if (_prepareUpdateHandler != null) {
					_prepareUpdateHandler(this);
				} else {
					onPrepareUpdate();
				}
				
				// execute update
				if (_updateHandler != null) {
					_updateHandler(this);
				} else {
					onUpdate();
				}

				// cleanup
				_updateKinds = null;
				_invalidProperties = null;
				
			} else {
				if (_drawHandler != null) {
					_drawHandler(this);
				} else {
					onDraw();
				}
				_initialized = true;
				onInitComplete();
			}
		}

		/*
		 * Protected
		 */

		/**
		 * Default init hook.
		 */
		protected function onInit() : void {
		}

		/**
		 * Default draw hook.
		 */
		protected function onDraw() : void {
		}

		/**
		 * Default init complete hook.
		 */
		protected function onInitComplete() : void {
		}

		/**
		 * Default pre update hook.
		 */
		protected function onPrepareUpdate() : void {
		}

		/**
		 * Default update hook.
		 */
		protected function onUpdate() : void {
		}

		/**
		 * Default clean up hook.
		 */
		protected function onCleanUp() : void {
		}
		
		/*
		 * Private
		 */

		/**
		 * Handler for the component's <code>Event.ADDED_TO_STAGE</code> event.
		 */
		private function addedToStageHandler(event : Event) : void {
			_component.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			initComponent();
		}

		/**
		 * Calls the init callback.
		 */
		private function initComponent() : void {
			_i10n.invalidate(_component);

			if (_initHandler != null) {
				_initHandler(this);
			} else {
				onInit();
			}

		}

	}
}
