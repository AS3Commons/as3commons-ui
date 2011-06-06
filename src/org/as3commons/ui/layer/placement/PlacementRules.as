package org.as3commons.ui.layer.placement {

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class PlacementRules {
		
		public static const TOP_LEFT : uint = _TOP + _LEFT;
		public static const TOP : uint = _TOP + _CENTER;
		public static const TOP_RIGHT : uint = _TOP + _RIGHT;
		public static const LEFT : uint = _MIDDLE + _LEFT;
		public static const CENTER : uint = _MIDDLE + _CENTER;
		public static const RIGHT : uint = _MIDDLE + _RIGHT;
		public static const BOTTOM_LEFT : uint = _BOTTOM + _LEFT;
		public static const BOTTOM : uint = _BOTTOM + _CENTER;
		public static const BOTTOM_RIGHT : uint = _BOTTOM + _RIGHT;
		
		private static const _TOP : uint = 1;
		private static const _MIDDLE : uint = 2;
		private static const _BOTTOM : uint = 4;
		private static const _LEFT : uint = 8;
		private static const _CENTER : uint = 16;
		private static const _RIGHT : uint = 32;
		
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
