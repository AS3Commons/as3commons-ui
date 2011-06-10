package layer.popup.alerttutorial.final {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AlertTutorial extends Sprite {
		private var _alertId : uint;

		public function AlertTutorial() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			Globals.popUpManager = new PopUpManager(container);
			Globals.popUpManager.modalOverlay = ModalOverlay;
			
			var button1 : Button = new Button();
			button1.setSize(70, 24);
			button1.addEventListener(ButtonEvent.CLICK, noticeHandler);
			button1.label = "Notice";
			
			var button2 : Button = new Button();
			button2.setSize(70, 24);
			button2.addEventListener(ButtonEvent.CLICK, confirmHandler);
			button2.label = "Confirm";
			
			hgroup("gap", 10, button1, button2).layout(this);
		}
		
		private function noticeHandler(event : ButtonEvent) : void {
			Alert.show(
				"Notice " + ++_alertId, "The information provided by this message box may help you to better understand the system of alerts and popups.",
				[null, null, "Close"],
				false, true,
				alertClickCallback, true
			);
		}
		
		private function confirmHandler(event : ButtonEvent) : void {
			Alert.show(
				"Confirm " + ++_alertId, "Please confirm, dismiss or cancel the progress. Note, this application will not delete files on your hard disk.",
				["Yes", "No", "Cancel"],
				true, false,
				alertClickCallback, true
			);
		}

		private function alertClickCallback(alert : AlertBox, event : String) : void {
			if (event != AlertBox.ALERT_CANCEL) {
				Alert.hide(alert, false);
				Alert.show(
					event.toUpperCase(), "The button \"" + event.toUpperCase() + "\" has been clicked. OK?",
					[null, null, "OK"],
					false, true,
					alertClickCallback, false
				);
			} else {
				Alert.hide(alert, true);
			}
		}
	}
}