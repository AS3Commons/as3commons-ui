package lifecycle.lifecycle.introduction.comparision {
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleView;

	public class LifeCycleComponent extends LifeCycleView {
		private var _borderColor : uint = 0x999999;
		private var _backgroundColor : uint = 0xDDDDDD;

		public function LifeCycleComponent() {
			invalidate();
		}

		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
			invalidate();
		}

		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;
			invalidate();
		}
		
		override protected function validate() : void {
			trace ("DRAW life cycle component");
			with (graphics) {
				clear();
				lineStyle(1, _borderColor);
				beginFill(_backgroundColor);
				drawRect(0, 0, 100, 100);
			}
		}
	}
}