package lifecycle.lifecycle.hboxexample {
	import lifecycle.lifecycle.common.Component;

	public class AnyComponent extends Component {
		public function AnyComponent() {
			width = 20;
			height = 20;
		}

		override protected function validate() : void {
			scheduleUpdate();
		}
		
		override protected function update() : void {
			with (graphics) {
				clear();
				lineStyle(0);
				beginFill(0xDD4444);
				drawRect(0, 0, width, height);
			}
		}
	}
}