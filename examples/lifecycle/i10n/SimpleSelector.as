package lifecycle.i10n {
	import org.as3commons.ui.lifecycle.i10n.II10NSelector;
	import flash.display.DisplayObject;

	public class SimpleSelector implements II10NSelector {
		public function approve(displayObject : DisplayObject) : Boolean {
			return displayObject is BaseComponent;
		}
	}
}

import flash.display.Sprite;
internal class BaseComponent extends Sprite {
	public function update() : void {
		// draw something
	}
}