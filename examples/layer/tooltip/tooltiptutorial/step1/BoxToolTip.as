package layer.tooltip.tooltiptutorial.step1 {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class BoxToolTip extends Sprite {
		private var _tf : TextField;
		
		public function BoxToolTip() {
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("_sans", 10, 0x333333);
			_tf.background = true;
			_tf.backgroundColor = 0xFFFFEE;
			_tf.border = true;
			_tf.borderColor = 0xAAAA66;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(_tf);
		}
		
		public function set text(text : String) : void {
			_tf.wordWrap = false;
			_tf.text = text;
			if (_tf.textWidth > 140) {
				_tf.width = 140;
				_tf.wordWrap = true;
			}
		}
	}
}