package lifecycle.lifecycle.boxexample {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	public class BoxAdapter extends LifeCycleAdapter {
		override protected function onInit() : void {
			Box(displayObject).init();
		}
		
		override protected function onValidate() : void {
			Box(displayObject).validate();
		}

		override protected function onCalculateDefaults() : void {
			Box(displayObject).calculateDefaults();
		}

		override protected function onRender() : void {
			Box(displayObject).render();
		}
	}
}