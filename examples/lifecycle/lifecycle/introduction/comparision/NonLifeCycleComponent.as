package lifecycle.lifecycle.introduction.comparision {
	import flash.display.Sprite;

	public class NonLifeCycleComponent extends Sprite {
		private var _borderColor : uint = 0x999999;
		private var _backgroundColor : uint = 0xDDDDDD;

		public function NonLifeCycleComponent() {
			draw();
		}

		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
			draw();
		}

		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;
			draw();
		}

		private function draw() : void {
			trace ("DRAW non life cycle component");
			with (graphics) {
				clear();
				lineStyle(1, _borderColor);
				beginFill(_backgroundColor);
				drawRect(0, 0, 100, 100);
			}
		}
	}
}