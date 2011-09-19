package org.as3commons.ui.layout.testhelper {
	import flash.display.Sprite;
	
	public class TestBox extends Sprite {
		public static function create(numBoxes : uint, color : uint) : Array {
			var array : Array = new Array();
			for (var i : uint; i < numBoxes; i++) {
				array.push(new TestBox(color));
			}
			return array;
		}

		public function TestBox(color : uint) {
			with (graphics) {
				clear();
				beginFill(color);
				drawRect(0, 0, 10, 10);
			}
		}
	}
}