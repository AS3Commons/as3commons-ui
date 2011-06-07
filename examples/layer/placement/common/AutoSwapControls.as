package layer.placement.common {
	import common.ControlPanelBase;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import flash.events.Event;

	public class AutoSwapControls extends ControlPanelBase {
		private var _autoSwapH : Boolean = true;
		private var _autoSwapHDiff : uint;
		private var _autoSwapV : Boolean = true;
		private var _autoSwapVDiff : uint;

		public function AutoSwapControls() {
			_autoSwapHDiff = DefaultValues.autoSwapHDiff;
			_autoSwapVDiff = DefaultValues.autoSwapVDiff;

			var v : VGroup = vgroup(
				"gap", 4,
				checkBox({
					label: "Swap H",
					selected: true,
					change: function(autoSwap : Boolean) : void {
						_autoSwapH = autoSwap;
						dispatchEvent(new Event("autoswap", true));
					}
				}),
				sliderWithLabel({
					width: 36,
					minValue: 0, maxValue: 80, value: _autoSwapHDiff,
					snapInterval: 5,
					change: function(hDiff : uint) : void {
						_autoSwapHDiff = hDiff;
						dispatchEvent(new Event("autoswap", true));
					}
				}),
				checkBox({
					label: "Swap V",
					selected: true,
					change: function(autoSwap : Boolean) : void {
						_autoSwapV = autoSwap;
						dispatchEvent(new Event("autoswap", true));
					}
				}),
				sliderWithLabel({
					width: 36,
					minValue: 0, maxValue: 80, value: _autoSwapVDiff,
					snapInterval: 5,
					change: function(vDiff : uint) : void {
						_autoSwapVDiff = vDiff;
						dispatchEvent(new Event("autoswap", true));
					}
				})
			);
			v.layout(this);
			setSize(v.visibleRect.width, v.visibleRect.height);
		}

		public function get autoSwapH() : Boolean {
			return _autoSwapH;
		}

		public function get autoSwapHDiff() : uint {
			return _autoSwapHDiff;
		}

		public function get autoSwapV() : Boolean {
			return _autoSwapV;
		}

		public function get autoSwapVDiff() : uint {
			return _autoSwapVDiff;
		}
	}
}