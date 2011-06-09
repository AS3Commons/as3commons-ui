package layer.popup {
	import layer.popup.common.AlertBox;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Sine;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AnimatedPopUp extends Sprite {
		private var _popUpManager : PopUpManager;
		private var _addButton : Button;
		
		public function AnimatedPopUp() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);

			_addButton = new Button();
			_addButton.setSize(50, 20);
			_addButton.toggle = true;
			_addButton.label = "show";
			_addButton.selectedLabel = "hide";
			_addButton.addEventListener(ButtonEvent.SELECTION_CHANGED, showHideHandler);
			addChild(_addButton);
		}
		
		private function showHideHandler(event : ButtonEvent) : void {
			if (_addButton.selected) {
				var alert : AlertBox = new AlertBox(
					"Simple Popup",
					"This is a simple popup window. Close this window by clicking the close button.",
					[null, null, "Close"],
					removePopUp
				);
				_popUpManager.createPopUp(alert, true);

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

			} else {
				removePopUp(_popUpManager.popUpOnTop);
			}
		}
		
		private function removePopUp(alert : DisplayObject, event : String = null) : void {
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

			_addButton.selected = false;
		}
	}
}