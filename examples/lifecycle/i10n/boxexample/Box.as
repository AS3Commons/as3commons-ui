package lifecycle.i10n.boxexample {
	import flash.display.Shape;
	import flash.display.Sprite;

	public class Box extends Sprite {
		private var _name : String;
		private var _backgroundColor : uint = 0xCCCCCC;
		private var _borderColor : uint = 0x999999;
		private var _background : Shape;
		private var _border : Shape;

		public function Box(name : String) {
			_name = name;
			_background = addChild(new Shape()) as Shape;
			_border = addChild(new Shape()) as Shape;
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
			drawBackground();
			drawBorder();
		}
		
		private function drawBackground() : void {
			trace (_name, "drawBackground");
			with (_background.graphics) {
				clear();
				beginFill(_backgroundColor);
				drawRect(0, 0, 100, 100);
			}
		}

		private function drawBorder() : void {
			trace (_name, "drawBorder");
			with (_border.graphics) {
				clear();
				lineStyle(1, _borderColor);
				drawRect(0, 0, 99, 99);
			}
		}
	}
}