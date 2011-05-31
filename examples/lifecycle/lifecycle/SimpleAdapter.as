package lifecycle.lifecycle {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class SimpleAdapter extends LifeCycleAdapter {
		override protected function onInit() : void {
			Dummy(_component).init();
		}

		override protected function onPrepareUpdate() : void {
			Dummy(_component).prepareUpdate();
		}

		override protected function onUpdate() : void {
			Dummy(_component).update();
		}

		override protected function onCleanUp() : void {
			Dummy(_component).cleanUp();
		}
	}
}

import flash.display.Sprite;
internal class Dummy extends Sprite {
	internal function init() : void {
		// draw something
	}
	internal function prepareUpdate() : void {
		// determine update reasons
	}
	internal function update() : void {
		// update something
	}
	internal function cleanUp() : void {
		// remove references and listeners
	}
}