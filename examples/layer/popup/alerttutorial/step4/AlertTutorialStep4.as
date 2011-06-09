package layer.popup.alerttutorial.step4 {
	import layer.popup.alerttutorial.step3.AlertBox;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Sine;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import org.as3commons.ui.layer.PopUpManager;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AlertTutorialStep4 extends Sprite {
		private var _popUpManager : PopUpManager;
		private var _alertId : uint;
		
		public function AlertTutorialStep4() {
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
				"Notice " +  ++_alertId,
				"The information provided by this message box may help you to better understand the system of alerts and popups.",
				[null, null, "Close"],
				noticeClickCallback
			);
			_popUpManager.createPopUp(alert, true);
			tweenIn(alert);

			alert.watchClickOutside(function() : void {
				alert.unwatchClickOutside();
				tweenOut(alert);
			});
		}
		
		private function noticeClickCallback(alert : AlertBox, event : String) : void {
			alert.unwatchClickOutside();
			tweenOut(alert);
		}
		
		private function confirmHandler(event : ButtonEvent) : void {
			var alert : AlertBox = new AlertBox(
				"Confirm " +  ++_alertId,
				"Please confirm, dismiss or cancel the progress. Note, this application will not delete files on your hard disk.",
				["Yes", "No", "Cancel"],
				confirmClickCallback
			);
			_popUpManager.createPopUp(alert, true, true);
			tweenIn(alert);
		}
		
		private function confirmClickCallback(alert : AlertBox, event : String) : void {
			if (event != AlertBox.ALERT_CANCEL) {
				_popUpManager.removePopUp(alert);

				alert = new AlertBox(
					event.toUpperCase(),
					"The button \"" + event.toUpperCase() + "\" has been clicked. OK?",
					[null, null, "Close"],
					noticeClickCallback
				);
				_popUpManager.createPopUp(alert, true);
	
				alert.watchClickOutside(function() : void {
					alert.unwatchClickOutside();
					tweenOut(alert);
				});

			} else {
				tweenOut(alert);
			}
		}
		
		private function tweenIn(alert : AlertBox) : void {
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
		
		private function tweenOut(alert : AlertBox) : void {
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