package layout.common.box {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;

	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Box extends JCSS_Sprite {
		
		public var data : *;

		private static var _currentColorIndex : int = 0;
		private static var _ID : uint;

		private var _width : uint;
		private var _height : uint;
		
		private var _over : Boolean = false;
		private var _down : Boolean = false;

		public static function setNextID(id : uint) : void {
			_ID = id - 1;
		}

		public static function create(numBoxes : uint, random : Boolean = false, minSize : uint = 30, maxSize : uint = 30, color : int = -1) : Array {
			return createCustom(Box, numBoxes, random, minSize, maxSize, color);
		}

		public static function createCustom(BoxType : Class, numBoxes : uint, random : Boolean = false, minSize : uint = 30, maxSize : uint = 30, color : int = -1) : Array {
			var boxes : Array = new Array();
			for (var i : uint = 0; i < numBoxes; i++) {
				boxes.push(new BoxType(random, minSize, maxSize, color));
			}
			return boxes;
		}

		public function Box(random : Boolean = false, minSize : uint = 30, maxSize : uint = 30, color : int = -1) {
			if (color == -1) color = getColor(random);
			
			var w : uint;
			var h : uint;
			
			if (random) {
				w = Math.round(Math.random() * (maxSize - minSize)) + minSize;
				h = Math.round(Math.random() * (maxSize - minSize)) + minSize;
			} else {
				w = minSize;
				h = maxSize;
			}
			
			name = "" + ++_ID;
			_width = w;
			_height = h;
			
			jcss_cssName = "Box";
			jcss_defineStyle("color", color, JCSS.FORMAT_COLOR);
			jcss_setStyle(":over", "color", ColorUtil.lightenBy(color, 20));
			jcss_setStyle(":down:over", "color", ColorUtil.darkenBy(color, 20));
		}

		override public function get width() : Number {
			return _width * scaleX;
		}

		override public function get height() : Number {
			return _height * scaleY;
		}

		override public function toString() : String {
			return "Box" + name + " " + hexToString(jcss_getStyle("color"));
		}

		override protected function jcss_onStylesChanged(styles : Object) : void {
			draw();
		}

		override protected function jcss_onStylesInitialized(styles : Object) : void {
			createLabel();
			draw();

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		private function mouseOverHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_over = true;
			jcss_setState("over", "true");
		}

		private function mouseOutHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_over = false;
			jcss_setState("over", "false");
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_down = true;
			jcss_setState("down", "true");

			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			_down = false;
			jcss_setState("down", "false");
		}

		private function getColor(random : Boolean) : uint {
			var colors : Array = [
				0xCC0000,
				0xFF9999,
				0x00CC00,
				0x99FF99,
				0xCC9900,
				0xFFCC66,
				0x0000CC,
				0x9999FF
			];
			if (random) {
				var index : uint = Math.round(Math.random() * (colors.length - 1));
				return colors[index];

			} else {
				_currentColorIndex++;
				if (_currentColorIndex == colors.length) _currentColorIndex = 0;
				return colors[_currentColorIndex];
			}
		}

		private function createLabel() : void {
			var tf : TextField = new TextField();
			tf.mouseEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = name;
			tf.textColor = 0xFFFFFF;

			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 10;
			tf.setTextFormat(textFormat);
			tf.defaultTextFormat = textFormat;
			
			addChild(tf);
		}

		private function draw() : void {
			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_width, _height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = gradient = ColorUtil.getGradient(jcss_getStyle("color"));

			with (graphics) {
				clear();
				// background
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRect(0, 0, _width, _height);
			}
		}

		private function hexToString(hex : Number, addHash : Boolean = true) : String {
			var hexString : String = hex.toString(16);
			hexString = ("000000").substr(0, 6 - hexString.length) + hexString; 
			if (addHash) hexString = "#" + hexString; 
			return hexString.toUpperCase();
		}

	}
}
