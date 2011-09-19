package org.as3commons.ui.testhelper {

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 27.05.2011
	 */
	public class TestDisplayObject extends Sprite {
		
		private var _name : String;
		
		public function TestDisplayObject(name : String) {
			_name = name;
		}
		
		override public function toString() : String {
			return "[" + _name + "]";
		}
	}
}
