package lifecycle.lifecycle.panelexample {
	import flash.display.Sprite;

	public class PanelTest extends Sprite {
		public function PanelTest() {
			var p1 : Panel = new Panel();
			addChild(p1);

			var p2 : Panel = new Panel();
			p1.setChild(p2);

			var p3 : Panel = new Panel();
			p3.backgroundColor = 0xDDDDDD;
			p2.setChild(p3);
			
			addChild(new PanelTestControls(p3)).y = 130;
		}
	}
}