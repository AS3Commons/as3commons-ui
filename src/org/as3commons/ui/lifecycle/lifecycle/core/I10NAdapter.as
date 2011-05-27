package org.as3commons.ui.lifecycle.lifecycle.core {

	import org.as3commons.collections.framework.ISet;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	import flash.display.DisplayObject;


	/**
	 * @author Jens Struwe 25.05.2011
	 */
	public class I10NAdapter implements II10NApapter {

		private var _lifeCycleManager : LifeCycle;

		public function I10NAdapter(lifeCycleManager : LifeCycle) {
			_lifeCycleManager = lifeCycleManager;
		}

		public function willValidate(displayObject : DisplayObject) : void {
			var adapter : LifeCycleAdapter = _lifeCycleManager.as3commons_ui::getAdapter_internal(displayObject);
			adapter.as3commons_ui::onWillValidate_internal();
		}

		public function validate(displayObject : DisplayObject, properties : ISet) : void {
			var adapter : LifeCycleAdapter = _lifeCycleManager.as3commons_ui::getAdapter_internal(displayObject);
			adapter.as3commons_ui::onValidate_internal(properties);
		}

	}
}
