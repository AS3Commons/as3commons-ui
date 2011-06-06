package org.as3commons.ui.layer.placement {

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class PlacementUtils {

		public static function localToGlobal(displayObject : DisplayObject) : Point {
			var point : Point = new Point(displayObject.x, displayObject.y);
			var parent : DisplayObject = displayObject.parent;
			while (parent) {
				point.x += parent.x;
				point.y += parent.y;
				parent = parent.parent;
			}
			return point;
		}

		public static function globalToLocal(global : Point, displayObject : DisplayObject) : Point {
			var point : Point = global.clone();
			var parent : DisplayObject = displayObject.parent;
			while (parent) {
				point.x -= parent.x;
				point.y -= parent.y;
				parent = parent.parent;
			}
			return point;
		}

		public static function anchorToLocal(anchor : uint, displayObject : DisplayObject) : Point {
			var point : Point = new Point();

			if (PlacementAnchor.isLeft(anchor)) {
				point.x = 0;
			} else if (PlacementAnchor.isCenter(anchor)) {
				point.x = Math.round(displayObject.width / 2);
			} else {
				point.x = displayObject.height;
			}

			if (PlacementAnchor.isTop(anchor)) {
				point.y = 0;
			} else if (PlacementAnchor.isMiddle(anchor)) {
				point.y = Math.round(displayObject.height / 2);
			} else {
				point.y = displayObject.height;
			}

			return point;
		}

	}
}
