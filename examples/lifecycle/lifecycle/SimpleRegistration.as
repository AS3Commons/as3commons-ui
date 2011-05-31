package lifecycle.lifecycle {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import flash.display.Sprite;

	public class SimpleRegistration extends Sprite {
		public function SimpleRegistration() {
			var lifeCycle : LifeCycle = new LifeCycle();
			addChild(new Component(lifeCycle));
		}
	}
}

import lifecycle.lifecycle.SimpleAdapter;
import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
import flash.display.Sprite;

internal class Component extends Sprite {
	private var _lcAdapter : SimpleAdapter;
	public function Component(lifeCycle : LifeCycle) {
		_lcAdapter = new SimpleAdapter();
		lifeCycle.registerComponent(this, _lcAdapter);
	}
}