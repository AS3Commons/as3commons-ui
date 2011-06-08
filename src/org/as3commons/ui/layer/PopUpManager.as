package org.as3commons.ui.layer {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.ui.layer.popup.DefaultModalOverlay;
	import org.as3commons.ui.layer.popup.PopUpData;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * Popup management class.
	 * 
	 * <p>Adds, removes and places modeless or modal popups.</p>
	 * 
	 * @author Jens Struwe 02.02.2011
	 */
	public class PopUpManager {

		/**
		 * The popup container.
		 */
		private var _container : Sprite;

		/**
		 * Stage width.
		 */
		private var _width : uint;

		/**
		 * Stage height.
		 */
		private var _height : uint;
		
		/**
		 * Modal overlay template.
		 */
		private var _ModalOverlay : Class;

		/**
		 * List of all popups added.
		 */
		private var _popUps : LinkedMap;

		/**
		 * Number of modal popups.
		 */
		private var _numModalPopUps : uint;

		/**
		 * PopUpManager constructor.
		 * 
		 * @param container Popup container.
		 */
		public function PopUpManager(container : Sprite) {
			if (!container.stage) throw new Error("The container must already be added to the display list.");

			_container = container;
			_width = _container.stage.stageWidth;
			_height = _container.stage.stageHeight;
			
			_popUps = new LinkedMap();
		}
		
		/**
		 * Modal overlay template.
		 * 
		 * <p>An instance of this class is created with each added modal popup.</p>
		 */
		public function set modalOverlay(modalOverlay : Class) : void {
			_ModalOverlay = modalOverlay;
		}

		/**
		 * Creates a popup.
		 * 
		 * @param displayObject The popup content.
		 * @param centerPopUp Centers the popup if <code>true</code>.
		 * @param modal Modal popup if <code>true</code>.
		 */
		public function createPopUp(displayObject : DisplayObject, centerPopUp : Boolean = false, modal : Boolean = false) : void {
			if (_popUps.hasKey(displayObject)) return;
			
			var overlay : DisplayObject;
			
			if (modal) {
				overlay = createModalOverlay();
				_container.addChild(overlay);
				_numModalPopUps++;
			}
			
			_popUps.add(displayObject, new PopUpData(displayObject, overlay));
			_container.addChild(displayObject);

			if (centerPopUp) center(displayObject);
		}

		/**
		 * <code>true</code> if popups are present.
		 * 
		 * @return <code>true</code> if popups are present.
		 */
		public function hasPopUp() : Boolean {
			return _popUps.size > 0;			
		}

		/**
		 * Number of popups added.
		 */
		public function get numPopUps() : uint {
			return _popUps.size;			
		}

		/**
		 * <code>true</code> if at least one modal popup is present.
		 * 
		 * @return <code>true</code> if at least one modal popup is present.
		 */
		public function hasModalPopUp() : Boolean {
			return _numModalPopUps > 0;			
		}

		/**
		 * Returns the top popup.
		 * 
		 * @return The top popup or <code>null</code> if no popups are present.
		 */
		public function get popUpOnTop() : DisplayObject {
			if (_container.numChildren) return _container.getChildAt(_container.numChildren - 1);
			return null;			
		}

		/**
		 * Brings the specified popup to front.
		 * 
		 * <p>Aborts if the object is no present popup.</p>
		 * 
		 * @param displayObject The popup to bring to front.
		 */
		public function bringToFront(displayObject : DisplayObject) : void {
			if (!_popUps.hasKey(displayObject)) return;

			var popUpData : PopUpData = _popUps.itemFor(displayObject);
			if (popUpData.isModal) {
				_container.setChildIndex(popUpData.modalOverlay, _container.numChildren - 1);
			}
			_container.setChildIndex(displayObject, _container.numChildren - 1);
		}

		/**
		 * Centers the specified object.
		 * 
		 * @param displayObject The popup to center.
		 */
		public function center(displayObject : DisplayObject) : void {
			displayObject.x = Math.round((_width - displayObject.width) / 2);
			displayObject.y = Math.round((_height - displayObject.height) / 2);
		}

		/**
		 * Removes a popup.
		 * 
		 * <p>Aborts if the object is no present popup.</p>
		 * 
		 * @param displayObject The popup to remove.
		 */
		public function removePopUp(displayObject : DisplayObject) : void {
			if (!_popUps.hasKey(displayObject)) return;
			
			var popUpData : PopUpData = _popUps.removeKey(displayObject);
			if (popUpData.isModal) {
				_container.removeChild(popUpData.modalOverlay);
				_numModalPopUps--;			
			}
			_container.removeChild(displayObject);			
		}
		
		/**
		 * Turns a modeless into a modal popup.
		 * 
		 * <p>Aborts if the object is no present modeless popup.</p>
		 * 
		 * @param displayObject The modeless popup to make modal.
		 */
		public function makeModal(displayObject : DisplayObject) : void {
			if (!_popUps.hasKey(displayObject)) return;

			var popUpData : PopUpData = _popUps.itemFor(displayObject);
			if (popUpData.isModal) return;
			
			var overlay : DisplayObject = createModalOverlay();
			_container.addChildAt(overlay, _container.getChildIndex(displayObject));
			popUpData.modalOverlay = overlay;
			_numModalPopUps++;
		}
		
		/**
		 * Turns a modal into a modeless popup.
		 * 
		 * <p>Aborts if the object is no present modal popup.</p>
		 * 
		 * @param displayObject The modal popup to make modeless.
		 */
		public function makeModeless(displayObject : DisplayObject) : void {
			if (!_popUps.hasKey(displayObject)) return;

			var popUpData : PopUpData = _popUps.itemFor(displayObject);
			if (!popUpData.isModal) return;
			
			_container.removeChild(popUpData.modalOverlay);
			popUpData.modalOverlay = null;
			_numModalPopUps--;
		}
		
		/*
		 * Private
		 */
		
		/**
		 * Creates a modal overlay instance.
		 */
		private function createModalOverlay() : DisplayObject {
			var overlay : DisplayObject = _ModalOverlay != null ? new _ModalOverlay() : new DefaultModalOverlay();
			overlay.width = _width;
			overlay.height = _height;
			return overlay;
		}

	}
}
