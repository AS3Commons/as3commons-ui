package layout.showcase.base {

	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpcbeta.core.managers.PopUpManager;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	/**
	 * @author Jens Struwe 29.03.2011
	 */
	public class WindowContainer extends View {

		private static var _instance : WindowContainer;

		private var _draggingWindow : Window;
		
		public static function getInstance() : WindowContainer {
			if (!_instance) _instance = new WindowContainer();
			return _instance;
		}

		override public function addChild(window : DisplayObject) : DisplayObject {
			super.addChild(window);
			
			window.addEventListener(MouseEvent.ROLL_OVER, windowRollOverHandler);
			window.addEventListener(MouseEvent.ROLL_OUT, windowRollOutHandler);
			window.addEventListener(MouseEvent.MOUSE_DOWN, windowMouseDownHandler);

			window.addEventListener(WindowEvent.START_DRAG, windowStartDragHandler);
			window.addEventListener(WindowEvent.STOP_DRAG, windowStopDragHandler);
			window.addEventListener(WindowEvent.RESTORE_START, windowStartRestoreHandler);
			return window;
		}

		override protected function cleanUpCalled() : void {
			
			var i : int = -1;
			var window : Window;
			while (++i < numChildren) {
				window = getChildAt(i) as Window;
				window.removeEventListener(MouseEvent.ROLL_OVER, windowRollOverHandler);
				window.removeEventListener(MouseEvent.ROLL_OUT, windowRollOutHandler);
				window.removeEventListener(MouseEvent.MOUSE_DOWN, windowMouseDownHandler);

				window.removeEventListener(WindowEvent.START_DRAG, windowStartDragHandler);
				window.removeEventListener(WindowEvent.STOP_DRAG, windowStopDragHandler);
				window.removeEventListener(WindowEvent.RESTORE_START, windowStartRestoreHandler);
			}
			
		}

		private function windowRollOverHandler(event : MouseEvent) : void {
			if (!_draggingWindow) {
				
				var window : Window = event.currentTarget as Window;

				if (_lockTopWindow) {
					if (_lockTopWindow == window) _lockTopWindow = null;
					else return;
				}
				
				bringToFront(window);
			}
		}
		
		private var _lockTopWindow : Window;
		
		private function windowRollOutHandler(event : MouseEvent) : void {
			if (!_draggingWindow) {
				var window : Window = event.currentTarget as Window;
				if (PopUpManager.getInstance().hasPopUp()) {
					_lockTopWindow = window;
				}
			}
		}
		
		private function windowMouseDownHandler(event : MouseEvent) : void {
			if (_lockTopWindow) {
				_lockTopWindow = null;
				var window : Window = event.currentTarget as Window;
				if (_lockTopWindow != window) bringToFront(window);
			}
			
		}

		private function bringToFront(window : Window) : void {
			var container : DisplayObjectContainer = window.parent;
			container.setChildIndex(window, container.numChildren - 1);
		}

		private function windowStartDragHandler(event : WindowEvent) : void {
			var window : Window = event.currentTarget as Window;
			bringToFront(window);
			
			_draggingWindow = window;
		}

		private function windowStopDragHandler(event : WindowEvent) : void {
			
			if (_draggingWindow.y < 30) _draggingWindow.y = 30;
			
			_draggingWindow = null;
		}

		private function windowStartRestoreHandler(event : WindowEvent) : void {
			var window : Window = event.currentTarget as Window;
			bringToFront(window);
		}

	}
}
