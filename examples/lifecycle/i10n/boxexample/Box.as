package lifecycle.i10n.boxexample {
	import flash.display.Sprite;

	public class Box extends Sprite {
		private var _adapter : BoxAdapter;
		private var _backgroundColor : uint = 0xCCCCCC;
		private var _borderColor : uint = 0x999999;

		public function Box(boxName : String) {
			name = boxName;
			
			_adapter = new BoxAdapter();
			I10NService.instance.registerDisplayObject(this, _adapter);
			_adapter.invalidate(I10NService.PHASE_VALIDATE);
		}

		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;
			_adapter.invalidate(I10NService.PHASE_VALIDATE);
		}

		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
			_adapter.invalidate(I10NService.PHASE_VALIDATE);
		}

		public function render() : void {
			trace ("RENDER", name);
			with (graphics) {
				clear();
				lineStyle(1, _borderColor);
				beginFill(_backgroundColor);
				drawRect(0, 0, 100, 100);
			}
		}
	}
}