package lifecycle.i10n {
	import org.as3commons.ui.lifecycle.i10n.I10NAdapter;

	public class SimpleAdapter extends I10NAdapter {
		override protected function onValidate(phaseName : String) : void {
			Dummy(displayObject).render();
		}
	}
}

import flash.display.Sprite;
internal class Dummy extends Sprite {
	public function render() : void {
		// draw something
	}
}