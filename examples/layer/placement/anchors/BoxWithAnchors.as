package layer.placement.anchors {
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.placement.PlacementUtils;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BoxWithAnchors extends Box {
		private var _anchorColor : uint;

		public function BoxWithAnchors(
			width : uint, height : uint, x : int, y : int,
			color : uint, alpha : Number, anchorColor : uint,
			placementAnchor : uint, dragBounds : Rectangle
		) {
			super(width, height, x, y, color, alpha, placementAnchor, dragBounds);
			_anchorColor = anchorColor;
		}
		
		override protected function draw() : void {
			super.draw();

			var a : uint = 4;
			var a2 : uint = 7;
			var i : uint;
			var point : Point;
			with (graphics) {
				for (i; i < PlacementAnchor.anchors.length; i++) {
					// any
					beginFill(_anchorColor);
					point = PlacementUtils.anchorToLocal(PlacementAnchor.anchors[i], this);
					drawRect(point.x - a/2, point.y - a/2, a, a);
					endFill();
					// selected
					if (PlacementAnchor.anchors[i] == _placementAnchor) {
						lineStyle(1, _anchorColor);
						drawRect(point.x - a2/2, point.y - a2/2, a2, a2);
						lineStyle(undefined);
					}
				}
			}
		}
		
		override public function set placementAnchor(placementAnchor : uint) : void {
			super.placementAnchor = placementAnchor;
			draw();
		}
	}
}