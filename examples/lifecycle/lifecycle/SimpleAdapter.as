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

		override protected function onCalculateDefaults() : void {
			Dummy(displayObject).calculateDefaults();
		}

		override protected function onRender() : void {
			Dummy(displayObject).render();
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
		// schedule calls to calculateDefaults and render
	}
	internal function calculateDefaults() : void {
		// calculate values for properties not set yet
	}
	internal function render() : void {
		// draw something or arrange children
	}
}