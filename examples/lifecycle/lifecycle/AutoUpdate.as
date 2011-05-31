package lifecycle.lifecycle {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	public class AutoUpdate extends Sprite {
		private var _component1 : Component;
		private var _component2 : Component;

		public function AutoUpdate() {
			var lifeCycle : LifeCycle = new LifeCycle();

			_component1 = new Component(lifeCycle, "component1");
			addChild(_component1);

			_component2 = new Component(lifeCycle, "component2");
			addChild(_component2);

			_component1.setSubComponent(_component2);
			
			setTimeout(update1, 1000);
		}

		private function update1() : void {
			_component1.invalidate();
			_component2.invalidate();
		}
	}
}

import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

import flash.display.Sprite;

internal class Component extends Sprite {
	protected var _lcAdapter : ComponentAdapter;
	protected var _name : String;
	public function Component(lifeCycle : LifeCycle, name : String) {
		_lcAdapter = new ComponentAdapter();
		_name = name;
		lifeCycle.registerComponent(this, _lcAdapter);
	}
	public function setSubComponent(component : Component) : void {
		_lcAdapter.autoUpdateBefore(component);
	}
	public function invalidate() : void {
		_lcAdapter.invalidate();
	}
	public function update() : void {
		trace ("UPDATE Component", _name);
	}
}

internal class ComponentAdapter  extends LifeCycleAdapter {
	override protected function onUpdate() : void {
		Component(_component).update();
	}
}