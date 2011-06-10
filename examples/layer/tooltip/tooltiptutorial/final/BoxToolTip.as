package layer.tooltip.tooltiptutorial.final {
	import common.ColorUtil;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class BoxToolTip extends Sprite {
		private var _tf : TextField;
		private var _noseSize : uint = 10;
		
		private var _ownerAnchor : uint;
		private var _toolTipAnchor : uint;
		private var _hShift : int;

		public function BoxToolTip() {
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("_sans", 10, 0x666666);
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.x = _tf.y = 2;
			addChild(_tf);
		}
		
		override public function get width() : Number {
			return _tf.textWidth + 8;
		}

		override public function get height() : Number {
			return _tf.textHeight + 8 + _noseSize;
		}

		internal function set text(text : String) : void {
			_tf.wordWrap = false;
			_tf.text = text;
			if (_tf.textWidth > 140) {
				_tf.width = 140;
				_tf.wordWrap = true;
			}
		}

		internal function setPlacementProperties(ownerAnchor : uint, toolTipAnchor : uint, hShift : int) : void {
			_ownerAnchor = ownerAnchor;
			_toolTipAnchor = toolTipAnchor;
			_hShift = hShift;
		}

		internal function draw() : void {
			_tf.y = PlacementAnchor.isTop(_ownerAnchor) ? 2 : _noseSize + 2;
			drawBackground();
		}

		private function drawBackground() : void {
			graphics.clear();
			
			// fill
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(width, height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = ColorUtil.getGradient(0xFFEE11);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);

			// background
			var bgY : uint = 0;
			if (PlacementAnchor.isBottom(_ownerAnchor)) bgY = _noseSize;
			graphics.drawRoundRect(0, bgY, width, height - _noseSize, 6, 6);

			// nose
			if (!PlacementAnchor.isMiddle(_ownerAnchor)) {
				var noseX : int = _noseSize;
				if (PlacementAnchor.isCenter(_toolTipAnchor)) noseX = (width - _noseSize) / 2;
				else if (PlacementAnchor.isRight(_toolTipAnchor)) noseX = width - _noseSize * 2.5;
				noseX -= _hShift;
				noseX = Math.max(_noseSize, Math.min(noseX, width - _noseSize * 2.5));
				
				var noseY : uint = PlacementAnchor.isTop(_ownerAnchor) ? height - _noseSize : _noseSize;
				var noseHeight : int = PlacementAnchor.isTop(_ownerAnchor) ? _noseSize : -_noseSize;
				
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