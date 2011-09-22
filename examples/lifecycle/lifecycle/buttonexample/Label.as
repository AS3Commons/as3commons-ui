package lifecycle.lifecycle.buttonexample {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public class Label extends Component {
		private const TEXT : String = "text";
		private const COLOR : String = "color";
		private const FONT_SIZE : String = "font_size";
		 
		private var _text : String;
		private var _color : uint = uint.MAX_VALUE;
		private var _fontSize : uint;
		private var _tf : TextField;
		private var _mask : Sprite;
		
		public function set text(text : String) : void {
			_text = text;
			invalidate(TEXT);
		}
		
		public function set color(color : uint) : void {
			_color = color;
			invalidate(COLOR);
		}

		public function set fontSize(fontSize : uint) : void {
			_fontSize = fontSize;
			invalidate(FONT_SIZE);
		}

		override protected function createChildren() : void {
			_mask = new Sprite();
			with (_mask.graphics) {
				beginFill(0);
				drawRect(0, 0, 100, 100);
			}
			addChild(_mask);
			mask = _mask;

			_tf = new TextField();
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.selectable = false;
			_tf.defaultTextFormat = new TextFormat("_sans");
			addChild(_tf);
		}
		
		override protected function validate() : void {
			if (isInvalid(SIZE)) {
				if (!explicitWidth || !explicitHeight) {
					invalidateDefaults();
				}
				scheduleRendering(SIZE);
			}
			
			if (isInvalid(TEXT)) {
				invalidate(SIZE);
				if (_text == null) _text = "Label";
				scheduleRendering(TEXT);
			}
			
			if (isInvalid(FONT_SIZE)) {
				invalidate(SIZE);
				if (!_fontSize) _fontSize = 11;
				scheduleRendering(FONT_SIZE);
			}

			if (isInvalid(COLOR)) {
				if (_color == uint.MAX_VALUE) _color = 0xFF0000;
				scheduleRendering(COLOR);
			}
		}
		
		override protected function calculateDefaults() : void {
			var tf : TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("_sans", _fontSize);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = _text;
			var metrics : TextLineMetrics = tf.getLineMetrics(0);
			if (!explicitWidth) setActualWidth(metrics.width + 4);
			if (!explicitHeight) setActualHeight(metrics.height + 4);
		}
		
		override protected function render() : void {
			if (shouldRender(TEXT)) {
				_tf.text = _text;
			}
			
			if (shouldRender(COLOR)) {
				_tf.textColor = _color;
			}
			
			if (shouldRender(FONT_SIZE)) {
				_tf.defaultTextFormat = new TextFormat("_sans", _fontSize);
				_tf.setTextFormat(_tf.defaultTextFormat);
			}
			
			if (shouldRender(SIZE)) {
				_mask.width = width;
				_mask.height = height;

				_tf.x = explicitWidth ? (width - _tf.width) / 2 : 0;
				_tf.y = explicitHeight ? (height - _tf.height) / 2 : 0;
			}
		}
	}
}