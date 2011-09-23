package lifecycle.lifecycle.hboxexample {
	import flash.display.Sprite;

	public class HBoxExample extends Sprite {
		public function HBoxExample() {
			var box : HBox = new HBox();
			addChild(box);

			addChild(new HBoxExampleControls(box)).y = 70;
		}
	}
}