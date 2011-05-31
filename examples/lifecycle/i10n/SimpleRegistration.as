package lifecycle.i10n {
	import org.as3commons.ui.lifecycle.i10n.Invalidation;
	import flash.display.Sprite;

	public class SimpleRegistration extends Sprite {
		public function SimpleRegistration() {
			var i10n : Invalidation = new Invalidation();
			i10n.registerAdapter(new SimpleSelector(), new SimpleAdapter());
		}
	}
}