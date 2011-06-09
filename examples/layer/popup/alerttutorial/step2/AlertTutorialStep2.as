package layer.popup.alerttutorial.step2 {
	import org.as3commons.ui.layer.PopUpManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class AlertTutorialStep2 extends Sprite {
		private var _tf : TextField;
		private var _popUpManager : PopUpManager;
		
		public function AlertTutorialStep2() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("_sans", 11);
			_tf.text = "Click a button";
			addChild(_tf);
			
			var alert : AlertBox = new AlertBox(
				"Popup",
				"This is a simple popup window. Click a button.",
				["one", "two", "tree"],
				info
			);
			alert.x = 10;
			alert.y = 40;
			_popUpManager.createPopUp(alert);
		}
		
		private function info(alert : AlertBox, event : String) : void {
			_tf.text = event;
		}
	}
}