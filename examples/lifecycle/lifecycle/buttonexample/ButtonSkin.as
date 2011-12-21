package lifecycle.lifecycle.buttonexample {
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import lifecycle.lifecycle.common.Component;

	public class ButtonSkin extends Component {
		private var _state : String;
		
		public function set state(state : String) : void {
			_state = state;
			invalidate();
		}
		
		override protected function validate() : void {
			scheduleUpdate();
		}
		
		override protected function update() : void {
			var backgroundColor : uint = _state == Button.STATE_OVER ? 0xFFFFFF : 0xEEEEEE;
			var borderColor : uint = _state == Button.STATE_DOWN ? 0x999999 : 0x666666;
			var gradientDirection : String = _state == Button.STATE_DOWN ? "dark_to_bright" : "bright_to_dark";
			
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(width, height, Math.PI / 180 * 45, 0, 0);
			var gradient : Array;

			with (graphics) {
				clear();

				lineStyle(1);
				gradient = ColorUtil.getGradient(borderColor, 60, gradientDirection);
				lineGradientStyle(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);

				gradient = ColorUtil.getGradient(backgroundColor, 20, gradientDirection);
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRect(0, 0, width, height);
			}
		}
	}
}