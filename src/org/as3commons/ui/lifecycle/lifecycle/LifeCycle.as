package org.as3commons.ui.lifecycle.lifecycle {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.I10N;

	import flash.display.DisplayObject;
	
	use namespace as3commons_ui;

	/**
	 * LifeCycle service.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycle implements ILifeCycle {
		
		/**
		 * Constant defining the name of the first validation phase (validation).
		 */
		public static const PHASE_VALIDATE : String = "validate";

		/**
		 * Constant defining the name of the second validation phase (measurement).
		 */
		public static const PHASE_MEASURE : String = "measure";

		/**
		 * Constant defining the name of the third validation phase (update).
		 */
		public static const PHASE_UPDATE : String = "update";

		private var _i10n : I10N;

		/**
		 * LifeCycle constructor.
		 */
		public function LifeCycle() {
			_i10n = new I10N;

			_i10n.addPhase(PHASE_VALIDATE, I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase(PHASE_MEASURE, I10N.PHASE_ORDER_BOTTOM_UP);
			_i10n.addPhase(PHASE_UPDATE, I10N.PHASE_ORDER_TOP_DOWN);

			_i10n.start();
		}
		
		/*
		 * LifeCycle
		 */
		
		/**
		 * @inheritDoc
		 */
		public function registerDisplayObject(displayObject : DisplayObject, adapter : LifeCycleAdapter) : void {
			_i10n.registerDisplayObject(displayObject, adapter.i10nAdapter_internal);
			
			adapter.setLifeCycle_internal(this);
		}

		/**
		 * @inheritDoc
		 */
		public function unregisterDisplayObject(displayObject : DisplayObject) : void {
			_i10n.unregisterDisplayObject(displayObject);
		}

		/**
		 * @inheritDoc
		 */
		public function validateNow() : void {
			_i10n.validateNow();
		}

		/**
		 * @inheritDoc
		 */
		public function get validationIsRunning() : Boolean {
			return _i10n.validationIsRunning;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPhaseName() : String {
			return _i10n.currentPhaseName;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentDisplayObject() : DisplayObject {
			return _i10n.currentDisplayObject;
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			_i10n.cleanUp();
		}

	}
}
