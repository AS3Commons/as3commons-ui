package lifecycle.lifecycle.boxexample {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;

	public class LifeCycleService extends LifeCycle {
		private static var _instance : LifeCycle;
		
		public static function start() : void {
			_instance = new LifeCycle();
		}
		
		public static function get instance() : LifeCycle {
			return _instance;
		}
	}
}