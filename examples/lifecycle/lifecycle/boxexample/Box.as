package lifecycle.lifecycle.boxexample {
	import flash.display.Sprite;

	public class Box extends Sprite {
		private var _adapter : BoxAdapter;
		private var _backgroundColor : uint;
		private var _borderColor : uint;

		public function Box(boxName : String) {
			name = boxName;
			_adapter = new BoxAdapter();
			LifeCycleService.instance.registerDisplayObject(this, _adapter);
			_adapter.invalidate();
		}

		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;
			_adapter.invalidate();
		}

		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
			_adapter.invalidate();
		}
		
		public function init() : void {
			trace ("INIT", name);
			_backgroundColor = 0xCCCCCC;
		}

		public function validate() : void {
			trace ("VALIDATE", name);
			
			if (!_borderColor) _adapter.requestMeasurement();
			if (!_backgroundColor) _adapter.requestMeasurement();
			
			_adapter.scheduleUpdate();
		}

		public function measure() : void {
			trace ("MEASURE", name);
			
			_borderColor = 0x999999;
			_backgroundColor = 0xCCCCCC;
		}

		public function update() : void {
			trace ("UPDATE", name);
			drawBox();
		}
		
		private function drawBox() : void {
			with (graphics) {
				clear();
				lineStyle(1, _borderColor);
				beginFill(_backgroundColor);
				drawRect(0, 0, 100, 100);
			}
		}
	}
}