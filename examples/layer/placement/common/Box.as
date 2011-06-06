package layer.placement.common {
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Box extends Sprite {
		private var _width : uint;
		private var _height : uint;
		private var _x : int;
		private var _y : int;
		private var _color : uint;
		private var _alpha : Number;
		private var _borderColor : uint;
		
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
			BoxI10N.i10n.invalidate(this);
		}
		
		public function draw() : void {
			// position
			x = _x;
			y = _y;
			
			graphics.clear();
			
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
			with (graphics) {
				beginFill(_borderColor);
				drawRect(-a/2, -a/2, a, a);
				drawRect(Math.round(_width/2) - a/2, -a/2, a, a);
				drawRect(width - a/2, -a/2, a, a);

				drawRect(-a/2, Math.round(_height/2) - a/2, a, a);
				drawRect(Math.round(_width/2) - a/2, Math.round(_height/2) - a/2, a, a);
				drawRect(width - a/2, Math.round(_height/2) - a/2, a, a);

				drawRect(-a/2, _height - a/2, a, a);
				drawRect(Math.round(_width/2) - a/2, _height - a/2, a, a);
				drawRect(width - a/2, _height - a/2, a, a);
			}
		}
		
		override public function set width(width : Number) : void {
			_width = width;
			BoxI10N.i10n.invalidate(this);
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set height(height : Number) : void {
			_height = height;
			BoxI10N.i10n.invalidate(this);
		}

		override public function get height() : Number {
			return _height;
		}
		
		public function moveTo(x : int, y : int) : void {
			_x = x;
			_y = y;
			BoxI10N.i10n.invalidate(this);
		}
		
		override public function get x() : Number {
			return _x;
		}

		override public function get y() : Number {
			return _y;
		}
	}
}