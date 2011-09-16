package lifecycle.lifecycle {
	import flash.display.Sprite;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;

	public class SimpleRegistration extends Sprite {
		public function SimpleRegistration() {
			var lifeCycle : LifeCycle = new LifeCycle();
			addChild(new Component(lifeCycle));
		}
	}
}

import flash.display.Sprite;
import lifecycle.lifecycle.SimpleAdapter;
import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;

internal class Component extends Sprite {
	private var _lcAdapter : SimpleAdapter;
	public function Component(lifeCycle : LifeCycle) {
		_lcAdapter = new SimpleAdapter();
		lifeCycle.registerDisplayObject(this, _lcAdapter);
	}
}