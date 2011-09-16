package org.as3commons.ui.lifecycle.lifecycle {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.framework.uiservice.AbstractUIAdapter;
	import org.as3commons.ui.framework.uiservice.AbstractUIService;
	import org.as3commons.ui.lifecycle.i10n.I10N;
	import org.as3commons.ui.lifecycle.lifecycle.core.LifeCycleI10NAdapter;

	import flash.display.DisplayObject;
	
	use namespace as3commons_ui;

	/**
	 * LifeCycle service.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycle extends AbstractUIService implements ILifeCycle {
		
		/**
		 * Constant defining the name of the first validation phase (validation).
		 */
		public static const PHASE_VALIDATE : String = "validate";

		/**
		 * Constant defining the name of the second validation phase (calculate defaults).
		 */
		public static const PHASE_CALCULATE_DEFAULTS : String = "calculate_defaults";

		/**
		 * Constant defining the name of the third validation phase (render).
		 */
		public static const PHASE_RENDER : String = "render";
		
		private var _i10n : I10N;

		/**
		 * LifeCycle constructor.
		 */
		public function LifeCycle() {
			_i10n = new I10N;
			_i10n.addPhase(PHASE_VALIDATE, I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase(PHASE_CALCULATE_DEFAULTS, I10N.PHASE_ORDER_BOTTOM_UP);
			_i10n.addPhase(PHASE_RENDER, I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_NONE);
			_i10n.start();
			
			start_protected();
		}
		
		/*
		 * LifeCycle
		 */
		
		/**
		 * @inheritDoc
		 */
		public function registerDisplayObject(displayObject : DisplayObject, adapter : LifeCycleAdapter) : void {
			registerDisplayObject_protected(displayObject, adapter);
		}

		/**
		 * @inheritDoc
		 */
		public function unregisterDisplayObject(displayObject : DisplayObject) : void {
			unregisterDisplayObject_protected(displayObject);
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
			cleanUp_protected();
		}

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function onRegister(adapter : AbstractUIAdapter) : void {
			var i10nAdapter : LifeCycleI10NAdapter = LifeCycleAdapter(adapter).i10nAdapter_internal;
			_i10n.registerDisplayObject(adapter.displayObject, i10nAdapter);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onUnregister(adapter : AbstractUIAdapter, displayObject : DisplayObject) : void {
			_i10n.unregisterDisplayObject(displayObject);
		}

	}
}
