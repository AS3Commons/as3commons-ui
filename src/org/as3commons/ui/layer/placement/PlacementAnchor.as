package org.as3commons.ui.layer.placement {

	import org.as3commons.ui.framework.core.as3commons_ui;

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class PlacementAnchor {
		
		use namespace as3commons_ui;
		
		public static const TOP_LEFT : uint = 1 + 8;
		public static const TOP : uint = 1 + 16;
		public static const TOP_RIGHT : uint = 1 + 32;
		public static const LEFT : uint = 2 + 8;
		public static const CENTER : uint = 2 + 16;
		public static const RIGHT : uint = 2 + 32;
		public static const BOTTOM_LEFT : uint = 4 + 8;
		public static const BOTTOM : uint = 4 + 16;
		public static const BOTTOM_RIGHT : uint = 4 + 32;
		
		as3commons_ui static const POSITION_TOP : uint = 1;
		as3commons_ui static const POSITION_MIDDLE : uint = 2;
		as3commons_ui static const POSITION_BOTTOM : uint = 4;
		as3commons_ui static const POSITION_LEFT : uint = 8;
		as3commons_ui static const POSITION_CENTER : uint = 16;
		as3commons_ui static const POSITION_RIGHT : uint = 32;
		
		public static const anchors : Array = [
			TOP_LEFT, TOP, TOP_RIGHT,
			LEFT, CENTER, RIGHT,
			BOTTOM_LEFT, BOTTOM, BOTTOM_RIGHT
		];
		
		public static function isTop(anchor : uint) : Boolean {
			return (anchor & POSITION_TOP) == POSITION_TOP;
		}
		
		public static function isMiddle(anchor : uint) : Boolean {
			return (anchor & POSITION_MIDDLE) == POSITION_MIDDLE;
		}
		
		public static function isBottom(anchor : uint) : Boolean {
			return (anchor & POSITION_BOTTOM) == POSITION_BOTTOM;
		}
		
		public static function isLeft(anchor : uint) : Boolean {
			return (anchor & POSITION_LEFT) == POSITION_LEFT;
		}
		
		public static function isCenter(anchor : uint) : Boolean {
			return (anchor & POSITION_CENTER) == POSITION_CENTER;
		}
		
		public static function isRight(anchor : uint) : Boolean {
			return (anchor & POSITION_RIGHT) == POSITION_RIGHT;
		}
		
	}
}
