package layer.placement.tooltipplacement {
	import common.ColorUtil;
	import layer.placement.common.DefaultValues;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.placement.UsedPlacement;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class ToolTip extends Sprite {
		private var _width : uint;
		private var _height : uint;
		private var _color : uint;
		private var _alpha : Number;
		private var _usedPlacement : UsedPlacement;
		private var _noseSize : uint = 10;

		public function ToolTip(
			color : uint, alpha : Number
		) {
			_color = color;
			_alpha = alpha;

			_width = DefaultValues.width;
			_height = DefaultValues.height;
		}

		public function set usedPlacement(usedPlacement : UsedPlacement) : void {
			_usedPlacement = usedPlacement;
			draw();
		}
		
		override public function get width() : Number {
			return _width;
		}

		override public function get height() : Number {
			return _height;
		}

		public function setSize2(width : uint, height : uint) : void {
			_width = width;
			_height = height;
			draw();
		}

		protected function draw() : void {
			graphics.clear();
			
			// background
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_width, _height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = ColorUtil.getGradient(_color);

			var backgroundY : uint = 0;
			if (PlacementAnchor.isBottom(_usedPlacement.sourceAnchor)) backgroundY = _noseSize;
			var backgroundH : uint = _height;
			if (!PlacementAnchor.isMiddle(_usedPlacement.sourceAnchor)) backgroundH -= _noseSize;
			with (graphics) {
				beginGradientFill(GradientType.LINEAR, gradient, [_alpha, _alpha], [0, 255], matrix);
				drawRoundRect(0, backgroundY, _width, backgroundH, 6, 6);
			}
			
			// nose
			if (!PlacementAnchor.isMiddle(_usedPlacement.sourceAnchor)) {
				var noseX : int = _noseSize;
				if (PlacementAnchor.isCenter(_usedPlacement.layerAnchor)) noseX = (_width - _noseSize) / 2;
				else if (PlacementAnchor.isRight(_usedPlacement.layerAnchor)) noseX = _width - _noseSize * 2.5;
				noseX -= _usedPlacement.hShift;
				noseX = Math.max(_noseSize, Math.min(noseX, _width - _noseSize * 2.5));
				
				var noseY : uint = PlacementAnchor.isTop(_usedPlacement.sourceAnchor) ? _height - _noseSize : _noseSize;
				var noseHeight : int = PlacementAnchor.isTop(_usedPlacement.sourceAnchor) ? _noseSize : -_noseSize;
				
				with (graphics) {
					moveTo(noseX, noseY);
					lineTo(noseX + _noseSize * .75, noseY + noseHeight);
					lineTo(noseX + _noseSize * 1.5, noseY);
					lineTo(noseX, noseY);
				}
			}
		}
	}
}