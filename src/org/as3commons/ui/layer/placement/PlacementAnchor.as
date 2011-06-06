package org.as3commons.ui.layer.placement {

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class PlacementAnchor {
		
		public static const TOP_LEFT : uint = 1 + 8;
		public static const TOP : uint = 1 + 16;
		public static const TOP_RIGHT : uint = 1 + 32;
		public static const LEFT : uint = 2 + 8;
		public static const CENTER : uint = 2 + 16;
		public static const RIGHT : uint = 2 + 32;
		public static const BOTTOM_LEFT : uint = 4 + 8;
		public static const BOTTOM : uint = 4 + 16;
		public static const BOTTOM_RIGHT : uint = 4 + 32;
		
		private static const _TOP : uint = 1;
		private static const _MIDDLE : uint = 2;
		private static const _BOTTOM : uint = 4;
		private static const _LEFT : uint = 8;
		private static const _CENTER : uint = 16;
		private static const _RIGHT : uint = 32;
		
		public static const anchors : Array = [
			TOP_LEFT, TOP, TOP_RIGHT,
			LEFT, CENTER, RIGHT,
			BOTTOM_LEFT, BOTTOM, BOTTOM_RIGHT
		];
		
		public static function isTop(placement : uint) : Boolean {
			return (placement & _TOP) == _TOP;
		}
		
		public static function isMiddle(placement : uint) : Boolean {
			return (placement & _MIDDLE) == _MIDDLE;
		}
		
		public static function isBottom(placement : uint) : Boolean {
			return (placement & _BOTTOM) == _BOTTOM;
		}
		
		public static function isLeft(placement : uint) : Boolean {
			return (placement & _LEFT) == _LEFT;
		}
		
		public static function isCenter(placement : uint) : Boolean {
			return (placement & _CENTER) == _CENTER;
		}
		
		public static function isRight(placement : uint) : Boolean {
			return (placement & _RIGHT) == _RIGHT;
		}
		
	}
}
