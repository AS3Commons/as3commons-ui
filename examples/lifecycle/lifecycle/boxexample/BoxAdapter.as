package lifecycle.lifecycle.boxexample {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class BoxAdapter extends LifeCycleAdapter {
		override protected function onInit() : void {
			Box(_component).init();
		}

		override protected function onDraw() : void {
			Box(_component).draw();
		}

		override protected function onUpdate() : void {
			Box(_component).update();
		}
	}
}