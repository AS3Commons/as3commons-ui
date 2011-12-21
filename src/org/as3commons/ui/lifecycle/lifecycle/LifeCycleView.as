package org.as3commons.ui.lifecycle.lifecycle {

	import org.as3commons.ui.framework.core.as3commons_ui;

	import flash.display.Sprite;

	/**
	 * Ready-made UI base class implementing the LifeCycle service adapter.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycleView extends Sprite {
		
		/*
		 * Static context
		 */
		
		public static var lifeCycle : LifeCycle;
		
		private static function _lifeCycle_register(view : LifeCycleView) : void {
			if (!lifeCycle) {
				lifeCycle = new LifeCycle();
			}
			view._lifeCycleAdapter = new LifeCycleViewAdapter();
			lifeCycle.registerDisplayObject(view, view._lifeCycleAdapter);
		}
		
		private static function _lifeCycle_unregister(view : LifeCycleView) : void {
			if (!lifeCycle) return;
			lifeCycle.unregisterDisplayObject(view);
		}
		
		/*
		 * Instance context
		 */

		private var _lifeCycleAdapter : LifeCycleAdapter;

		/**
		 * LifeCycleView constructor.
		 */
		public function LifeCycleView() {
			_lifeCycle_register(this);
			invalidate();
		}
		
		/*
		 * Public
		 */

		/**
		 * The nest level of the object.
		 * 
		 * <p>The nest level is set to <code>-1</code> if the object is not in the
		 * display list or the adapter is not registered.</p>
		 */
		public function get nestLevel() : int {
			return _lifeCycleAdapter.nestLevel;
		}

		/**
		 * Validates the objects immediately.
		 * 
		 * <p>You cannot all this method during a running validation cycle. An error
		 * is thrown if you try.</p>
		 * 
		 * <p>The display list of the current object including all invalid children gets validated.</p>
		 * 
		 * <p>Invalidating non-children during a <code>validateNow()</code> run will skip those components
		 * and schedule them to the next usual validation cycle.</p>
		 */
		public function validateNow() : void {
			_lifeCycleAdapter.validateNow();
		}

		/**
		 * Unregisters the component from the LifeCycle service and calls the <code>onCleanUp()</code> hook.
		 */
		public function cleanUp() : void {
			_lifeCycle_unregister(this);
			_lifeCycleAdapter = null;
			onCleanUp();
		}

		/*
		 * as3commons_ui
		 */

		as3commons_ui function init_internal() : void {
			init();
			createChildren();
		}

		as3commons_ui function validate_internal() : void {
			validate();
		}

		as3commons_ui function measure_internal() : void {
			measure();
		}

		as3commons_ui function update_internal() : void {
			update();
		}

		as3commons_ui function onAddedToStage_internal() : void {
			onAddedToStage();
		}

		as3commons_ui function onRemovedFromStage_internal() : void {
			onRemovedFromStage();
		}

		/*
		 * Protected
		 */

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.ILifeCycleAdapter#isInvalidForAnyPhase()
		 */
		protected function isInvalidForAnyPhase() : Boolean {
			return _lifeCycleAdapter.isInvalidForAnyPhase();
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.ILifeCycleAdapter#invalidate()
		 */
		protected function invalidate(property : String = null) : void {
			_lifeCycleAdapter.invalidate(property);
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.ILifeCycleAdapter#isInvalid()
		 */
		protected function isInvalid(property : String = null) : Boolean {
			return _lifeCycleAdapter.isInvalid(property);
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.ILifeCycleAdapter#requestMeasurement()
		 */
		protected function requestMeasurement() : void {
			_lifeCycleAdapter.requestMeasurement();
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.ILifeCycleAdapter#shouldMeasure()
		 */
		protected function shouldMeasure() : Boolean {
			return _lifeCycleAdapter.shouldMeasure();
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.ILifeCycleAdapter#scheduleUpdate()
		 */
		protected function scheduleUpdate(property : String = null) : void {
			_lifeCycleAdapter.scheduleUpdate(property);
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.ILifeCycleAdapter#shouldUpdate()
		 */
		protected function shouldUpdate(property : String = null) : Boolean {
			return _lifeCycleAdapter.shouldUpdate(property);
		}

		/*
		 * Protected hooks
		 */

		/**
		 * Init hook.
		 * 
		 * <p>The component is supposed to perform all initialization operations such
		 * as calculating styles.</p>
		 * 
		 * <p>Called only once per component right after the component has been added
		 * to the stage.</p>
		 */
		protected function init() : void {
			// template method to be overridden
		}

		/**
		 * Create children hook.
		 * 
		 * <p>The component is supposed to create its children.</p>
		 * 
		 * <p>Called only once per component right after the component has been added
		 * to the stage.</p>
		 */
		protected function createChildren() : void {
			// template method to be overridden
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter#onValidate()
		 */
		protected function validate() : void {
			// template method to be overridden
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter#onMeasure()
		 */
		protected function measure() : void {
			// template method to be overridden
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter#onUpdate()
		 */
		protected function update() : void {
			// template method to be overridden
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter#onAddedToStage()
		 */
		protected function onAddedToStage() : void {
			// template method to be overridden
		}

		/**
		 * @copy org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter#onRemovedFromStage()
		 */
		protected function onRemovedFromStage() : void {
			// template method to be overridden
		}

		/**
		 * Clean up hook.
		 * 
		 * <p>The component is supposed to remove any listeners and references that
		 * hinder the component from being garbage collected.</p>
		 */
		protected function onCleanUp() : void {
			// template method to be overridden
		}

	}
}

import org.as3commons.ui.framework.core.as3commons_ui;
import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;
import org.as3commons.ui.lifecycle.lifecycle.LifeCycleView;

use namespace as3commons_ui;

internal class LifeCycleViewAdapter extends LifeCycleAdapter {
	
	override protected function onInit() : void {
		LifeCycleView(displayObject).init_internal();
	}
	
	override protected function onValidate() : void {
		LifeCycleView(displayObject).validate_internal();
	}

	override protected function onMeasure() : void {
		LifeCycleView(displayObject).measure_internal();
	}

	override protected function onUpdate() : void {
		LifeCycleView(displayObject).update_internal();
	}

	override protected function onAddedToStage() : void {
		LifeCycleView(displayObject).onAddedToStage_internal();
	}

	override protected function onRemovedFromStage() : void {
		LifeCycleView(displayObject).onRemovedFromStage_internal();
	}
}