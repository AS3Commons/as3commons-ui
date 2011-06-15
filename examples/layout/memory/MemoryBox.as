package layout.memory {
	import flash.display.Sprite;
	
	public class MemoryBox extends Sprite {
		public static function create(numBoxes : uint, color : uint) : Array {
			var array : Array = new Array();
			for (var i : uint; i < numBoxes; i++) {
				array.push(new MemoryBox(color));
			}
			return array;
		}

		public function MemoryBox(color : uint) {
			with (graphics) {
				clear();
				beginFill(color);
				drawRect(0, 0, 10, 10);
			}
		}
	}
}