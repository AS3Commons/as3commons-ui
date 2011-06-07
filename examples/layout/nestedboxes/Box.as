package layout.nestedboxes {
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Box extends Sprite {
		private var _depth : uint;
		private var _size : uint = 50;
		private var _width : uint;
		private var _height : uint;
		private var _gap : uint = 10;
		
		public function Box(...args) {
			// label
			var label : TextField = new TextField();
			label.defaultTextFormat = new TextFormat("_sans", 9);
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = args.shift();
			
			// depth = child depth + 1
			if (args.length) _depth = Box(args[0]).depth + 1;

			// calculate size depending on depth
			_width = Math.pow(2, _depth) * _size;
			if (_depth) _width += Math.pow(3, _depth) * _gap;
			_height = _width;
			if (_depth) _height += (Math.pow(2, _depth) - 1) * label.height;
			
			// box
			var color : uint = _depth % 2 ? 0xDDDDDD : 0xEEEEEE;
			with (graphics) {
				lineStyle(1, 0x666666);
				beginFill(color);
				drawRect(0, 0, _width, _height);
			}
			
			// layout label and children
			var v : VGroup = vgroup(
				label,
				
				hlayout(
					"marginX", _gap, "marginY", _gap,
					"maxItemsPerRow", 2,
					"hGap", _gap, "vGap", _gap,
					args
				)
			);
			v.layout(this);
		}
		
		override public function get width() : Number {
			return _width;
		}
		
		override public function get height() : Number {
			return _height;
		}

		public function get depth() : uint {
			return _depth;
		}
	}
}