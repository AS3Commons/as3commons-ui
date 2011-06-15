package lifecycle.lifecycle.memory {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class MemoryBoxAdapter extends LifeCycleAdapter {
		override protected function onDraw() : void {
			MemoryBox(_component).draw();
		}
		override protected function onUpdate() : void {
			MemoryBox(_component).draw();
		}
	}
}