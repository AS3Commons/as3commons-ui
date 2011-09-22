package lifecycle.lifecycle.buttonexample {
	import flash.display.Sprite;

	public class ButtonTest extends Sprite {
		public function ButtonTest() {
			var button : Button = new Button();
			button.labelText = "Click";
			addChild(button);
			
			addChild(new ButtonTestControls(button)).y = 120;
		}
	}
}