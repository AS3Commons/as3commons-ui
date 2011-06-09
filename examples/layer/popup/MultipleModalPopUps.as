package layer.popup {
	import common.ControlPanelBase;
	import layer.popup.common.AlertBox;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import flash.display.Sprite;
	
	public class MultipleModalPopUps extends ControlPanelBase {
		private var _popUpManager : PopUpManager;
		private var _alertId : uint;
		private var _startPosition : uint = 20;

		public function MultipleModalPopUps() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			
			var addButton : Button = new Button();
			addButton.setSize(50, 20);
			addButton.label = "add";
			addButton.addEventListener(ButtonEvent.CLICK, addHandler);
			addChild(addButton);
		}
		
		private function addHandler(event : ButtonEvent) : void {
			addPopUp();
		}
		
		private function alertCallback(alert : AlertBox, event : String) : void {
			if (event == AlertBox.ALERT_CANCEL) removePopUp(alert);
			else addPopUp();
		}

		private function addPopUp() : void {
			_startPosition += 30;
			if (_startPosition > 140) _startPosition = 50;

			var alert : AlertBox = new AlertBox(
				"Popup " + ++_alertId,
				"This is a modal popup window. Close this window by clicking the close button.",
				["Add", null, "Close"],
				alertCallback
			);

			alert.x = alert.y = _startPosition;
			_popUpManager.createPopUp(alert, false, true);
		}

		private function removePopUp(alert : AlertBox) : void {
			_popUpManager.removePopUp(alert);
		}
	}
}