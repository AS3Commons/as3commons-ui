package org.as3commons.ui.lifecycle.i10n.testhelper {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 12.09.2011
	 */
	public class I10NCallbackWatcher {
		
		private var _logValidate : Array;
		private var _logAdded : Array;
		private var _logRemoved : Array;

		public function I10NCallbackWatcher() {
			_logValidate = new Array();
			_logAdded = new Array();
			_logRemoved = new Array();
		}

		public function logValidate(displayObject : DisplayObject, phaseName : String) : void {
			_logValidate.push(displayObject, phaseName);
		}

		public function get validateLog() : Array {
			var log : Array = _logValidate;
			_logValidate = new Array();
			return log;
		}
		
		public function logAdded(displayObject : DisplayObject) : void {
			_logAdded.push(displayObject);
		}

		public function get addedLog() : Array {
			var log : Array = _logAdded;
			_logAdded = new Array();
			return log;
		}

		public function logRemoved(displayObject : DisplayObject) : void {
			_logRemoved.push(displayObject);
		}

		public function get removedLog() : Array {
			var log : Array = _logRemoved;
			_logRemoved = new Array();
			return log;
		}

	}
}
