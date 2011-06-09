package layer.popup.alerttutorial.step1 {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class AlertTutorialStep1 extends Sprite {
		private var _tf : TextField;
		
		public function AlertTutorialStep1() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
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
			alert.y = 30;
			addChild(alert);
		}
		
		private function info(alert : AlertBox, event : String) : void {
			_tf.text = event;
		}
	}
}