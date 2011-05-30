package org.as3commons.ui.lifecycle.lifecycle.core {

	import org.as3commons.collections.framework.ISet;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	import flash.display.DisplayObject;


	/**
	 * <code>II10NApapter</code> implementation used by <code>LifeCycle</code>.
	 * 
	 * @author Jens Struwe 25.05.2011
	 */
	public class I10NAdapter implements II10NApapter {

		/**
		 * Internal <code>LifeCycle</code> reference.
		 */
		private var _lifeCycle : LifeCycle;

		/**
		 * <code>I10NAdapter</code> constructor.
		 */
		public function I10NAdapter(lifeCycleManager : LifeCycle) {
			_lifeCycle = lifeCycleManager;
		}

		/**
		 * @inheritDoc
		 */
		public function willValidate(displayObject : DisplayObject) : void {
			var adapter : LifeCycleAdapter = _lifeCycle.as3commons_ui::getAdapter_internal(displayObject);
			adapter.as3commons_ui::willValidate_internal();
		}

		/**
		 * @inheritDoc
		 */
		public function validate(displayObject : DisplayObject, properties : ISet) : void {
			var adapter : LifeCycleAdapter = _lifeCycle.as3commons_ui::getAdapter_internal(displayObject);
			adapter.as3commons_ui::validate_internal(properties);
		}

	}
}
