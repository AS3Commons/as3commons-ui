package layer.tooltip.tooltiptutorial.step1 {
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Box extends Sprite {
		private static var _boxId : uint;
		private var _color : uint;
		private var _id : uint;
		private var _mousePosition : Point;

		public function Box(x : uint, y : uint, width : uint, height : uint, color : uint) {
			this.x = x;
			this.y = y;
			_color = color;
			_id = ++_boxId;

			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(width, height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = ColorUtil.getGradient(_color);

			with (graphics) {
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRoundRect(0, 0, width, height, 6, 6);
			}
			
			var tf : TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
			tf.text = "" + _id;
			tf.x = tf.y = 4;
			tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(tf);

			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		}

		private function mouseOverHandler(event : MouseEvent) : void {
			parent.addChild(this); // move to top
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

			point.x = Math.max(Globals.bounds.left, point.x);
			point.x = Math.min(Globals.bounds.right - width, point.x);
			point.y = Math.max(Globals.bounds.top, point.y);
			point.y = Math.min(Globals.bounds.bottom - height, point.y);

			x = point.x;
			y = point.y;
		}
	}
}