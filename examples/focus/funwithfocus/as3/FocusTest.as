package focus.funwithfocus.as3 {

	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FocusTest extends Sprite {
		
		private var _tf : TextField;
		private var _preventDefault : Boolean = false;
		private var _focusToStage : Boolean = false;

		public function FocusTest() {
			
			var numBoxes : uint = 6;
			var numEnabledBoxes : uint = 3;

			if (loaderInfo.parameters["numBoxes"]) {
				numBoxes = loaderInfo.parameters["numBoxes"];
				numEnabledBoxes = loaderInfo.parameters["numEnabledBoxes"];
				_preventDefault = loaderInfo.parameters["preventDefault"] == "true" ? true : false;
				_focusToStage = loaderInfo.parameters["focusToStage"] == "true" ? true : false;
			}
			
			var info : TextField = createLabel();
			info.text = "FLASH";
			info.x = 18;
			info.y = 14;
			addChild(info);

			var box : Box;
			var boxX : uint = 20;
			var boxY : uint = 44;
			for (var i : uint = 0; i < numBoxes; i++) {
				box = new Box();
				box.x = boxX; 
				box.y = boxY;
				box.name = "Box" + (i + 1);
				
				if (i < numEnabledBoxes) {
					box.tabIndex = i;
					box.tabEnabled = true;
					box.draw(0xFF0000);
				} else {
					box.draw(0x999999);
				}
				
				addChild(box);
				
				boxX += 40;
				if ((i + 1) % 4 == 0) {
					boxX = 20;
					boxY += 40;
				}
			}
			
			if (_focusToStage) {
				stage.focus = stage;
			}
			
			_tf = createLabel();
			_tf.x = 18;
			_tf.y = 125;
			logChange();
			addChild(_tf);
			
			addEventListener(Event.ACTIVATE, activate);
			addEventListener(Event.DEACTIVATE, deactivate);
			
			stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, change);
			stage.addEventListener(FocusEvent.FOCUS_OUT, focusOut);

			stage.addEventListener(FocusEvent.FOCUS_IN, logChange);
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, logChange);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, logChange);
		}

		private function focusOut(event : FocusEvent) : void {
			if (!stage.focus && _focusToStage) {
				stage.focus = stage;
			}
			logChange();
		}

		private function createLabel() : TextField {
			var tf : TextField = new TextField();
			tf.mouseEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;

			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 14;
			tf.setTextFormat(textFormat);
			tf.defaultTextFormat = textFormat;
			
			return tf;
		}

		private function change(event : FocusEvent) : void {
			if (_preventDefault) {
				event.preventDefault();
			}
			
			logChange(event);
		}

		private function logChange(event : Event = null) : void {
			var focus : * = stage.focus;
			if (stage.focus == stage) focus = "Stage";
			_tf.text = "Focus: " + focus;
		}

		private function deactivate(event : Event) : void {
			draw(0xFFFFFF);
			logChange();
		}

		private function activate(event : Event) : void {
			draw(0xEEEEEE);
			logChange();
		}
		
		private function draw(color : uint) : void {
			with (graphics) {
				beginFill(color);
				drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			}
		}
	}
}
