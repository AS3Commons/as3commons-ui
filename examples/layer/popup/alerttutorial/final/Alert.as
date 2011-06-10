package layer.popup.alerttutorial.final {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Sine;

	public class Alert {
		public static function show(
			headline : String, text : String, buttons : Array,
			modal : Boolean, hideOnClickOutside : Boolean,
			callback : Function, tweenIn : Boolean
		) : void {
			var alert : AlertBox = new AlertBox(headline, text,	buttons, callback);

			Globals.popUpManager.createPopUp(alert, true, modal);
			
			if (tweenIn) {
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
			
			if (hideOnClickOutside) {
				alert.watchClickOutside(function() : void {
					if (alert.alpha != 1) return; // tween not finished yet
					hide(alert, true);
				});
			}
		}
		
		public static function hide(alert : AlertBox, tweenOut : Boolean) : void {
			alert.unwatchClickOutside();
			
			if (tweenOut) {
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
					Globals.popUpManager.removePopUp(alert);
				};

			} else {
				Globals.popUpManager.removePopUp(alert);
			}
		}
	}
}