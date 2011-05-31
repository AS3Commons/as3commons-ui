package lifecycle.i10n {
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;
	import flash.display.DisplayObject;

	public class SimpleAdapter implements II10NApapter {
		public function willValidate(displayObject : DisplayObject) : void {
			// do nothing here
		}

		public function validate(displayObject : DisplayObject, properties : ISet) : void {
			Dummy(displayObject).update();
		}
	}
}

import flash.display.Sprite;
internal class Dummy extends Sprite {
	public function update() : void {
		// draw something
	}
}