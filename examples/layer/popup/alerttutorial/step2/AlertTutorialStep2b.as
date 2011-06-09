package layer.popup.alerttutorial.step2 {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AlertTutorialStep2b extends Sprite {
		private var _popUpManager : PopUpManager;
		private var _alertId : uint;
		
		public function AlertTutorialStep2b() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			
			var button : Button = new Button();
			button.setSize(50, 20);
			button.addEventListener(ButtonEvent.CLICK, addHandler);
			button.label = "add";
			addChild(button);
			
			addPopUp();
		}

		private function addHandler(event : ButtonEvent) : void {
			addPopUp();
		}
		
		private function addPopUp() : void {
			var alert : AlertBox = new AlertBox(
				"Popup " +  ++_alertId,
				"This is a simple popup window. Click a button.",
				["one", "two", "tree"],
				alertClickCallback
			);
			alert.x = 10;
			alert.y = 40;
			_popUpManager.createPopUp(alert);
		}
		
		private function alertClickCallback(alert : AlertBox, event : String) : void {
			_popUpManager.removePopUp(alert);
		}
	}
}