package org.as3commons.ui.lifecycle.lifecycle.testhelper {

	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	/**
	 * @author Jens Struwe 27.05.2011
	 */
	public class SimpleAdapter extends LifeCycleAdapter {
		
		private var _initCalls : uint;
		private var _prepareUpdateCalls : uint;
		private var _updateCalls : uint;
		
		override protected function init() : void {
			_initCalls++;
			LifeCycleWatcher.init(_component);
		}

		override protected function prepareUpdate() : void {
			_prepareUpdateCalls++;
			LifeCycleWatcher.prepareUpdate(_component, _invalidProperties.toArray());
		}

		override protected function update() : void {
			_updateCalls++;
			LifeCycleWatcher.update(_component, _updateKinds.toArray());
		}

		public function get initCalls() : uint {
			return _initCalls;
		}

		public function get prepareUpdateCalls() : uint {
			return _prepareUpdateCalls;
		}

		public function get updateCalls() : uint {
			return _updateCalls;
		}

	}
}
