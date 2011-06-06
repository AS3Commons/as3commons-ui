package layer.placement.bounds {
	import common.ControlPanelBase;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.vgroup;

	public class Controls extends ControlPanelBase {
		private var _boxWidth : uint = 40;
		private var _boxHeight : uint = 40;
		private var _v : VGroup;
		
		public function Controls(callback : Function) {
			_v = vgroup(
				"gap", 8,
				headline("Layer Size", 100),
				sliderWithLabel({
					width: 46,
					minValue: 40, maxValue: 140, value: _boxWidth,
					snapInterval: 10,
					change: function(width : uint) : void {
						_boxWidth = width;
						callback(_boxWidth, _boxHeight);
					}
				}),
				sliderWithLabel({
					width: 46,
					minValue: 40, maxValue: 140, value: _boxHeight,
					snapInterval: 10,
					change: function(height : uint) : void {
						_boxHeight = height;
						callback(_boxWidth, _boxHeight);
					}
				})
			);
			_v.layout(this);
			setSize(_v.visibleRect.width, _v.visibleRect.height);
		}
	}
}