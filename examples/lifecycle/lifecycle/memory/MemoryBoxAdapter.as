package lifecycle.lifecycle.memory {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class MemoryBoxAdapter extends LifeCycleAdapter {
		override protected function onValidate() : void {
			scheduleUpdate();
		}

		override protected function onUpdate() : void {
			MemoryBox(displayObject).update();
		}
	}
}