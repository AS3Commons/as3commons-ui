package lifecycle.i10n.boxexample {
	import org.as3commons.ui.lifecycle.i10n.I10NAdapter;

	public class BoxAdapter extends I10NAdapter {
		override protected function onValidate(phaseName : String) : void {
			Box(displayObject).update();
		}
	}
}