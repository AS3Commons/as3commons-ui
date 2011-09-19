package org.as3commons.ui.lifecycle.i10n {

	import org.as3commons.collections.StringMap;
	import org.as3commons.collections.framework.IMap;
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
		private var _propertiesInvalidatedInCurrentPhase : Object;
		
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
					var properties : Object = _invalidPhases.itemFor(phaseName);
					if (!properties) {
						properties = new Object();
						_invalidPhases.add(phaseName, properties);
					}
					properties[property] = true;
				}
			}
			
			if (phaseName == _currentPhaseName) {
				if (!_propertiesInvalidatedInCurrentPhase || !property) {
					_propertiesInvalidatedInCurrentPhase = new Object();
				}
				if (!property) {
					property = ALL_PROPERTIES;
				}
				_propertiesInvalidatedInCurrentPhase[property] = true;
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

			var properties : Object = _invalidPhases.itemFor(phaseName);
			if (properties) {
				return properties.hasOwnProperty(property);
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
			
			_invalidPhases = new StringMap();
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
			
			// component might be removed from the service during onValidate
			if (!_uiService) return;
			
			_currentPhaseName = null;
			
			_invalidPhases.removeKey(phaseName);

			// add properties being invalidated during onValidate
			if (_propertiesInvalidatedInCurrentPhase) {
				if (_propertiesInvalidatedInCurrentPhase.hasOwnProperty(ALL_PROPERTIES)) {
					_invalidPhases.add(phaseName, ALL_PROPERTIES);

				} else {
					_invalidPhases.add(phaseName, _propertiesInvalidatedInCurrentPhase);
				}
				_propertiesInvalidatedInCurrentPhase = null;
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
