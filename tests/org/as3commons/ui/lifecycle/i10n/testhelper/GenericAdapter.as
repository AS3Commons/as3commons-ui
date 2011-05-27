package org.as3commons.ui.lifecycle.i10n.testhelper {

	import org.as3commons.collections.framework.ISet;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class GenericAdapter extends SimpleAdapter {
		
		private var _willValidateFunction : Function;
		private var _validateFunction : Function;

		public function GenericAdapter(willValidateFunction : Function, validateFunction : Function) {
			_willValidateFunction = willValidateFunction;
			_validateFunction = validateFunction;
		}

		override public function willValidate(displayObject : DisplayObject) : void {
			super.willValidate(displayObject);
			
			if (_willValidateFunction != null) _willValidateFunction(displayObject);
		}

		override public function validate(displayObject : DisplayObject, properties : ISet) : void {
			super.validate(displayObject, properties);
			
			if (_validateFunction != null) _validateFunction(displayObject);
		}

	}
}
