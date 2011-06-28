package org.as3commons.ui.layer {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.ui.layer.popup.DefaultModalOverlay;
	import org.as3commons.ui.layer.popup.PopUpData;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

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
		 * Modal overlay template.
		 */
		private var _ModalOverlay : Class;

		/**
		 * Callback invoked after a popup has been added or removed.
		 */
		private var _popUpCallback : Function;

		/**
		 * Callback invoked after a modal popup has been added or removed.
		 */
		private var _modalPopUpCallback : Function;

		/**
		 * Stage width.
		 */
		private var _width : uint;

		/**
		 * Stage height.
		 */
		private var _height : uint;
		
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
		 * <p>The <code>PopUpManager</code> will add all popups to the specified
		 * container. The container should be positioned at (0,0) on the stage.</p>
		 * 
		 * TODO Remove contructor argument to be able to run this class with a singleton manager. 
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
		 * Optional method to explicitly set the popup container size.
		 * 
		 * <p>To calculate the centered position and size a modal overlay the PopUpManager
		 * uses by default the stage's <code>stageWidth</code> and <code>stageHeight</code>
		 * properties. In certain cases these properties may not be set propertly at the
		 * time of instantiation. Is is possible to specify a size using this method.</p>
		 * 
		 * @param width The popup container width.
		 * @param height The popup container height.
		 */
		public function setSize(width : uint, height : uint) : void {
			_width = width;
			_height = height;
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
		 * Callback invoked after a popup has been added or removed.
		 */
		public function set popUpCallback(popUpCallback : Function) : void {
			_popUpCallback = popUpCallback;
		}

		/**
		 * Callback invoked after a modal popup has been added or removed.
		 * 
		 * <p>Also invoked when a modeless popup is turned into a modal one or
		 * vice versa.</p>
		 */
		public function set modalPopUpCallback(modalPopUpCallback : Function) : void {
			_modalPopUpCallback = modalPopUpCallback;
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
			
			if (_popUpCallback != null) _popUpCallback();
			if (modal && _modalPopUpCallback != null) _modalPopUpCallback();
		}

		/**
		 * <code>true</code> if popups are present.
		 * 
		 * <p>If a display object is given, the method will check if that
		 * object is an active popup.</p>
		 * 
		 * @param displayObject The object to test if it is an active popup.
		 * @return <code>true</code> if popups are present.
		 */
		public function hasPopUp(displayObject : DisplayObject = null) : Boolean {
			if (displayObject) return _popUps.hasKey(displayObject);
			return _popUps.size > 0;			
		}

		/**
		 * <code>true</code> if at least one modal popup is present.
		 * 
		 * <p>If a display object is given, the method will check if that
		 * object is an active modal popup.</p>
		 * 
		 * @param displayObject The object to test if it is an active modal popup.
		 * @return <code>true</code> if at least one modal popup is present.
		 */
		public function hasModalPopUp(displayObject : DisplayObject = null) : Boolean {
			if (displayObject) {
				var popUpData : PopUpData = _popUps.itemFor(displayObject);
				if (!popUpData) return false;
				return popUpData.isModal;
			}
			return _numModalPopUps > 0;	
		}

		/**
		 * Number of popups added.
		 */
		public function get numPopUps() : uint {
			return _popUps.size;			
		}

		/**
		 * Number of modal popups added.
		 */
		public function get numModalPopUps() : uint {
			return _numModalPopUps;
		}

		/**
		 * Tests whether the given object is allowed to be focused by key or mouse.
		 * 
		 * <p>Checks if the object is placed underneath a modal popup and returns then <code>false</code>.</p>
		 * 
		 * @param displayObject The object to test.
		 * @return <code>true</code> if the object can be focused.
		 */
		public function focusEnabled(displayObject : DisplayObject) : Boolean {
			if (!displayObject) return false;
			if (!displayObject.stage) return false;
			
			var center : Point = new Point(displayObject.width / 2, displayObject.height / 2);
			var global : Point = displayObject.localToGlobal(center);
			var objects : Array = displayObject.stage.getObjectsUnderPoint(global);
			objects.reverse();
			
			for each (var object : DisplayObject in objects) {
				// the object to test is reached
				if (object == displayObject) return true;
				
				if (object.parent == _container) {
					var data : PopUpData = _popUps.itemFor(object);
					if (!data) return false; // overlay
					if (data && data.isModal) return false; // modal pop up
				}
			}

			return true;
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

			if (_popUpCallback != null) _popUpCallback();
			if (popUpData.isModal && _modalPopUpCallback != null) _modalPopUpCallback();
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
			if (_modalPopUpCallback != null) _modalPopUpCallback();
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
			if (_modalPopUpCallback != null) _modalPopUpCallback();
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
