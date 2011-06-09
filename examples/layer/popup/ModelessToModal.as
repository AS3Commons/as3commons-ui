package layer.popup {
	import common.ControlPanelBase;
	import layer.popup.common.AlertBox;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ModelessToModal extends ControlPanelBase {
		private var _popUpManager : PopUpManager;
		private var _alertId : uint;
		private var _startPosition : uint = 20	;

		public function ModelessToModal() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			_popUpManager.modalOverlay = ModalOverlay;

			var addButton : Button = new Button();
			addButton.setSize(50, 20);
			addButton.label = "add";
			addButton.addEventListener(ButtonEvent.CLICK, addHandler);
			addChild(addButton);
			
			addPopUp();
		}
		
		private function addHandler(event : ButtonEvent) : void {
			addPopUp();
		}
		
		private function alertCallback(alert : AlertBox, event : String) : void {
			if (event == AlertBox.ALERT_CANCEL) removePopUp(alert);
			else if (event == "modal") _popUpManager.makeModal(alert);
			else _popUpManager.makeModeless(alert);
		}

		private function alertClickHandler(event : MouseEvent) : void {
			if (event.target is Button) return;
			_popUpManager.bringToFront(event.currentTarget as AlertBox);
		}
		
		private function addPopUp() : void {
			_startPosition += 30;
			if (_startPosition > 140) _startPosition = 50;

			var alert : AlertBox = new CustomAlertBox(
				"Popup " + ++_alertId,
				"This is a popup window. You may set this window to be modal or modeless. Close this window by clicking the close button.",
				[null, null, "Close"],
				alertCallback
			);

			alert.x = alert.y = _startPosition;
			alert.addEventListener(MouseEvent.MOUSE_DOWN, alertClickHandler);
			_popUpManager.createPopUp(alert);
		}

		private function removePopUp(alert : AlertBox) : void {
			_popUpManager.removePopUp(alert);
		}
	}
}

import layer.popup.common.AlertBox;
import com.sibirjak.asdpc.button.Button;
import com.sibirjak.asdpc.button.ButtonEvent;
import flash.display.Sprite;

internal class ModalOverlay extends Sprite {
	public function ModalOverlay() {
		with (graphics) {
			clear();
			beginFill(0x000000, .3);
			drawRect(0, 0, 100, 100);
		}
	}
}

internal class CustomAlertBox extends AlertBox {
	public function CustomAlertBox(headline : String, text : String, buttons : Array, clickCallback : Function) {
		super(headline, text, buttons, clickCallback);
	}

	override protected function getCustomButton() : Button {
		var button : Button = new Button();
		button.setSize(60, 22);
		button.toggle = true;
		button.label = "Modal";
		button.selectedLabel = "Modeless";
		button.addEventListener(ButtonEvent.SELECTION_CHANGED, buttonSelectedHandler);
		return button;
	}
	
	private function buttonSelectedHandler(event : ButtonEvent) : void {
		if (Button(event.currentTarget).selected) {
			_clickCallback(this, "modal");
		} else {
			_clickCallback(this, "modeless");
		}
	}
}