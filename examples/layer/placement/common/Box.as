package layer.placement.common {
	import common.ColorUtil;
	import common.UII10N;
	import common.UIView;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.placement.PlacementUtils;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Box extends UIView {
		protected var _width : uint;
		protected var _height : uint;
		protected var _x : int;
		protected var _y : int;
		protected var _color : uint;
		protected var _alpha : Number;
		protected var _borderColor : uint;
		protected var _showAnchors : Boolean;
		protected var _dragEnabled : Boolean;
		protected var _placementAnchor : uint = PlacementAnchor.TOP_LEFT;
		private var _mousePosition : Point;
		private var _dragBounds : Rectangle;
		
		public function Box(
			width : uint, height : uint, x : int, y : int,
			color : uint, alpha : Number, borderColor : uint,
			showAnchors : Boolean, dragEnabled : Boolean
		) {
			_width = width || DefaultValues.width;
			_height = height || DefaultValues.height;
			_x = x;
			_y = y;
			_color = color;
			_alpha = alpha;
			_borderColor = borderColor;
			_showAnchors = showAnchors;
			_dragEnabled = dragEnabled;
			UII10N.i10n.invalidate(this);
			
			if (dragEnabled) {
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}

		override public function draw() : void {
			graphics.clear();
			
			// position
			setPosition();
			
			// background
			setGradientFill();
			with (graphics) {
				drawRect(0, 0, _width, _height);
			}
			
			// border
			with (graphics) {
				endFill();
				drawRect(0, 0, _width, _height);
			}

			// anchors
			if (_showAnchors) {
				var a : uint = 4;
				var a2 : uint = 7;
				var i : uint;
				var point : Point;
				with (graphics) {
					for (i; i < PlacementAnchor.anchors.length; i++) {
						// any
						beginFill(_borderColor);
						point = PlacementUtils.anchorToLocal(PlacementAnchor.anchors[i], this);
						drawRect(point.x - a/2, point.y - a/2, a, a);
						endFill();
						// selected
						if (PlacementAnchor.anchors[i] == _placementAnchor) {
							lineStyle(1, _borderColor);
							drawRect(point.x - a2/2, point.y - a2/2, a2, a2);
							lineStyle(undefined);
						}
					}
				}
			}
		}
		
		override public function set width(width : Number) : void {
			_width = width;
			UII10N.i10n.invalidate(this);
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set height(height : Number) : void {
			_height = height;
			UII10N.i10n.invalidate(this);
		}

		override public function get height() : Number {
			return _height;
		}
		
		override public function set x(x : Number) : void {
			_x = x;
			UII10N.i10n.invalidate(this);
		}
		
		override public function get x() : Number {
			return _x;
		}

		override public function set y(y : Number) : void {
			_y = y;
			UII10N.i10n.invalidate(this);
		}
		
		override public function get y() : Number {
			return _y;
		}

		public function set dragBounds(dragBounds : Rectangle) : void {
			_dragBounds = dragBounds;
		}

		public function set placementAnchor(placementAnchor : uint) : void {
			_placementAnchor = placementAnchor;
			UII10N.i10n.invalidate(this);
		}

		public function get placementAnchor() : uint {
			return _placementAnchor;
		}
		
		protected function setPosition() : void {
			super.x = _x;
			super.y = _y;
		}
		
		protected function setGradientFill() : void {
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_width, _height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = ColorUtil.getGradient(_color);
			with (graphics) {
				beginGradientFill(GradientType.LINEAR, gradient, [_alpha, _alpha], [0, 255], matrix);
			}
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
			if (_dragBounds) {
				point.x = Math.max(_dragBounds.left, point.x);
				point.x = Math.min(_dragBounds.right - _width, point.x);
				point.y = Math.max(_dragBounds.top, point.y);
				point.y = Math.min(_dragBounds.bottom - _height, point.y);
			}
			x = point.x;
			y = point.y;
			dispatchEvent(new Event("layerposition", true));
		}
	}
}