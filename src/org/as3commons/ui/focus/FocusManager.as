package org.as3commons.ui.focus {

	import org.as3commons.collections.Map;
	import org.as3commons.ui.framework.core.as3commons_ui;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * @author Jens Struwe 14.06.2011
	 */
	public class FocusManager {

		private var _stage : Stage;
		private var _components : Map;
		private var _defaultFirstTabFocus : InteractiveObject;
		private var _defaultLastTabFocus : InteractiveObject;

		public function FocusManager(stage : Stage) {
			_stage = stage;
			_components = new Map();

			_stage.stageFocusRect = false;
			_stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE , mouseFocusChanged, false);
			_stage.addEventListener(FocusEvent.FOCUS_IN, focusIn, true);
			_stage.addEventListener(FocusEvent.FOCUS_OUT, focusOut, true);

			_stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE , keyFocusChanged);

			_stage.addEventListener(Event.ACTIVATE, activate);
		}

		private function activate(event : Event) : void {
			trace ();
			trace ("activate", _stage.focus);

			/*
			 * Set focus to the stage if a default object is specified
			 * in order to have this object focused with the first hit to TAB.
			 * 
			 * If not set to stage, in IE you would lose the focus again if:
			 * - focus a component
			 * - click the stage
			 * - focus an element outside of the movie
			 * - click the stage (will activate)
			 * - hit TAB (will move the focus out)
			 */
			if (keepFocusInMovie() && _stage.focus == null) {
				_stage.focus = _stage;
			}
			
		}

		private function keyFocusChanged(event : FocusEvent) : void {
			
			trace ("keyFocusChanged", event.target, event.relatedObject, _stage.focus);
			
			/*
			 * If a default focus object has been specfied the following rules apply:
			 * 
			 * 1. If no focus is set yet (or is set to the stage) and this listener
			 * is triggered than we can be sure that the default object should be focused.
			 * The stage is focused in any case the focus has been tried to set to null by this class.
			 * The focus is therefore set to null only initially.
			 * 
			 * If you enter a movie in IE using the TAB key, the flash player will fire
			 * a key focus change event immediately and the default object will be focused.
			 * If you do the same in Firefox, you need to hit TAB again to focus the default
			 * object.
			 * 
			 * 2. If the next object to focus (relatedObject) is null then we set the stage's
			 * focus to the stage itself in order to keep the focus in the movie with the
			 * next hit to TAB.
			 */
			if (keepFocusInMovie()) {
				// nothing was focused
				if (!_stage.focus || _stage.focus == _stage) {
					
					if (event.shiftKey && _defaultLastTabFocus) _stage.focus = _defaultLastTabFocus;
					else _stage.focus = _defaultFirstTabFocus;
					
					event.preventDefault();
					return;
				}
			
				// trial to focus null
				if (!event.relatedObject) {
					_stage.focus = _stage;
					event.preventDefault();
					return;
				}
			}
			
		}

		public function registerComponent(component : InteractiveObject, adapter : FocusAdapter) : void {
			if (_components.hasKey(component)) return;
			if (adapter.component) throw new Error ("You cannot reuse a focus adapter");
			_components.add(component, adapter);

			adapter.as3commons_ui::setUp_internal(this, component);
		}

		public function unregisterComponent(component : InteractiveObject) : void {
			var adapter : FocusAdapter = _components.removeKey(component);
			if (!adapter) return;
			adapter.cleanUp();
		}

		public function setFocus(component : InteractiveObject) : void {
			_stage.focus = component;
		}
		
		public function clearFocus() : void {
			_stage.focus = null;
		}
		
		public function set defaultFirstTabFocus(defaultTabFocus : InteractiveObject) : void {
			_defaultFirstTabFocus = defaultTabFocus;
		}
		
		public function set defaultLastTabFocus(defaultLastTabFocus : InteractiveObject) : void {
			_defaultLastTabFocus = defaultLastTabFocus;
		}

		public function cleanUp() : void {
			_stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE , mouseFocusChanged, false);
			_stage.removeEventListener(FocusEvent.FOCUS_IN, focusIn, true);
			_stage.removeEventListener(FocusEvent.FOCUS_OUT, focusOut, true);
			_components.clear();
		}
		
		/*
		 * Private
		 */
		
		/**
		 * <p>Not fired if focus is set to objects not on the stage.</p> 
		 */
		private function focusIn(event : FocusEvent) : void {
			trace ("focus in", event.target, event.relatedObject);
			var adapter : FocusAdapter = _components.itemFor(event.target);
			if (adapter) {
				adapter.as3commons_ui::focusIn_internal();
			}
		}

		/**
		 * <p>Not fired if the focused object is being removed from the stage. In order
		 * to dispatch a focus out notification a focus adapter listens to the removed
		 * from stage event and explicitely clears the stage's focus.</p> 
		 */
		private function focusOut(event : FocusEvent) : void {
			trace ("focus out", event.target, event.relatedObject);
			var adapter : FocusAdapter = _components.itemFor(event.target);
			if (adapter) {
				adapter.as3commons_ui::focusOut_internal();
			}
			
			/*
			 * Set the stage focus back to stage in the case we want to select
			 * the default object with the next TAB key. Otherwise we will leave
			 * the movie in certain browsers when the focus is set to null.
			 */
			if (!event.relatedObject && keepFocusInMovie()) {
				_stage.focus = _stage;
			}
		}

		private function mouseFocusChanged(event : FocusEvent) : void {
			trace ("mouseFocusChanged", event.target, event.relatedObject, _stage.focus);
			
			// always select a text input
			if (isTextInput(event.relatedObject)) {
				setFocus(event.relatedObject);
				return;
			}

			// test whether to focus a registered component or a tab enabled component
			var component : DisplayObject = event.relatedObject;
			while (component) {	
				if (component is InteractiveObject && InteractiveObject(component).tabEnabled) {
					setFocus(component as InteractiveObject);
					return;
				}
				component = component.parent;
			}
			
			/*
			 * If no component could be found we set the focus to the stage
			 * in the case a default focus object has been specified.
			 * 
			 * If we do so, the next hit to TAB will focus the default first (or last)
			 * object. Otherwise the next TAB would leave the movie in IE with
			 * seamlesstabbing = true.
			 */
			if (keepFocusInMovie()) {
				event.preventDefault();
				_stage.focus = _stage;
			}
		}
		
		private function keepFocusInMovie() : Boolean {
			return _defaultFirstTabFocus != null || _defaultLastTabFocus != null;
		}

		private function isTextInput(object : InteractiveObject) : Boolean {
			return object is TextField && TextField(object).type == TextFieldType.INPUT;
		}

	}
}
