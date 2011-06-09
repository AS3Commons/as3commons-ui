package layer.popup.alerttutorial.step3 {
	import layer.popup.alerttutorial.step3.AlertBox;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AlertTutorialStep3b extends Sprite {
		private var _popUpManager : PopUpManager;
		private var _alertId : uint;
		
		public function AlertTutorialStep3b() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			
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
			var alert : AlertBox = new AlertBox(
				"Popup " +  ++_alertId,
				"This is a simple popup window. Click the close button to remove this popup.",
				[null, null, "Close"],
				alertClickCallback
			);
			_popUpManager.createPopUp(alert, true);

			alert.watchClickOutside(function() : void {
				alert.unwatchClickOutside();
				_popUpManager.removePopUp(alert);
			});
		}
		
		private function confirmHandler(event : ButtonEvent) : void {
			var alert : AlertBox = new AlertBox(
				"Popup " +  ++_alertId,
				"This is a modal popup window. Click a button to remove this popup.",
				["Yes", "No", "Cancel"],
				alertClickCallback
			);
			_popUpManager.createPopUp(alert, true, true);
		}
		
		private function alertClickCallback(alert : AlertBox, event : String) : void {
			alert.unwatchClickOutside();
			_popUpManager.removePopUp(alert);
		}
	}
}