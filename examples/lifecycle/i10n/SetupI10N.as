package lifecycle.i10n {
	import flash.display.Sprite;
	import org.as3commons.ui.lifecycle.i10n.I10N;

	public class SetupI10N extends Sprite {
		public function SetupI10N() {
			var i10n : I10N = new I10N();
			i10n.addPhase("phase1Name", I10N.PHASE_ORDER_TOP_DOWN);
			i10n.addPhase("phase2Name", I10N.PHASE_ORDER_BOTTOM_UP);
			// add more phases
			i10n.start();
		}
	}
}