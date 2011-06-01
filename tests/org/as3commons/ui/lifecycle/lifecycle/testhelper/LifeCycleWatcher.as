package org.as3commons.ui.lifecycle.lifecycle.testhelper {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 27.05.2011
	 */
	public class LifeCycleWatcher {
		
		private static var _initCalls : Array = new Array();
		private static var _drawCalls : Array = new Array();
		private static var _initCompleteCalls : Array = new Array();
		private static var _updateCalls : Array = new Array();
		private static var _prepareUpdateCalls : Array = new Array();
		private static var _invalidProperties : Array = new Array();
		private static var _updateKinds : Array = new Array();
		private static var _cleanUpCalls : Array = new Array();
		
		public static function init(displayObject : DisplayObject) : void {
			_initCalls.push(displayObject);
		}
		
		public static function draw(displayObject : DisplayObject) : void {
			_drawCalls.push(displayObject);
		}
		
		public static function initComplete(displayObject : DisplayObject) : void {
			_initCompleteCalls.push(displayObject);
		}
		
		public static function update(displayObject : DisplayObject, updateKinds : Array) : void {
			_updateCalls.push(displayObject);
			_updateKinds = _updateKinds.concat(updateKinds);
		}
		
		public static function prepareUpdate(displayObject : DisplayObject, invalidProperties : Array) : void {
			_prepareUpdateCalls.push(displayObject);
			_invalidProperties = _invalidProperties.concat(invalidProperties);
		}
		
		public static function cleanUp(displayObject : DisplayObject) : void {
			_cleanUpCalls.push(displayObject);
		}
		
		public static function get initCalls() : Array {
			return _initCalls;
		}
		
		public static function get drawCalls() : Array {
			return _drawCalls;
		}
		
		public static function get initCompleteCalls() : Array {
			return _initCompleteCalls;
		}
		
		public static function get updateCalls() : Array {
			return _updateCalls;
		}

		public static function get prepareUpdateCalls() : Array {
			return _prepareUpdateCalls;
		}

		public static function get invalidProperties() : Array {
			return _invalidProperties;
		}

		public static function get updateKinds() : Array {
			return _updateKinds;
		}

		public static function get cleanUpCalls() : Array {
			return _cleanUpCalls;
		}

		public static function clearCalls() : void {
			_initCalls = new Array();
			_drawCalls = new Array();
			_initCompleteCalls = new Array();
			_updateCalls = new Array();
			_prepareUpdateCalls = new Array();
			_cleanUpCalls = new Array();
		}

		public static function clearProperties() : void {
			_invalidProperties = new Array();
			_updateKinds = new Array();
		}

		public static function clear() : void {
			clearCalls();
			clearProperties();
		}

	}
}
