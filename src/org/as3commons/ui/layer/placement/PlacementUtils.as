package org.as3commons.ui.layer.placement {

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class PlacementUtils {

		/**
		 * Returns the global stage position of the given display object.
		 * 
		 * <p>In difference to the built-in <code>localToGlobal()</code>, this
		 * method also works with overridden x and y properties of a given display
		 * object subclass.</p>
		 * 
		 * @param displayObject The object to get its global position.
		 * @param local Position used rather than the actual object's position.
		 * @return The object's global position.
		 */
		public static function localToGlobal(displayObject : DisplayObject, local : Point = null) : Point {
			var point : Point = local ? local.clone() : new Point(displayObject.x, displayObject.y);
			var parent : DisplayObject = displayObject.parent;
			while (parent) {
				point.x += parent.x;
				point.y += parent.y;
				parent = parent.parent;
			}
			return point;
		}

		/**
		 * Converts a stage position to a local position of the given display object.
		 * 
		 * <p>In difference to the built-in <code>globalToLocal()</code>, this
		 * method also works with objects not having a parent yet. In that case the
		 * method simply returns the given global position.</p>
		 * 
		 * @param global Position to convert.
		 * @param displayObject The object to get its local position.
		 * @return The object's local position.
		 */
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

		/**
		 * Returns the local position of the given anchor.
		 * 
		 * @param anchor Anchor to convert into a position.
		 * @param displayObject The object to apply the anchor to.
		 * @return The anchor's local position.
		 */
		public static function anchorToLocal(anchor : uint, displayObject : DisplayObject) : Point {
			var point : Point = new Point();

			if (PlacementAnchor.isLeft(anchor)) {
				// 0
			} else if (PlacementAnchor.isCenter(anchor)) {
				point.x = Math.round(displayObject.width / 2);
			} else {
				point.x = displayObject.width;
			}

			if (PlacementAnchor.isTop(anchor)) {
				// 0
			} else if (PlacementAnchor.isMiddle(anchor)) {
				point.y = Math.round(displayObject.height / 2);
			} else {
				point.y = displayObject.height;
			}

			return point;
		}

	}
}
