package layer.popup {
	import layer.popup.common.AlertBox;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Sine;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AnimatedPopUps extends Sprite {
		private var _popUpManager : PopUpManager;
		private var _alertId : uint;
		private var _startPosition : uint = 20;

		public function AnimatedPopUps() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);

			var addButton : Button = new Button();
			addButton.setSize(50, 20);
			addButton.label = "add";
			addButton.addEventListener(ButtonEvent.CLICK, addHandler);
			addChild(addButton);
		}
		
		private function addHandler(event : ButtonEvent = null) : void {
			addPopUp();
		}

		private function closeCallback(alert : AlertBox, event : String) : void {
			removePopUp(alert);
		}

		private function alertClickHandler(event : MouseEvent) : void {
			_popUpManager.bringToFront(event.currentTarget as AlertBox);
		}
		
		private function addPopUp() : void {
			_startPosition += 30;
			if (_startPosition > 140) _startPosition = 50;

			var alert : AlertBox = new AlertBox(
				"Popup " + ++_alertId,
				"This is a simple popup window. Close this window by clicking the close button or the remove button of the outher application.",
				[null, null, "Close"],
				closeCallback
			);

			alert.x = alert.y = _startPosition;
			alert.addEventListener(MouseEvent.MOUSE_DOWN, alertClickHandler);
			_popUpManager.createPopUp(alert);

			var tween : GTween = new GTween();
			tween.target = alert;
			tween.ease = Sine.easeOut;
			tween.duration = .15;

			// tween position
			tween.setValue("x", alert.x);
			tween.setValue("y", alert.y);
			alert.x += alert.width/2;
			alert.y += alert.height/2;
			// tween scale
			alert.scaleX = alert.scaleY = 0;
			alert.scaleX = alert.scaleY = 0;
			tween.setValue("scaleX", 1);
			tween.setValue("scaleY", 1);
			// tween alpha
			alert.alpha = 0;
			tween.setValue("alpha", 1);
		}

		private function removePopUp(alert : AlertBox) : void {
			alert.removeEventListener(MouseEvent.MOUSE_DOWN, alertClickHandler);

			var tween : GTween = new GTween();
			tween.target = alert;
			tween.ease = Cubic.easeIn;
			tween.duration = .2;

			// tween position
			tween.setValue("x", alert.x + alert.width/2);
			tween.setValue("y", alert.y + alert.height/2);
			// tween scale
			tween.setValue("scaleX", 0);
			tween.setValue("scaleY", 0);
			// tween alpha
			tween.setValue("alpha", 0);
			
			tween.onComplete = function(tween : GTween) : void {
				_popUpManager.removePopUp(alert);
			};
		}
	}
}