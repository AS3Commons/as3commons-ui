package org.as3commons.ui.lifecycle.lifecycle.testhelper {

	import flash.display.DisplayObject;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;


	/**
	 * @author Jens Struwe 12.09.2011
	 */
	public class TestLifeCycleAdapter extends LifeCycleAdapter {
		
		private var _watcher : LifeCycleCallbackWatcher;
		
		private var _validateFunction : Function;
		private var _measureFunction : Function;
		private var _updateFunction : Function;

		private var _addedToStageFunction : Function;
		private var _removedFromStageFunction : Function;
		
		private var _counts : Object;

		public function TestLifeCycleAdapter(watcher : LifeCycleCallbackWatcher) {
			_watcher = watcher;

			_counts = new Object();
			_counts["validate"] = 0;
			_counts["added"] = 0;
			_counts["removed"] = 0;
		}
		
		/*
		 * Optional adapter hooks
		 */
		
		public function set validateFunction(validateFunction : Function) : void {
			_validateFunction = validateFunction;
		}

		public function set measureFunction(measureFunction : Function) : void {
			_measureFunction = measureFunction;
		}

		public function set updateFunction(updateFunction : Function) : void {
			_updateFunction = updateFunction;
		}
		
		public function set addedToStageFunction(addedToStageFunction : Function) : void {
			_addedToStageFunction = addedToStageFunction;
		}

		public function set removedFromStageFunction(removedFromStageFunction : Function) : void {
			_removedFromStageFunction = removedFromStageFunction;
		}
		
		public function get validateCount() : uint {
			return _counts[LifeCycle.PHASE_VALIDATE];
		}

		public function get measureCount() : uint {
			return _counts[LifeCycle.PHASE_MEASURE];
		}

		public function get updateCount() : uint {
			return _counts[LifeCycle.PHASE_UPDATE];
		}

		public function get addedToStageCount() : uint {
			return _counts["added"];
		}

		public function get removedFromStageCount() : uint {
			return _counts["removed"];
		}

		/*
		 * I10NAdapter
		 */
		
		override public function validateNow() : void {
			super.validateNow();
		}
		
		override protected function onValidate() : void {
			// cache display object, it may be removed during validateFunction on unregister.
			var theDisplayObject : DisplayObject = displayObject;
			
			if (_validateFunction != null) _validateFunction();

			_watcher.logValidate(theDisplayObject);
			if (!_counts[LifeCycle.PHASE_VALIDATE]) _counts[LifeCycle.PHASE_VALIDATE] = 0;
			_counts[LifeCycle.PHASE_VALIDATE]++;
		}
		
		override protected function onMeasure() : void {
			// cache display object, it may be removed during validateFunction on unregister.
			var theDisplayObject : DisplayObject = displayObject;
			
			if (_measureFunction != null) _measureFunction();

			_watcher.logMeasure(theDisplayObject);
			if (!_counts[LifeCycle.PHASE_MEASURE]) _counts[LifeCycle.PHASE_MEASURE] = 0;
			_counts[LifeCycle.PHASE_MEASURE]++;
		}
		
		override protected function onUpdate() : void {
			// cache display object, it may be removed during validateFunction on unregister.
			var theDisplayObject : DisplayObject = displayObject;
			
			if (_updateFunction != null) _updateFunction();

			_watcher.logUpdate(theDisplayObject);
			if (!_counts[LifeCycle.PHASE_UPDATE]) _counts[LifeCycle.PHASE_UPDATE] = 0;
			_counts[LifeCycle.PHASE_UPDATE]++;
		}
		
		override protected function onAddedToStage() : void {
			if (_addedToStageFunction != null) _addedToStageFunction();

			_watcher.logAdded(displayObject);
			_counts["added"]++;
		}
		
		override protected function onRemovedFromStage() : void {
			if (_removedFromStageFunction != null) _removedFromStageFunction();
			
			_watcher.logRemoved(displayObject);
			_counts["removed"]++;
		}

	}
}
