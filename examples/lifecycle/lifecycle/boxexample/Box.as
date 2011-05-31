package lifecycle.lifecycle.boxexample {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;
	import flash.display.Sprite;

	public class Box extends Sprite {
		private var _lcAdapter : LifeCycleAdapter;
		private var _name : String;
		private var _backgroundColor : uint = 0xCCCCCC;
		private var _borderColor : uint = 0x999999;

		public function Box(name : String) {
			_name = name;
			_lcAdapter = new BoxAdapter();
			LIFE_CYCLE.registerComponent(this, _lcAdapter);
		}

		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;
			_lcAdapter.invalidate();
		}

		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
			_lcAdapter.invalidate();
		}
		
		public function init() : void {
			trace (_name, "init");
		}

		public function draw() : void {
			trace (_name, "draw");
			drawBox();
		}

		public function update() : void {
			trace (_name, "update");
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