package org.as3commons.ui.lifecycle.i10n2.testhelper {

	import flash.display.DisplayObject;
	import org.as3commons.ui.lifecycle.i10n2.I10NAdapter;


	/**
	 * @author Jens Struwe 12.09.2011
	 */
	public class TestAdapter extends I10NAdapter {
		
		private var _watcher : I10NCallbackWatcher;
		
		private var _validateFunction : Function;
		private var _addedToStageFunction : Function;
		private var _removedFromStageFunction : Function;
		
		private var _counts : Object;

		public function TestAdapter(watcher : I10NCallbackWatcher) {
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

		public function set addedToStageFunction(addedToStageFunction : Function) : void {
			_addedToStageFunction = addedToStageFunction;
		}

		public function set removedFromStageFunction(removedFromStageFunction : Function) : void {
			_removedFromStageFunction = removedFromStageFunction;
		}
		
		public function get validateCount() : uint {
			return _counts["validate"];
		}

		public function validateCountForPhase(phaseName : String) : uint {
			return _counts[phaseName];
		}

		/*
		 * I10NAdapter
		 */
		
		override public function validateNow() : void {
			super.validateNow();
		}
		
		override protected function validate(phaseName : String) : void {
			// cache display object, it may be removed during validateFunction on unregister.
			var theDisplayObject : DisplayObject = displayObject;
			
			if (_validateFunction != null) _validateFunction(phaseName);

			_watcher.logValidate(theDisplayObject, phaseName);
			_counts["validate"]++;
			if (!_counts[phaseName]) _counts[phaseName] = 0;
			_counts[phaseName]++;
			
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
