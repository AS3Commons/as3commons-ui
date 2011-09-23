package lifecycle.lifecycle.introduction {
	import flash.display.Sprite;

	public class ComparisionLCandNLC extends Sprite {
		public function ComparisionLCandNLC() {
			var nlc : NonLifeCycleComponent = new NonLifeCycleComponent();
			nlc.borderColor = 0xAA8888;
			nlc.backgroundColor = 0xEECCCC;
			addChild(nlc).x = 120;

			var lc : LifeCycleComponent = new LifeCycleComponent();
			lc.borderColor = 0xAA8888;
			lc.backgroundColor = 0xEECCCC;
			addChild(lc);
		}
	}
}