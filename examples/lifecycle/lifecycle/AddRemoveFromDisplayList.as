package lifecycle.lifecycle {
	import flash.utils.setTimeout;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import flash.display.Sprite;

	public class AddRemoveFromDisplayList extends Sprite {
		private var _component : Component;
		
		public function AddRemoveFromDisplayList() {
			var lifeCycle : LifeCycle = new LifeCycle();
			_component = new Component(lifeCycle);
			addChild(_component);
			setTimeout(update1, 1000);
		}
		
		private function update1() : void {
			trace ("update1");
			_component.invalidate();
			removeChild(_component); // not updated in this frame
			setTimeout(update2, 1000);
		}

		private function update2() : void {
			trace ("update2");
			addChild(_component); // update in this frame
		}
	}
}

import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;
import flash.display.Sprite;

internal class Component extends Sprite {
	private var _lcAdapter : ComponentAdapter;
	public function Component(lifeCycle : LifeCycle) {
		_lcAdapter = new ComponentAdapter();
		lifeCycle.registerComponent(this, _lcAdapter);
	}
	public function invalidate() : void {
		_lcAdapter.invalidate();
	}
	public function update() : void {
		trace ("UPDATE");
	}
}

internal class ComponentAdapter  extends LifeCycleAdapter {
	override protected function onUpdate() : void {
		Component(_component).update();
	}
}