package lifecycle.i10n.boxexample {
	import org.as3commons.ui.lifecycle.i10n.I10N;

	public class I10NService extends I10N {
		public static const PHASE_VALIDATE : String = "validate";
		private static var _instance : I10N;
		
		public static function start() : void {
			_instance = new I10N();
			_instance.addPhase(PHASE_VALIDATE, I10N.PHASE_ORDER_TOP_DOWN);
			_instance.start();
		}
		
		public static function get instance() : I10N {
			return _instance;
		}
	}
}