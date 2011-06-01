package popup.popup {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpcbeta.window.Window;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.popup.PopUpManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MultiplePopUps extends ControlPanelBase {
		private var _popUpManager : PopUpManager;
		private var _addButton : Button;
		private var _removeButton : Button;
		private var _windowId : uint;
		private var _startPosition : uint = 20;

		public function MultiplePopUps() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);

			_addButton = labelButton({
				label: "add",
				click: addHandler
			});
			
			_removeButton = labelButton({
				label: "remove",
				enabled: false,
				click: removeHandler
			});
			
			addChild(_addButton);

			hgroup(
				"gap", 6,
				_addButton,
				_removeButton
			).layout(this);
		}
		
		private function addHandler() : void {
			_startPosition += 30;
			if (_startPosition > 140) _startPosition = 50;

			var window : Window = window({
				title: "PopUp " + ++_windowId,
				minimise: false
			});
			window.x = window.y = _startPosition;
			window.addEventListener(MouseEvent.MOUSE_DOWN, windowClickHandler);

			_popUpManager.createPopUp(window);
			enableButtons();
		}

		private function removeHandler() : void {
			_popUpManager.removePopUp(_popUpManager.popUpOnTop);
			enableButtons();
		}

		private function windowClickHandler(event : MouseEvent) : void {
			_popUpManager.bringToFront(event.currentTarget as Window);
		}
		
		private function enableButtons() : void {
			_addButton.enabled = _popUpManager.numPopUps < 4; // max 4
			_removeButton.enabled = _popUpManager.numPopUps > 0;
		}
	}
}