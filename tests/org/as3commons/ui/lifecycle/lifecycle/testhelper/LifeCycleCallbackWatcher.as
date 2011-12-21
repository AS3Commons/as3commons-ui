package org.as3commons.ui.lifecycle.lifecycle.testhelper {

	import flash.display.DisplayObject;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;

	/**
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycleCallbackWatcher {

		private var _logValidate : Array;
		private var _logMeasure : Array;
		private var _logUpdate : Array;
		
		private var _phasesLog : Array;

		private var _logAdded : Array;
		private var _logRemoved : Array;

		public function LifeCycleCallbackWatcher() {
			_logValidate = new Array();
			_logMeasure = new Array();
			_logUpdate = new Array();
			
			_phasesLog = new Array();
			
			_logAdded = new Array();
			_logRemoved = new Array();
		}

		public function logValidate(displayObject : DisplayObject) : void {
			_logValidate.push(displayObject);
			_phasesLog.push(displayObject, LifeCycle.PHASE_VALIDATE);
		}

		public function get validateLog() : Array {
			var log : Array = _logValidate;
			_logValidate = new Array();
			return log;
		}
		
		public function logMeasure(displayObject : DisplayObject) : void {
			_logValidate.push(displayObject);
			_phasesLog.push(displayObject, LifeCycle.PHASE_MEASURE);
		}

		public function get measureLog() : Array {
			var log : Array = _logMeasure;
			_logMeasure = new Array();
			return log;
		}
		
		public function logUpdate(displayObject : DisplayObject) : void {
			_logUpdate.push(displayObject);
			_phasesLog.push(displayObject, LifeCycle.PHASE_UPDATE);
		}

		public function get updateLog() : Array {
			var log : Array = _logUpdate;
			_logUpdate = new Array();
			return log;
		}
		
		public function get phasesLog() : Array {
			var log : Array = _phasesLog;
			_phasesLog = new Array();
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
