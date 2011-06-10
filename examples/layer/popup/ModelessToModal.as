package layer.popup {
	import layer.popup.common.AlertBox;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ModelessToModal extends Sprite {
		protected var _popUpManager : PopUpManager;
		private var _alertId : uint;
		private var _startPosition : uint = 20	;

		public function ModelessToModal() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			_popUpManager.modalOverlay = ModalOverlay;
			_popUpManager.popUpCallback = setText;
			_popUpManager.modalPopUpCallback = setText;

			var addButton : Button = new Button();
			addButton.setSize(60, 22);
			addButton.label = "modeless";
			addButton.addEventListener(ButtonEvent.CLICK, addHandler);
			
			var addModalButton : Button = new Button();
			addModalButton.setSize(50, 22);
			addModalButton.label = "modal";
			addModalButton.addEventListener(ButtonEvent.CLICK, addModalHandler);
			
			var tf : TextField = new TextField();
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat("_sans", 11, 0x444444);
			setText();
			
			hgroup("gap", 5, "vAlign", Align.MIDDLE, addButton, addModalButton, tf).layout(this);
			
			function setText() : void {
				tf.text = "Popups: "
					+ _popUpManager.numPopUps
					+ " overall and "
					+ _popUpManager.numModalPopUps + " modal. ";
				tf.appendText("Focus: "
					+ (_popUpManager.focusEnabled(root) ? "enabled" : "disabled")
					+ ".");
			}

			addPopUp();
		}
		
		private function addHandler(event : ButtonEvent) : void {
			addPopUp();
		}
		
		private function addModalHandler(event : ButtonEvent) : void {
			addPopUp(true);
		}

		private function addPopUp(modal : Boolean = false) : void {
			_startPosition += 30;
			if (_startPosition > 140) _startPosition = 50;
			
			var alert : AlertBox = new CustomAlertBox(
				"Popup " + ++_alertId,
				"This is a popup window. You may set this window to be modal or modeless. Close this window by clicking the close button.",
				[null, null, "Close"],
				alertCallback, modal
			);

			alert.x = alert.y = _startPosition;
			alert.addEventListener(MouseEvent.MOUSE_DOWN, alertClickHandler);
			_popUpManager.createPopUp(alert, false, modal);
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
	private var _modal : Boolean;
	
	public function CustomAlertBox(headline : String, text : String, buttons : Array, clickCallback : Function, modal : Boolean) {
		_modal = modal;
		super(headline, text, buttons, clickCallback);
	}

	override protected function getCustomButton() : Button {
		var button : Button = new Button();
		button.setSize(60, 22);
		button.toggle = true;
		button.selected = _modal;
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