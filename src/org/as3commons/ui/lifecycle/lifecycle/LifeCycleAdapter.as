package org.as3commons.ui.lifecycle.lifecycle {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.lifecycle.core.LifeCycleI10NAdapter;

	import flash.display.DisplayObject;
	
	use namespace as3commons_ui;

	/**
	 * LifeCycle adapter.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycleAdapter implements ILifeCycleAdapter {
		
		private var _lifeCycle : LifeCycle;
		private var _lifeCycleI10NAdapter : LifeCycleI10NAdapter;
		private var _initialized : Boolean;
		
		/**
		 * LifeCycleAdapter constructor.
		 */
		public function LifeCycleAdapter() {
			_lifeCycleI10NAdapter = new LifeCycleI10NAdapter(this);
		}
		
		/*
		 * ILifeCycleAdapter
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get displayObject() : DisplayObject {
			return _lifeCycleI10NAdapter.displayObject;
		}

		/**
		 * @inheritDoc
		 */
		public function get nestLevel() : int {
			return _lifeCycleI10NAdapter.nestLevel;
		}

		/**
		 * @inheritDoc
		 */
		public function isInvalidForAnyPhase() : Boolean {
			return _lifeCycleI10NAdapter.isInvalid();
		}

		/**
		 * @inheritDoc
		 */
		public function invalidate(property : String = null) : void {
			_lifeCycleI10NAdapter.invalidate(LifeCycle.PHASE_VALIDATE, property);
		}

		/**
		 * @inheritDoc
		 */
		public function isInvalid(property : String = null) : Boolean {
			return _lifeCycleI10NAdapter.isInvalid(LifeCycle.PHASE_VALIDATE, property);
		}

		/**
		 * @inheritDoc
		 */
		public function invalidPropertiesToArray() : Array {
			return _lifeCycleI10NAdapter.invalidPropertiesToArray(LifeCycle.PHASE_VALIDATE);
		}

		/**
		 * @inheritDoc
		 */
		public function requestMeasurement() : void {
			_lifeCycleI10NAdapter.invalidate(LifeCycle.PHASE_MEASURE);
		}

		/**
		 * @inheritDoc
		 */
		public function shouldMeasure() : Boolean {
			return _lifeCycleI10NAdapter.isInvalid(LifeCycle.PHASE_MEASURE);
		}

		/**
		 * @inheritDoc
		 */
		public function scheduleUpdate(property : String = null) : void {
			_lifeCycleI10NAdapter.invalidate(LifeCycle.PHASE_UPDATE, property);
		}

		/**
		 * @inheritDoc
		 */
		public function shouldUpdate(property : String = null) : Boolean {
			return _lifeCycleI10NAdapter.isInvalid(LifeCycle.PHASE_UPDATE, property);
		}

		/**
		 * @inheritDoc
		 */
		public function scheduledUpdatesToArray() : Array {
			return _lifeCycleI10NAdapter.invalidPropertiesToArray(LifeCycle.PHASE_UPDATE);
		}

		/**
		 * @inheritDoc
		 */
		public function validateNow() : void {
			_lifeCycleI10NAdapter.validateNow();
		}
		
		/*
		 * as3commons_ui
		 */
		
		as3commons_ui function setLifeCycle_internal(lifeCycle : LifeCycle) : void {
			_lifeCycle = lifeCycle;
		}

		as3commons_ui function setUp_internal() : void {
			if (displayObject.stage) {
				onInit();
				_initialized = true;
			}
		}

		as3commons_ui function cleanUp_internal() : void {
			_lifeCycle = null;
		}

		as3commons_ui function get i10nAdapter_internal() : LifeCycleI10NAdapter {
			return _lifeCycleI10NAdapter;
		}
		
		as3commons_ui function validate_internal() : void {
			onValidate();
		}

		as3commons_ui function measure_internal() : void {
			onMeasure();
		}

		as3commons_ui function update_internal() : void {
			onUpdate();
		}

		as3commons_ui function onAddedToStage_internal() : void {
			onAddedToStage();
			
			if (!_initialized) {
				onInit();
				_initialized = true;
			}
		}

		as3commons_ui function onRemovedFromStage_internal() : void {
			onRemovedFromStage();
		}

		/*
		 * Protected
		 */

		/**
		 * The LifeCycle service.
		 */
		protected function get lifeCycle() : LifeCycle {
			return _lifeCycle;
		}

		/**
		 * Init hook.
		 * 
		 * <p>The custom adapter is supposed to perform all initialization operations such
		 * as calculating styles or creating children.</p>
		 * 
		 * <p>Called only once per component right after the component has been added
		 * to the stage.</p>
		 */
		protected function onInit() : void {
			// template method to be overridden
		}

		/**
		 * Validation hook (first phase).
		 * 
		 * <p>The custom adapter is supposed to invalidate the object for the secondary phases and
		 * to set depending properties.</p>
		 */
		protected function onValidate() : void {
			// template method to be overridden
		}

		/**
		 * Measurement hook (second phase).
		 * 
		 * <p>The custom adapter is supposed to perform a measuring on the component.</p>
		 */
		protected function onMeasure() : void {
			// template method to be overridden
		}

		/**
		 * Validation hook (third phase).
		 * 
		 * <p>The custom adapter is supposed to draw any graphics or to layout its children.</p>
		 */
		protected function onUpdate() : void {
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
