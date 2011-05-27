package org.as3commons.ui.lifecycle.i10n.testhelper {

	import org.as3commons.collections.framework.ISet;
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class SimpleAdapter implements II10NApapter {
		
		private var _willValidateCalls : Array = new Array();
		private var _validateCalls : Array = new Array();
		private var _validateCallProperties : Array = new Array();
		
		public function willValidate(displayObject : DisplayObject) : void {
			_willValidateCalls.push(displayObject);
		}

		public function validate(displayObject : DisplayObject, properties : ISet) : void {
			_validateCalls.push(displayObject);
			_validateCallProperties = _validateCallProperties.concat(properties.toArray());
		}

		public function get willValidateCalls() : Array {
			return _willValidateCalls;
		}

		public function get validateCalls() : Array {
			return _validateCalls;
		}

		public function get validateCallProperties() : Array {
			return _validateCallProperties;
		}

	}
}
