package layer.placement.common {
	import com.sibirjak.asdpcbeta.slider.Slider;
	import common.ControlPanelBase;
	import flash.events.Event;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.vgroup;

	public class OffsetControls extends ControlPanelBase {
		private var _v : VGroup;

		public function OffsetControls() {
			_v = vgroup(
				"gap", 4,
				sliderWithLabel({
					id: "offsetX",
					width: 36,
					minValue: -20, maxValue: 20, value: 0,
					snapInterval: 5,
					change: function(offsetX : int) : void {
						dispatchEvent(new Event("offset", true));
					}
				}),
				sliderWithLabel({
					id: "offsetY",
					width: 36,
					minValue: -20, maxValue: 20, value: 0,
					snapInterval: 5,
					change: function(offsetY : int) : void {
						dispatchEvent(new Event("offset", true));
					}
				})
			);
			_v.layout(this);
			setSize(_v.visibleRect.width, _v.visibleRect.height);
		}

		public function get offsetX() : int {
			return Slider(_v.getDisplayObject("offsetX")).value;
		}
		
		public function get offsetY() : int {
			return Slider(_v.getDisplayObject("offsetY")).value;
		}
	}
}