package org.as3commons.ui.layer.popup {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 02.02.2011
	 */
	public class PopUpData {
		
		private var _popUp : DisplayObject;
		private var _modalOverlay : DisplayObject;

		public function PopUpData(popUp : DisplayObject, overlay : DisplayObject = null) {
			_popUp = popUp;
			_modalOverlay = overlay;
		}
		
		public function get isModal() : Boolean {
			return _modalOverlay != null;
		}

		public function get popUp() : DisplayObject {
			return _popUp;
		}

		public function set modalOverlay(modalOverlay : DisplayObject) : void {
			_modalOverlay = modalOverlay;
		}

		public function get modalOverlay() : DisplayObject {
			return _modalOverlay;
		}

	}
}
