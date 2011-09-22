package lifecycle.lifecycle.buttonexample {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleView;
	import flash.events.Event;

	public class Component extends LifeCycleView {
		public static const EVENT_RESIZE : String = "component_resize";

		protected const SIZE : String = "size";
		protected const ACTUAL_SIZE : String = "actual_size";

		private var _explicitWidth : uint;
		private var _explicitHeight : uint;
		private var _actualWidth : uint;
		private var _actualHeight : uint;
		
		override public function set width(width : Number) : void {
			if (width == _explicitWidth) return;
			_explicitWidth = width;
			_actualWidth = 0;
			invalidate(SIZE);
			dispatchEvent(new Event(EVENT_RESIZE));
		}
		
		override public function get width() : Number {
			return _explicitWidth ? _explicitWidth : _actualWidth;
		}

		override public function set height(height : Number) : void {
			if (height == _explicitHeight) return;
			_explicitHeight = height;
			_actualHeight = 0;
			invalidate(SIZE);
			dispatchEvent(new Event(EVENT_RESIZE));
		}

		override public function get height() : Number {
			return _explicitHeight ? _explicitHeight : _actualHeight;
		}
		
		protected function get explicitWidth() : uint {
			return _explicitWidth;
		}

		protected function get explicitHeight() : uint {
			return _explicitHeight;
		}

		protected function setActualWidth(actualWidth : uint, doInvalidate : Boolean = false) : void {
			if (_explicitWidth) return;
			if (actualWidth == _actualWidth) return;
			_actualWidth = actualWidth;
			if (doInvalidate) invalidate(ACTUAL_SIZE);
			dispatchEvent(new Event(EVENT_RESIZE));
		}

		protected function get actualWidth() : uint {
			return _actualWidth;
		}

		protected function setActualHeight(actualHeight : uint, doInvalidate : Boolean = false) : void {
			if (_explicitHeight) return;
			if (actualHeight == _actualHeight) return;
			_actualHeight = actualHeight;
			if (doInvalidate) invalidate(ACTUAL_SIZE);
			dispatchEvent(new Event(EVENT_RESIZE));
		}
		
		protected function get actualHeight() : uint {
			return _actualHeight;
		}
	}
}