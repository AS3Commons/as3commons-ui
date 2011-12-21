package org.as3commons.ui.lifecycle.lifecycle.core {

	import flash.display.DisplayObject;

	import org.as3commons.ui.framework.uiservice.AbstractUIService;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.I10NAdapter;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;
	import org.as3commons.ui.lifecycle.lifecycle.errors.InvalidationNotAllowedHereError;
	
	use namespace as3commons_ui;

	/**
	 * Invalidation adapter incorporated by the LifeCycle adapter.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycleI10NAdapter extends I10NAdapter {
		
		private var _lifeCycleAdapter : LifeCycleAdapter;

		/**
		 * LifeCycleI10NAdapter constructor.
		 * 
		 * @param lifeCycleAdapter The LifeCycle adapter.
		 */
		public function LifeCycleI10NAdapter(lifeCycleAdapter : LifeCycleAdapter) {
			_lifeCycleAdapter = lifeCycleAdapter;
		}
		
		/*
		 * Public
		 */
		
		/**
		 * The life cycle adapter that internally hosts this i10n adapter instance.
		 */
		public function get lifeCycleAdapter() : LifeCycleAdapter {
			return _lifeCycleAdapter;
		}
		
		/*
		 * as3commons_ui
		 */

		override as3commons_ui function setUp_internal(displayObject : DisplayObject, uiService : AbstractUIService) : void {
			super.setUp_internal(displayObject, uiService);
			_lifeCycleAdapter.setUp_internal();
		}
		
		override as3commons_ui function cleanUp_internal() : void {
			super.cleanUp_internal();
			_lifeCycleAdapter.cleanUp_internal();
		}
		
		/*
		 * Protected
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function onValidate(phaseName : String) : void {
			switch (phaseName) {
				case LifeCycle.PHASE_VALIDATE:
					_lifeCycleAdapter.validate_internal();
					break;
				case LifeCycle.PHASE_MEASURE:
					_lifeCycleAdapter.measure_internal();
					break;
				case LifeCycle.PHASE_UPDATE:
					_lifeCycleAdapter.update_internal();
					break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onAddedToStage() : void {
			_lifeCycleAdapter.onAddedToStage_internal();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onRemovedFromStage() : void {
			_lifeCycleAdapter.onRemovedFromStage_internal();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onTestInvalidationAllowed(phaseName : String) : void {
			// validation running
			if (i10n.validationIsRunning) {

				// invalidate is possible from all other phases as well as from any object
				if (phaseName == LifeCycle.PHASE_VALIDATE) return;

				// secondary phase not allowed from extern
				if (i10n.currentDisplayObject != _displayObject) {
					throw new InvalidationNotAllowedHereError(
						InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_CURRENT_OBJECT
					);
				}
				
				// secondary phase is possible only within the validation phase
				if (i10n.currentPhaseName != LifeCycle.PHASE_VALIDATE) {
					throw new InvalidationNotAllowedHereError(
						InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_FIRST_PHASE
					);
				}

			// validation not running - only invalidate() is possible
			} else {
				// invalidate allowed from everywhere
				if (phaseName == LifeCycle.PHASE_VALIDATE) return;

				// other phases not allowed
				throw new InvalidationNotAllowedHereError(
					InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_OUTSIDE_OF_CYCLE
				);

			}
		}
	}
}
