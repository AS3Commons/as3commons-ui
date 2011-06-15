package org.as3commons.ui.lifecycle.lifecycle.testhelper {

	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	/**
	 * @author Jens Struwe 27.05.2011
	 */
	public class SimpleAdapter extends LifeCycleAdapter {
		
		private var _initCalls : uint;
		private var _drawCalls : uint;
		private var _initCompleteCalls : uint;
		private var _prepareUpdateCalls : uint;
		private var _updateCalls : uint;
		private var _cleanUpCalls : uint;
		
		override protected function onInit() : void {
			_initCalls++;
			LifeCycleWatcher.init(_component);
		}

		override protected function onDraw() : void {
			_drawCalls++;
			LifeCycleWatcher.draw(_component);
		}

		override protected function onInitComplete() : void {
			_initCompleteCalls++;
			LifeCycleWatcher.initComplete(_component);
		}

		override protected function onPrepareUpdate() : void {
			_prepareUpdateCalls++;
			LifeCycleWatcher.prepareUpdate(_component, _invalidProperties.toArray());
		}

		override protected function onUpdate() : void {
			_updateCalls++;
			var updateKinds : Array = _updateKinds ? _updateKinds.toArray() : [];
			LifeCycleWatcher.update(_component, updateKinds);
		}
		
		override protected function onCleanUp() : void {
			_cleanUpCalls++;
			LifeCycleWatcher.cleanUp(_component);
		}

		public function get initCalls() : uint {
			return _initCalls;
		}

		public function get drawCalls() : uint {
			return _drawCalls;
		}

		public function get initCompleteCalls() : uint {
			return _initCompleteCalls;
		}

		public function get prepareUpdateCalls() : uint {
			return _prepareUpdateCalls;
		}

		public function get updateCalls() : uint {
			return _updateCalls;
		}

	}
}
