package org.as3commons.ui.lifecycle.lifecycle {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.framework.uiservice.AbstractUIAdapter;
	import org.as3commons.ui.framework.uiservice.AbstractUIService;
	import org.as3commons.ui.lifecycle.lifecycle.core.LifeCycleI10NAdapter;

	import flash.display.DisplayObject;
	
	use namespace as3commons_ui;

	/**
	 * LifeCycle adapter.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycleAdapter extends AbstractUIAdapter implements ILifeCycleAdapter {
		
		private var _i10nAdapter : LifeCycleI10NAdapter;
		private var _initialized : Boolean;
		
		/**
		 * LifeCycleAdapter constructor.
		 */
		public function LifeCycleAdapter() {
			_i10nAdapter = new LifeCycleI10NAdapter(this);
		}
		
		/*
		 * ILifeCycleAdapter
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get nestLevel() : int {
			return _i10nAdapter.nestLevel;
		}

		/**
		 * @inheritDoc
		 */
		public function invalidate(property : String = null) : void {
			_i10nAdapter.invalidate(LifeCycle.PHASE_VALIDATE, property);
		}

		/**
		 * @inheritDoc
		 */
		public function isInvalidForAnyPhase() : Boolean {
			return _i10nAdapter.isInvalid();
		}

		/**
		 * @inheritDoc
		 */
		public function isInvalid(property : String = null) : Boolean {
			return _i10nAdapter.isInvalid(LifeCycle.PHASE_VALIDATE, property);
		}

		/**
		 * @inheritDoc
		 */
		public function invalidateDefaults(property : String = null) : void {
			_i10nAdapter.invalidate(LifeCycle.PHASE_CALCULATE_DEFAULTS, property);
		}

		/**
		 * @inheritDoc
		 */
		public function defaultIsInvalid(property : String = null) : Boolean {
			return _i10nAdapter.isInvalid(LifeCycle.PHASE_CALCULATE_DEFAULTS, property);
		}

		/**
		 * @inheritDoc
		 */
		public function scheduleRendering(property : String = null) : void {
			_i10nAdapter.invalidate(LifeCycle.PHASE_RENDER, property);
		}

		/**
		 * @inheritDoc
		 */
		public function shouldRender(property : String = null) : Boolean {
			return _i10nAdapter.isInvalid(LifeCycle.PHASE_RENDER, property);
		}

		/**
		 * @inheritDoc
		 */
		public function validateNow() : void {
			_i10nAdapter.validateNow();
		}
		
		/*
		 * as3commons_ui
		 */
		
		override as3commons_ui function setUp_internal(displayObject : DisplayObject, uiService : AbstractUIService) : void {
			super.setUp_internal(displayObject, uiService);
			
			if (displayObject.stage) {
				onInit();
				_initialized = true;
			}
		}

		as3commons_ui function get i10nAdapter_internal() : LifeCycleI10NAdapter {
			return _i10nAdapter;
		}
		
		as3commons_ui function validate_internal() : void {
			onValidate();
		}

		as3commons_ui function calculateDefaults_internal() : void {
			onCalculateDefaults();
		}

		as3commons_ui function render_internal() : void {
			onRender();
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
			return _uiService as LifeCycle;
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
		 * Calculate defaults hook (second phase).
		 * 
		 * <p>The custom adapter is supposed to calculate values for all properties not set yet.</p>
		 */
		protected function onCalculateDefaults() : void {
			// template method to be overridden
		}

		/**
		 * Validation hook (third phase).
		 * 
		 * <p>The custom adapter is supposed to draw any graphics or to layout its children.</p>
		 */
		protected function onRender() : void {
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
