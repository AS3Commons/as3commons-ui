package org.as3commons.ui.focus {

	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.KeyboardEvent;
	import org.as3commons.ui.framework.core.as3commons_ui;

	import flash.display.InteractiveObject;

	/**
	 * @author Jens Struwe 14.06.2011
	 */
	public class FocusAdapter {
		
		private var _focusManager : FocusManager;
		private var _component : InteractiveObject;
		private var _autoFocusChild : InteractiveObject;
		private var _nextFocus : InteractiveObject;
		private var _hasFocus : Boolean;
		private var _enabled : Boolean = true;
		
		private var _focusInCallback : Function;
		private var _focusOutCallback : Function;
		private var _keyDownCallback : Function;
		private var _keyUpCallback : Function;

		public function get component() : InteractiveObject {
			return _component;
		}

		/**
		 * Flag, indicates if the associated component is allowed to receive focus.
		 * 
		 * <p>If set to <code>false</code>, the component won't receive focus at all
		 * regardless if it is clicked by mouse, triggered by the TAB key or even
		 * set to gain focus programmatically.</p>
		 */
		public function set enabled(enabled : Boolean) : void {
			_enabled = enabled;
		}

		/**
		 * @private
		 */
		public function get enabled() : Boolean {
			return _enabled;
		}

		public function set autoFocusChild(autoFocusedChild : InteractiveObject) : void {
			_autoFocusChild = autoFocusedChild;
		}

		public function get autoFocusChild() : InteractiveObject {
			return _autoFocusChild;
		}

		public function set nextFocus(nextFocus : InteractiveObject) : void {
			_nextFocus = nextFocus;
		}

		public function get nextFocus() : InteractiveObject {
			return _nextFocus;
		}

		public function setFocus() : void {
			_focusManager.setFocus(_component);
		}
		
		public function get hasFocus() : Boolean {
			return _hasFocus;
		}
		
		public function clearFocus() : void {
			if (_hasFocus) _focusManager.clearFocus(); // will later call focusOut_internal()
		}
		
		public function cleanUp() : void {
			removeInFocusListeners();
			_focusManager = null;
			_component = null;
			_autoFocusChild = null;
		}
		
		public function set focusInCallback(focusInCallback : Function) : void {
			_focusInCallback = focusInCallback;
		}

		public function set focusOutCallback(focusOutCallback : Function) : void {
			_focusOutCallback = focusOutCallback;
		}

		public function set keyDownCallback(keyDownCallback : Function) : void {
			_keyDownCallback = keyDownCallback;
		}

		public function set keyUpCallback(keyUpCallback : Function) : void {
			_keyUpCallback = keyUpCallback;
		}

		/*
		 * Internal
		 */

		as3commons_ui function setUp_internal(focusManager : FocusManager, component : InteractiveObject) : void {
			_focusManager = focusManager;
			_component = component;
			_component.tabEnabled = true;
		}
		
		/**
		 * <p>If the child to focus is not on the stage, we do not set the focus to it
		 * in order to be able to receive valid focus change events. Flash does not dispatch
		 * the focus change event if the current stage focus is an object not on the display list.</p>
		 */
		as3commons_ui function focusIn_internal() : void {
			if (_autoFocusChild) {
				if (!_autoFocusChild.stage) return;	
				_focusManager.setFocus(_autoFocusChild);

			} else {
				addInFocusListeners();
				if (_focusInCallback != null) {
					_focusInCallback(this);
				} else {
					onFocusIn();
				}
			}
		}

		as3commons_ui function focusOut_internal() : void {
			removeInFocusListeners();
			if (_focusOutCallback != null) {
				_focusOutCallback(this);
			} else {
				onFocusOut();
			}
		}
		
		/*
		 * Protected
		 */

		protected function onFocusIn() : void {
			// hook
		}

		protected function onFocusOut() : void {
			// hook
		}

		protected function onKeyUp(event : KeyboardEvent) : void {
			// hook
		}

		protected function onKeyDown(event : KeyboardEvent) : void {
			// hook
		}

		/*
		 * Private
		 */
		
		/**
		 * By default, Flash does not notify components about a lost focus
		 * when they are removed from the stage. The focus manager instead
		 * only wants to manage components included in the display list.
		 */
		private function removedFromStageHandler(event : Event) : void {
			removeInFocusListeners();
			_focusManager.clearFocus();
		}

		private function keyUpHandler(event : KeyboardEvent) : void {
			if (event.eventPhase != EventPhase.AT_TARGET) return;
			if (_keyDownCallback != null) {
				_keyDownCallback(this, event);
			} else {
				onKeyUp(event);
			}
		}

		private function keyDownHandler(event : KeyboardEvent) : void {
			if (event.eventPhase != EventPhase.AT_TARGET) return;
			if (_keyUpCallback != null) {
				_keyUpCallback(this, event);
			} else {
				onKeyDown(event);
			}
		}
		
		private function addInFocusListeners() : void {
			_component.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			_component.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_component.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			_hasFocus = true;
		}
		
		private function removeInFocusListeners() : void {
			_component.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			_component.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_component.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			_hasFocus = false;
		}

	}

}
