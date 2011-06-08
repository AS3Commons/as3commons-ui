package org.as3commons.ui.layer.popup {

	import flash.display.DisplayObject;

	/**
	 * Popup data object.
	 * 
	 * @author Jens Struwe 02.02.2011
	 */
	public class PopUpData {
		
		/**
		 * The popup.
		 */
		private var _popUp : DisplayObject;

		/**
		 * The overlay.
		 */
		private var _modalOverlay : DisplayObject;

		/**
		 * PopUpData constructor.
		 * 
		 * @param popUp The popup.
		 * @param overlay The modal overlay.
		 */
		public function PopUpData(popUp : DisplayObject, overlay : DisplayObject = null) {
			_popUp = popUp;
			_modalOverlay = overlay;
		}
		
		/**
		 * <code>true</code> if the popup is modal.
		 */
		public function get isModal() : Boolean {
			return _modalOverlay != null;
		}

		/**
		 * The popup object.
		 */
		public function get popUp() : DisplayObject {
			return _popUp;
		}

		/**
		 * The modal overlay.
		 */
		public function set modalOverlay(modalOverlay : DisplayObject) : void {
			_modalOverlay = modalOverlay;
		}

		/**
		 * @private
		 */
		public function get modalOverlay() : DisplayObject {
			return _modalOverlay;
		}

	}
}
