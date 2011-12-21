package lifecycle.lifecycle.boxexample {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class BoxAdapter extends LifeCycleAdapter {
		override protected function onInit() : void {
			Box(displayObject).init();
		}
		
		override protected function onValidate() : void {
			Box(displayObject).validate();
		}

		override protected function onMeasure() : void {
			Box(displayObject).measure();
		}

		override protected function onUpdate() : void {
			Box(displayObject).update();
		}
	}
}