package lifecycle.lifecycle.buttonexample {
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class Box extends Component {
		private var _display : DisplayObject;
		
		public function setChild(display : DisplayObject) : void {
			if (_display) {
				_display.removeEventListener(Event.CHANGE, displaySizeChanged);
				removeChild(_display);
			}
			
			_display = display;
			addChild(_display);
			_display.addEventListener(Event.CHANGE, displaySizeChanged);
			
			invalidate();
		}
		
		override protected function validate() : void {
			invalidateDefaults();
			scheduleRendering();
		}
		
		override protected function calculateDefaults() : void {
			setActualWidth(_display.width + 20);
			setActualHeight(_display.height + 20);
		}
		
		override protected function render() : void {
			with (graphics) {
				clear();
				beginFill(0xFFCCCC);
				lineStyle(1, 0x990000);
				drawRect(0, 0, width, height);
			}
			_display.x = 10;
			_display.y = 10;
		}

		private function displaySizeChanged(event : Event) : void {
			invalidate("size");
		}
	}
}