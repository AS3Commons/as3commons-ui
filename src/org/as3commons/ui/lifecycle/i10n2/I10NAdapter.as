package org.as3commons.ui.lifecycle.i10n2 {

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.utils.Sets;
	import org.as3commons.ui.framework.core.as3commons_ui;

	import flash.display.DisplayObject;

	use namespace as3commons_ui;

	/**
	 * @author Jens Struwe 09.09.2011
	 */
	public class I10NAdapter implements II10NAdapter {
		
		public static const ALL_PROPERTIES : String = "all_properties";

		private var _displayObject : DisplayObject;
		private var _i10n : I10N;
		private var _nestLevel : int = -1;
		private var _invalidPhases : IMap;

		private var _currentPhaseName : String;
		private var _propertiesInvalidatedInCurrentPhase : ISet;
		
		/*
		 * II10NAdapter
		 */

		public function get displayObject() : DisplayObject {
			return _displayObject;
		}

		public function get nestLevel() : int {
			return _nestLevel;
		}

		public function invalidate(phaseName : String, property : String = null) : void {
			if (!_i10n) throw new Error("I10NAdapter: You can't invalidate an unregistered object.");
			
			if (!property) {
				_invalidPhases.removeKey(phaseName);
				_invalidPhases.add(phaseName, ALL_PROPERTIES);

			} else {
				var properties : ISet = _invalidPhases.itemFor(phaseName);
				if (!properties) {
					properties = new Set();
					_invalidPhases.add(phaseName, properties);
				}
				
				properties.add(property);
			}
			
			if (phaseName == _currentPhaseName) {
				if (!property) {
					_propertiesInvalidatedInCurrentPhase.clear();
					property = ALL_PROPERTIES;
				}
				_propertiesInvalidatedInCurrentPhase.add(property);
			}

			_i10n.invalidate_internal(this, phaseName);
		}

		public function isInvalid(phaseName : String = null, property : String = null) : Boolean {
			if (!phaseName) return _invalidPhases.size > 0;
			if (!property) return _invalidPhases.hasKey(phaseName);
			
			if (_invalidPhases.itemFor(phaseName) == ALL_PROPERTIES) return true;

			var properties : ISet = _invalidPhases.itemFor(phaseName);
			if (properties) {
				return properties.has(property);
			}
			return false;
		}

		public function validateNow() : void {
			if (!_i10n) throw new Error("I10NAdapter: You can't validate an unregistered object.");

			_i10n.validateNowObject_internal(this);
		}

		/*
		 * Internal
		 */

		as3commons_ui function setUp_internal(displayObject : DisplayObject, i10n : I10N) : void {
			_displayObject = displayObject;
			_i10n = i10n;
			_invalidPhases = new Map();
			_propertiesInvalidatedInCurrentPhase = new Set();
		}

		as3commons_ui function cleanUp_internal() : void {
			_displayObject = null;
			_i10n = null; // not possible to invalidate any longer
			_invalidPhases = null;
			_propertiesInvalidatedInCurrentPhase = null;
			_nestLevel = -1;
		}

		as3commons_ui function validate_iternal(phaseName : String) : void {
			_currentPhaseName = phaseName;
			
			validate(phaseName);
			
			// component might be removed during a validation
			if (!_i10n) return;
			
			_currentPhaseName = null;
			
			_invalidPhases.removeKey(phaseName);

			if (_propertiesInvalidatedInCurrentPhase.size) {
				if (_propertiesInvalidatedInCurrentPhase.has(ALL_PROPERTIES)) {
					_invalidPhases.add(phaseName, ALL_PROPERTIES);

				} else {
					_invalidPhases.add(phaseName, Sets.clone(_propertiesInvalidatedInCurrentPhase));
				}
				_propertiesInvalidatedInCurrentPhase.clear();
			}
		}

		as3commons_ui function set nestLevel_internal(nestLevel : int) : void {
			_nestLevel = nestLevel;
		}

		as3commons_ui function notifyAdded_internal() : void {
			onAddedToStage();
		}

		as3commons_ui function notifyRemoved_internal() : void {
			onRemovedFromStage();
		}

		/*
		 * Protected
		 */

		protected function validate(phaseName : String) : void {
			// template method to be overridden
		}

		protected function onAddedToStage() : void {
			// template method to be overridden
		}

		protected function onRemovedFromStage() : void {
			// template method to be overridden
		}

	}
}
