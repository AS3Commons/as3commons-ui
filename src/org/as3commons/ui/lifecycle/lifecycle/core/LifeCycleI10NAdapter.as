package org.as3commons.ui.lifecycle.lifecycle.core {

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
				case LifeCycle.PHASE_CALCULATE_DEFAULTS:
					_lifeCycleAdapter.calculateDefaults_internal();
					break;
				case LifeCycle.PHASE_RENDER:
					_lifeCycleAdapter.render_internal();
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
				// nothing is possible from within the render phase
				if (i10n.currentPhaseName == LifeCycle.PHASE_RENDER) {
					throw new InvalidationNotAllowedHereError(
						InvalidationNotAllowedHereError.INVALIDATE_FROM_RENDER
					);
				}
				
				// invalidate is possible from all other phases as well as from any object
				if (phaseName == LifeCycle.PHASE_VALIDATE) return;

				// secondary phase not allowed from extern
				if (i10n.currentDisplayObject != _displayObject) {
					throw new InvalidationNotAllowedHereError(
						InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_CURRENT_OBJECT
					);
				}

				// invalidate defaults is not possible within the calculate defaults phase
				if (phaseName == LifeCycle.PHASE_CALCULATE_DEFAULTS && i10n.currentPhaseName == LifeCycle.PHASE_CALCULATE_DEFAULTS) {
					throw new InvalidationNotAllowedHereError(
						InvalidationNotAllowedHereError.INVALIDATE_DEFAULTS_FROM_CALCULATE_DEFAULTS
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
