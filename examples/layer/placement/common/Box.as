package layer.placement.common {
	import common.ColorUtil;
	import common.UII10N;
	import common.UIView;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.placement.PlacementUtils;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class Box extends UIView {
		private var _width : uint;
		private var _height : uint;
		private var _x : int;
		private var _y : int;
		private var _color : uint;
		private var _alpha : Number;
		private var _borderColor : uint;
		private var _placementAnchor : uint = PlacementAnchor.TOP_LEFT;
		
		public function Box(
			width : uint, height : uint, x : int, y : int,
			color : uint, alpha : Number, borderColor : uint
		) {
			_width = width;
			_height = height;
			_x = x;
			_y = y;
			_color = color;
			_alpha = alpha;
			_borderColor = borderColor;
			UII10N.i10n.invalidate(this);
		}
		
		override public function draw() : void {
			graphics.clear();
			
			// position
			super.x = _x;
			super.y = _y;
			
			// background
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_width, _height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = gradient = ColorUtil.getGradient(_color);
			with (graphics) {
				beginGradientFill(GradientType.LINEAR, gradient, [_alpha, _alpha], [0, 255], matrix);
				drawRect(0, 0, _width, _height);
			}
			
			// border
			with (graphics) {
				endFill();
				lineStyle(1, _borderColor);
				drawRect(0, 0, _width, _height);
			}

			// anchors
			var a : uint = 4;
			var a2 : uint = 8;
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
						drawRect(point.x - a2/2, point.y - a2/2, a2, a2);
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

		public function set placementAnchor(placementAnchor : uint) : void {
			_placementAnchor = placementAnchor;
			UII10N.i10n.invalidate(this);
		}

		public function get placementAnchor() : uint {
			return _placementAnchor;
		}
	}
}