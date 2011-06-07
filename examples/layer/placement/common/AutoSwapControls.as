package layer.placement.common {
	import common.ControlPanelBase;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.cellconfig;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import flash.events.Event;

	public class AutoSwapControls extends ControlPanelBase {
		private var _autoSwap : Boolean = true;
		private var _autoSwapHDiff : uint;
		private var _autoSwapVDiff : uint;

		public function AutoSwapControls() {
			var v : VGroup = vgroup(
				"gap", 4,
				cellconfig("vIndex", 1, "marginY", 5),
				checkBox({
					label: "Swap",
					selected: true,
					change: function(autoSwap : Boolean) : void {
						_autoSwap = autoSwap;
						dispatchEvent(new Event("autoswap", true));
					}
				}),
				sliderWithLabel({
					width: 36,
					minValue: 0, maxValue: 40, value: _autoSwapHDiff,
					snapInterval: 5,
					change: function(hDiff : uint) : void {
						_autoSwapHDiff = hDiff;
						dispatchEvent(new Event("autoswap", true));
					}
				}),
				sliderWithLabel({
					width: 36,
					minValue: 0, maxValue: 40, value: _autoSwapVDiff,
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

		public function get autoSwap() : Boolean {
			return _autoSwap;
		}

		public function get autoSwapHDiff() : uint {
			return _autoSwapHDiff;
		}

		public function get autoSwapVDiff() : uint {
			return _autoSwapVDiff;
		}
	}
}