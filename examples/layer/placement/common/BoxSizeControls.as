package layer.placement.common {
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import flash.events.Event;

	public class BoxSizeControls extends ControlPanelBase {
		public function BoxSizeControls(box : Box) {
			var v : VGroup = vgroup(
				"gap", 4,
				sliderWithLabel({
					width: 46,
					minValue: 40, maxValue: 120, value: box.width,
					snapInterval: 10,
					change: function(width : uint) : void {
						box.width = width;
						dispatchEvent(new Event("box_size", true));
					}
				}),
				sliderWithLabel({
					width: 46,
					minValue: 40, maxValue: 120, value: box.height,
					snapInterval: 10,
					change: function(height : uint) : void {
						box.height = height;
						dispatchEvent(new Event("box_size", true));
					}
				})
			);
			v.layout(this);
			setSize(v.visibleRect.width, v.visibleRect.height);
		}
	}
}