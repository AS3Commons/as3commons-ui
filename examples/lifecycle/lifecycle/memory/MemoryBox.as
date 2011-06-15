package lifecycle.lifecycle.memory {
	import flash.display.Sprite;

	public class MemoryBox extends Sprite {
		protected var _lcAdapter : MemoryBoxAdapter;

		public function MemoryBox() {
			_lcAdapter = new MemoryBoxAdapter();
			MemoryGlobals.lifeCycle.registerComponent(this, _lcAdapter);
		}

		public function invalidate() : void {
			_lcAdapter.invalidate();
		}

		public function draw() : void {
			with (graphics) {
				clear();
				beginFill(MemoryGlobals.boxColor);
				drawRect(0, 0, 10, 10);
			}
		}
		
		public function cleanUp() : void {
			MemoryGlobals.lifeCycle.unregisterComponent(this);
		}
	}
}