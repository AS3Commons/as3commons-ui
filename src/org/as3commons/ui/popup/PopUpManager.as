package org.as3commons.ui.popup {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.ui.popup.popup.DefaultModalOverlay;
	import org.as3commons.ui.popup.popup.PopUpData;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 02.02.2011
	 */
	public class PopUpManager {

		private var _container : Sprite;
		private var _width : uint;
		private var _height : uint;
		
		private var _ModalOverlay : Class;
		private var _popUps : LinkedMap;
		private var _numModalPopUps : uint;

		public function PopUpManager(container : Sprite) {
			if (!container.stage) throw new Error("The container must already be added to the display list.");

			_container = container;
			_width = _container.stage.stageWidth;
			_height = _container.stage.stageHeight;
			
			_popUps = new LinkedMap();
		}
		
		public function set modalOverlay(modalOverlay : Class) : void {
			_ModalOverlay = modalOverlay;
		}

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

		public function hasPopUp() : Boolean {
			return _popUps.size > 0;			
		}

		public function get numPopUps() : uint {
			return _popUps.size;			
		}

		public function hasModalPopUp() : Boolean {
			return _numModalPopUps > 0;			
		}

		public function get popUpOnTop() : DisplayObject {
			if (_container.numChildren) return _container.getChildAt(_container.numChildren - 1);
			return null;			
		}

		public function bringToFront(displayObject : DisplayObject) : void {
			if (!_popUps.hasKey(displayObject)) return;

			var popUpData : PopUpData = _popUps.itemFor(displayObject);
			if (popUpData.isModal) {
				_container.setChildIndex(popUpData.modalOverlay, _container.numChildren - 1);
			}
			_container.setChildIndex(displayObject, _container.numChildren - 1);
		}

		public function center(displayObject : DisplayObject) : void {
			displayObject.x = Math.round((_width - displayObject.width) / 2);
			displayObject.y = Math.round((_height - displayObject.height) / 2);
		}

		public function removePopUp(displayObject : DisplayObject) : void {
			if (!_popUps.hasKey(displayObject)) return;
			
			var popUpData : PopUpData = _popUps.removeKey(displayObject);
			if (popUpData.isModal) {
				_container.removeChild(popUpData.modalOverlay);
				_numModalPopUps--;			
			}
			_container.removeChild(displayObject);			
		}
		
		public function makeModal(displayObject : DisplayObject) : void {
			if (!_popUps.hasKey(displayObject)) return;

			var popUpData : PopUpData = _popUps.itemFor(displayObject);
			if (popUpData.isModal) return;
			
			var overlay : DisplayObject = createModalOverlay();
			_container.addChildAt(overlay, _container.getChildIndex(displayObject));
			popUpData.modalOverlay = overlay;
			_numModalPopUps++;
		}
		
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
		
		private function createModalOverlay() : DisplayObject {
			var overlay : DisplayObject = _ModalOverlay != null ? new _ModalOverlay() : new DefaultModalOverlay();
			overlay.width = _width;
			overlay.height = _height;
			return overlay;
		}

	}
}
