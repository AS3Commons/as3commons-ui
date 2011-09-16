package lifecycle.i10n {
	import flash.display.Sprite;
	import org.as3commons.ui.lifecycle.i10n.I10N;

	public class SimpleRegistration extends Sprite {
		public function SimpleRegistration() {
			var i10n : I10N = new I10N();
			i10n.addPhase("first", I10N.PHASE_ORDER_TOP_DOWN);
			i10n.start();
			
			i10n.registerDisplayObject(new Dummy(), new SimpleAdapter());
		}
	}
}

import flash.display.Sprite;
internal class Dummy extends Sprite {
	public function render() : void {
		// draw something
	}
}