package layer.placement.autocorrectinfo {
	import common.UII10N;
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.placement.PlacementAnchor;

	public class Tooltip extends Box {
		private var _sourcePlacementAnchor : uint;
		private var _placementHShift : int;
		private var _placementVShift : int;
		private var _tipSize : uint = 10;

		public function Tooltip(
			width : uint, height : uint, x : int, y : int,
			color : uint, alpha : Number, borderColor : uint,
			showAnchors : Boolean, dragEnabled : Boolean
		) {
			super(width, height, x, y, color, alpha, borderColor, showAnchors, dragEnabled);
		}

		public function set sourcePlacementAnchor(sourcePlacementAnchor : uint) : void {
			_sourcePlacementAnchor = sourcePlacementAnchor;
			UII10N.i10n.invalidate(this);
		}

		public function get sourcePlacementAnchor() : uint {
			return _sourcePlacementAnchor;
		}

		public function get placementHShift() : int {
			return _placementHShift;
		}

		public function set placementHShift(shift : int) : void {
			_placementHShift = shift;
			UII10N.i10n.invalidate(this);
		}
		
		public function get placementVShift() : int {
			return _placementVShift;
		}

		public function set placementVShift(shift : int) : void {
			_placementVShift = shift;
			UII10N.i10n.invalidate(this);
		}
		
		override public function draw() : void {
			graphics.clear();
			
			// position
			setPosition();
			
			// background
			setGradientFill();
			var backgroundY : uint = 0;
			if (PlacementAnchor.isBottom(_sourcePlacementAnchor)) backgroundY = _tipSize;
			var backgroundH : uint = _height;
			if (!PlacementAnchor.isMiddle(_sourcePlacementAnchor)) backgroundH -= _tipSize;
			with (graphics) {
				drawRoundRect(0, backgroundY, _width, backgroundH, 6, 6);
			}
			
			if (!PlacementAnchor.isMiddle(_sourcePlacementAnchor)) {
				// nose
				var noseX : int = _tipSize;
				if (PlacementAnchor.isCenter(_placementAnchor)) noseX = (_width - _tipSize) / 2;
				else if (PlacementAnchor.isRight(_placementAnchor)) noseX = _width - _tipSize * 2.5;
				noseX -= _placementHShift;
				noseX = Math.max(_tipSize, Math.min(noseX, _width - _tipSize * 2.5));
				
				var noseY : uint = _tipSize;
				//if (PlacementAnchor.isMiddle(_sourcePlacementAnchor)) noseY = (_height - _tipSize) / 2;
				//else
				if (PlacementAnchor.isTop(_sourcePlacementAnchor)) noseY = _height - _tipSize;
				
				var noseHeight : int = PlacementAnchor.isTop(_sourcePlacementAnchor) ? _tipSize : -_tipSize;
				
				with (graphics) {
					moveTo(noseX, noseY);
					lineTo(noseX + _tipSize * .75, noseY + noseHeight);
					lineTo(noseX + _tipSize * 1.5, noseY);
					lineTo(noseX, noseY);
				}
			}
		}
	}
}