package lifecycle.lifecycle.buttonexample {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lifecycle.lifecycle.common.Component;

	public class Button extends Component {
		public static const EVENT_CLICK : String = "button_click";
		public static const STATE_UP : String = "state_up";
		public static const STATE_DOWN : String = "state_down";
		public static const STATE_OVER : String = "state_over";

		private const LABEL_TEXT : String = "label_text";
		private const LABEL_FONT_SIZE : String = "label_font_size";
		private const STATE : String = "state";
		private const LABEL_SIZE : String = "label_size";

		private var _labelText : String;
		private var _labelFontSize : uint;
		private var _skin : ButtonSkin;
		private var _label : Label;
		private var _over : Boolean;
		private var _down : Boolean;

		public function Button() {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			
			mouseChildren = false;
		}
		
		public function set labelText(labelText : String) : void {
			_labelText = labelText;
			invalidate(LABEL_TEXT);
		}
		
		public function set labelFontSize(labelSize : uint) : void {
			_labelFontSize = labelSize;
			invalidate(LABEL_FONT_SIZE);
		}

		override protected function createChildren() : void {
			_skin = new ButtonSkin();
			addChild(_skin);
			
			_label = new Label();
			_label.addEventListener(Component.EVENT_RESIZE, labelResized);
			addChild(_label);
		}
		
		override protected function validate() : void {
			if (isInvalid(SIZE)) {
				if (explicitWidth) {
					_label.width = _skin.width = explicitWidth;
				} else {
					_label.width = 0;
					requestMeasurement();
				}
				
				if (explicitHeight) {
					_label.height = _skin.height = explicitHeight;
				} else {
					_label.height = 0;
					requestMeasurement();
				}
			}

			if (isInvalid(LABEL_SIZE)) {
				if (!explicitWidth || !explicitHeight) {
					requestMeasurement();
				}
			}
			
			if (isInvalid(LABEL_TEXT)) {
				if (_labelText == null) _labelText = "Click";
				_label.text = _labelText;
			}
			
			if (isInvalid(LABEL_FONT_SIZE)) {
				if (!_labelFontSize) _labelFontSize = 12;
				_label.fontSize = _labelFontSize;
			}
			
			if (isInvalid(STATE)) {
				if (_over && _down) _skin.state = STATE_DOWN;
				else if (_over) _skin.state = STATE_OVER;
				else _skin.state = STATE_UP;
				
				if (_over) _label.color = 0x555555;
				else _label.color = 0x333333;
				
				scheduleUpdate();
			}
		}
		
		override protected function measure() : void {
			if (!explicitWidth) measuredWidth = _skin.width = _label.width;
			if (!explicitHeight) measuredHeight = _skin.height = _label.height;
		}
		
		override protected function update() : void {
			if (_over && _down) {
				_label.x = _label.y = 1;
			} else {
				_label.x = _label.y = 0;
			}
		}
		
		private function mouseOverHandler(event : MouseEvent) : void {
			_over = true;
			invalidate(STATE);
		}

		private function mouseOutHandler(event : MouseEvent) : void {
			_over = false;
			invalidate(STATE);
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			_down = true;
			invalidate(STATE);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_down = false;
			invalidate(STATE);
			if (_over) dispatchEvent(new Event(EVENT_CLICK, true));
		}

		private function labelResized(event : Event) : void {
			invalidate(LABEL_SIZE);
		}
	}
}