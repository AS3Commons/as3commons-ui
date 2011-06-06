package org.as3commons.ui.utils {

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class UIUtils {

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

	}
}
