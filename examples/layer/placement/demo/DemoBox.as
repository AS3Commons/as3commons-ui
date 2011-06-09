package layer.placement.demo {
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class DemoBox extends Sprite {
		private var _id : String;
		private var _dragBounds : Rectangle;
		private var _mousePosition : Point;
		private var _tf : TextField;
		private var _border : Shape;

		public function DemoBox(
			id : String,
			x : uint, y : uint, width : uint, height : uint,
			color : uint, alpha : Number, dragBounds : Rectangle
		) {
			_id = id;
			this.x = x;
			this.y = y;
			_dragBounds = dragBounds;

			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(width, height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = ColorUtil.getGradient(color);

			with (graphics) {
				beginGradientFill(GradientType.LINEAR, gradient, [alpha, alpha], [0, 255], matrix);
				drawRect(0, 0, width, height);
			}
			
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("_sans", 10, 0x444444);
			_tf.text = _id;
			_tf.x = _tf.y = 2;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(_tf);
			
			_border = new Shape();
			with (_border.graphics) {
				lineStyle(1, color);
				drawRect(0.5, 0.5, width - 1, height - 1);
			}
			_border.visible = false;
			addChild(_border);
			
			mouseChildren = false;
			if (dragBounds) addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		public function set border(border : Boolean) : void {
			_border.visible = border;
		}

		public function setInfo(hShift : int, vShift : int, hSwapped : Boolean, vSwapped : Boolean) : void {
			var text : String = _id;
			if (hShift || vShift) {
				text += "\n" + hShift + "," + vShift;
			}
			if (hSwapped || vSwapped) {
				text += "\n";
				if (hSwapped) {
					text += "-H";
					if (vSwapped) text += ",";
				}
				if (vSwapped) text += "-V";
			}
			_tf.text = text;
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			_mousePosition = new Point(mouseX, mouseY);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseMoveHandler(event : MouseEvent) : void {
			var point : Point = new Point(event.stageX, event.stageY);
			point.x -= _mousePosition.x;
			point.y -= _mousePosition.y;
			point = parent.globalToLocal(point);

			point.x = Math.max(_dragBounds.left, point.x);
			point.x = Math.min(_dragBounds.right - width, point.x);
			point.y = Math.max(_dragBounds.top, point.y);
			point.y = Math.min(_dragBounds.bottom - height, point.y);

			x = point.x;
			y = point.y;
			dispatchEvent(new Event("sourceposition", true));
		}
	}
}