package lifecycle.lifecycle.common {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleView;
	import flash.events.Event;

	public class Component extends LifeCycleView {
		public static const EVENT_RESIZE : String = "component_resize";

		protected const SIZE : String = "size";

		private var _explicitWidth : uint;
		private var _explicitHeight : uint;
		private var _measuredWidth : uint;
		private var _measuredHeight : uint;
		
		override public function set width(width : Number) : void {
			if (width == _explicitWidth) return;
			_explicitWidth = width;
			_measuredWidth = 0;
			invalidate(SIZE);
			dispatchEvent(new Event(EVENT_RESIZE));
		}
		
		override public function get width() : Number {
			return _explicitWidth ? _explicitWidth : _measuredWidth;
		}

		override public function set height(height : Number) : void {
			if (height == _explicitHeight) return;
			_explicitHeight = height;
			_measuredHeight = 0;
			invalidate(SIZE);
			dispatchEvent(new Event(EVENT_RESIZE));
		}

		override public function get height() : Number {
			return _explicitHeight ? _explicitHeight : _measuredHeight;
		}
		
		protected function get explicitWidth() : uint {
			return _explicitWidth;
		}

		protected function get explicitHeight() : uint {
			return _explicitHeight;
		}

		protected function set measuredWidth(measuredWidth : uint) : void {
			if (_explicitWidth) return;
			if (measuredWidth == _measuredWidth) return;
			_measuredWidth = measuredWidth;
			dispatchEvent(new Event(EVENT_RESIZE));
		}

		protected function get actualWidth() : uint {
			return _measuredWidth;
		}

		protected function set measuredHeight(measuredHeight : uint) : void {
			if (_explicitHeight) return;
			if (measuredHeight == _measuredHeight) return;
			_measuredHeight = measuredHeight;
			dispatchEvent(new Event(EVENT_RESIZE));
		}
		
		protected function get actualHeight() : uint {
			return _measuredHeight;
		}
	}
}