package layer.placement.common {
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Box extends Sprite {
		private var _width : uint;
		private var _height : uint;
		private var _color : uint;
		private var _alpha : Number;
		private var _dragBounds : Rectangle;
		protected var _placementAnchor : uint;
		private var _mousePosition : Point;
		
		public function Box(
			width : uint, height : uint, x : int, y : int,
			color : uint, alpha : Number,
			placementAnchor : uint, dragBounds : Rectangle
		) {
			_width = width || DefaultValues.width;
			_height = height || DefaultValues.height;
			this.x = x;
			this.y = y;
			_color = color;
			_alpha = alpha;
			_placementAnchor = placementAnchor;
			_dragBounds = dragBounds;
			
			if (_dragBounds) addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			draw();
		}

		protected function draw() : void {
			graphics.clear();
			
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_width, _height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = ColorUtil.getGradient(_color);
			with (graphics) {
				beginGradientFill(GradientType.LINEAR, gradient, [_alpha, _alpha], [0, 255], matrix);
				drawRect(0, 0, _width, _height);
			}
		}
		
		override public function get width() : Number {
			return _width;
		}

		override public function get height() : Number {
			return _height;
		}
		
		public function setSize(width : uint, height : uint) : void {
			_width = width;
			_height = height;
			draw();
		}

		public function set placementAnchor(placementAnchor : uint) : void {
			_placementAnchor = placementAnchor;
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
			point.x = Math.min(_dragBounds.right - _width, point.x);
			point.y = Math.max(_dragBounds.top, point.y);
			point.y = Math.min(_dragBounds.bottom - _height, point.y);

			x = point.x;
			y = point.y;
			dispatchEvent(new Event("sourceposition", true));
		}
	}
}