package org.as3commons.ui.lifecycle.i10n {

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.utils.Sets;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.framework.uiservice.AbstractUIAdapter;
	import org.as3commons.ui.framework.uiservice.AbstractUIService;
	import org.as3commons.ui.framework.uiservice.errors.AdapterNotRegisteredError;

	import flash.display.DisplayObject;

	use namespace as3commons_ui;

	/**
	 * Invalidation adapter.
	 * 
	 * @author Jens Struwe 09.09.2011
	 */
	public class I10NAdapter extends AbstractUIAdapter implements II10NAdapter {
		
		private static const ALL_PROPERTIES : String = "all_properties";

		private var _nestLevel : int = -1;
		private var _invalidPhases : IMap;

		private var _currentPhaseName : String;
		private var _propertiesInvalidatedInCurrentPhase : ISet;
		
		/*
		 * II10NAdapter
		 */

		/**
		 * @inheritDoc
		 */
		public function get nestLevel() : int {
			return _nestLevel;
		}

		/**
		 * @inheritDoc
		 */
		public function invalidate(phaseName : String, property : String = null) : void {
			if (!_uiService) throw new AdapterNotRegisteredError();
			
			testInvalidationAllowed_internal(phaseName);
			
			if (!property) {
				_invalidPhases.removeKey(phaseName);
				_invalidPhases.add(phaseName, ALL_PROPERTIES);

			} else {
				if (_invalidPhases.itemFor(phaseName) != ALL_PROPERTIES) {
					var properties : ISet = _invalidPhases.itemFor(phaseName);
					if (!properties) {
						properties = new Set();
						_invalidPhases.add(phaseName, properties);
					}
					properties.add(property);
				}
			}
			
			if (phaseName == _currentPhaseName) {
				if (!property) {
					_propertiesInvalidatedInCurrentPhase.clear();
					property = ALL_PROPERTIES;
				}
				_propertiesInvalidatedInCurrentPhase.add(property);
			}

			I10N(_uiService).invalidate_internal(this, phaseName);
		}

		/**
		 * @inheritDoc
		 */
		public function isInvalid(phaseName : String = null, property : String = null) : Boolean {
			if (!_uiService) throw new AdapterNotRegisteredError();

			if (!phaseName) return _invalidPhases.size > 0;
			if (!property) return _invalidPhases.hasKey(phaseName);
			
			if (_invalidPhases.itemFor(phaseName) == ALL_PROPERTIES) return true;

			var properties : ISet = _invalidPhases.itemFor(phaseName);
			if (properties) {
				return properties.has(property);
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function validateNow() : void {
			if (!_uiService) throw new AdapterNotRegisteredError();

			I10N(_uiService).validateNowObject_internal(this);
		}

		/*
		 * as3commons_ui
		 */

		override as3commons_ui function setUp_internal(displayObject : DisplayObject, uiService : AbstractUIService) : void {
			super.setUp_internal(displayObject, uiService);
			
			_invalidPhases = new Map();
			_propertiesInvalidatedInCurrentPhase = new Set();
		}

		override as3commons_ui function cleanUp_internal() : void {
			super.cleanUp_internal();

			_invalidPhases = null;
			_propertiesInvalidatedInCurrentPhase = null;
			_nestLevel = -1;
		}

		as3commons_ui function validate_iternal(phaseName : String) : void {
			_currentPhaseName = phaseName;
			
			onValidate(phaseName);
			
			// component might be removed during a validation
			if (!_uiService) return;
			
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

		as3commons_ui function setNestLevel_internal(nestLevel : int) : void {
			_nestLevel = nestLevel;
		}

		as3commons_ui function testInvalidationAllowed_internal(phaseName : String) : void {
			onTestInvalidationAllowed(phaseName);
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

		/**
		 * The I10N service.
		 */
		protected function get i10n() : I10N {
			return _uiService as I10N;
		}

		/**
		 * Hook to enable subclasses to test if invalidating the given phase is allowed or not.
		 * 
		 * <p>If not, the subclass is supposed to throw an error.</p>.
		 * 
		 * @param phaseName Name of the phase for that the object should be invalidated.
		 */
		protected function onTestInvalidationAllowed(phaseName : String) : void {
			// template method to be overridden
		}

		/**
		 * Validation hook.
		 * 
		 * <p>The custom adapter is supposed to perform all validation operations here.</p>
		 * 
		 * @param phaseName The name phase the object should be validated for.
		 */
		protected function onValidate(phaseName : String) : void {
			// template method to be overridden
		}

		/**
		 * Notification hook if an object has been added to the stage.
		 */
		protected function onAddedToStage() : void {
			// template method to be overridden
		}

		/**
		 * Notification hook if an object has been removed from the stage.
		 */
		protected function onRemovedFromStage() : void {
			// template method to be overridden
		}

	}
}
