package lifecycle.lifecycle.panelexample {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import lifecycle.lifecycle.common.Component;

	public class Panel extends Component {
		private var _display : DisplayObject;
		private var _backgroundColor : uint = 0xFFCCCC;
		
		public function setChild(display : DisplayObject) : void {
			_display = display;
			addChild(_display);
			_display.addEventListener(Component.EVENT_RESIZE, displaySizeChanged);
			invalidate();
		}
		
		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;
			invalidate();
		}

		override protected function validate() : void {
			if (!explicitWidth || !explicitHeight) requestMeasurement();
			scheduleUpdate();
		}
		
		override protected function measure() : void {
			if (_display) {
				measuredWidth = _display.width + 20;
				measuredHeight = _display.height + 20;
			} else {
				measuredWidth = 20;
				measuredHeight = 20;
			}
		}
		
		override protected function update() : void {
			with (graphics) {
				clear();
				beginFill(_backgroundColor);
				lineStyle(1, 0x990000);
				drawRect(0, 0, width, height);
			}
			
			if (_display) {
				_display.x = 10;
				_display.y = 10;
			}
		}

		private function displaySizeChanged(event : Event) : void {
			invalidate(SIZE);
		}
	}
}