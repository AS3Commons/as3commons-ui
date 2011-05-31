package lifecycle.i10n.boxexample {
	import flash.display.Sprite;

	public class Box extends Sprite {
		private var _name : String;
		private var _backgroundColor : uint = 0xCCCCCC;
		private var _borderColor : uint = 0x999999;

		public function Box(name : String) {
			_name = name;
			I10N.invalidate(this);
		}

		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;
			I10N.invalidate(this);
		}

		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
			I10N.invalidate(this);
		}

		public function update() : void {
			draw();
		}
		
		private function draw() : void {
			trace (_name, "draw");
			with (graphics) {
				clear();
				lineStyle(1, _borderColor);
				beginFill(_backgroundColor);
				drawRect(0, 0, 100, 100);
			}
		}
	}
}