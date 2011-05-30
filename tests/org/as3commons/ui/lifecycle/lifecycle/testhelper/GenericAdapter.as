package org.as3commons.ui.lifecycle.lifecycle.testhelper {

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class GenericAdapter extends SimpleAdapter {
		
		private var _initFunction : Function;
		private var _prepareUpdateFunction : Function;
		private var _updateFunction : Function;

		public function GenericAdapter(initFunction : Function, prepareUpdateFunction : Function, updateFunction : Function) {
			_initFunction = initFunction;
			_prepareUpdateFunction = prepareUpdateFunction;
			_updateFunction = updateFunction;
		}

		override protected function onInit() : void {
			super.onInit();
			
			if (_initFunction != null) _initFunction();
		}

		override protected function onPrepareUpdate() : void {
			super.onPrepareUpdate();
			
			if (_prepareUpdateFunction != null) _prepareUpdateFunction();
		}

		override protected function onUpdate() : void {
			super.onUpdate();
			
			if (_updateFunction != null) _updateFunction();
		}

	}
}
