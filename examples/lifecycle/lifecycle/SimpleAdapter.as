package lifecycle.lifecycle {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class SimpleAdapter extends LifeCycleAdapter {
		override protected function onInit() : void {
			Dummy(displayObject).init();
			Dummy(displayObject).createChildren();
		}

		override protected function onValidate() : void {
			Dummy(displayObject).validate();
		}

		override protected function onMeasure() : void {
			Dummy(displayObject).measure();
		}

		override protected function onUpdate() : void {
			Dummy(displayObject).update();
		}
	}
}

import flash.display.Sprite;
internal class Dummy extends Sprite {
	internal function init() : void {
		// init something e.g. styles or listeners
	}
	internal function createChildren() : void {
		// create and add children
	}
	internal function validate() : void {
		// set properties to children
		// schedule calls to measure and update
	}
	internal function measure() : void {
		// calculate (default) size of the component
	}
	internal function update() : void {
		// draw something or arrange children
	}
}