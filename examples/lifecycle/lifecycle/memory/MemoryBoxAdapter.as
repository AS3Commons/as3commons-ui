package lifecycle.lifecycle.memory {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class MemoryBoxAdapter extends LifeCycleAdapter {
		override protected function onValidate() : void {
			scheduleRendering();
		}

		override protected function onRender() : void {
			MemoryBox(displayObject).render();
		}
	}
}