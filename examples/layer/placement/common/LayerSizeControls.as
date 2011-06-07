package layer.placement.common {
	import common.ControlPanelBase;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.vgroup;

	public class LayerSizeControls extends ControlPanelBase {
		private var _layerWidth : uint;
		private var _layerHeight : uint;

		public function LayerSizeControls(callback : Function) {
			_layerWidth = DefaultValues.width;
			_layerHeight = DefaultValues.height;

			var v : VGroup = vgroup(
				"gap", 4,
				sliderWithLabel({
					width: 36,
					minValue: DefaultValues.minWidth, maxValue: 140, value: _layerWidth,
					snapInterval: 10,
					change: function(width : uint) : void {
						_layerWidth = width;
						callback(_layerWidth, _layerHeight);
					}
				}),
				sliderWithLabel({
					width: 36,
					minValue: DefaultValues.minHeight, maxValue: 140, value: _layerHeight,
					snapInterval: 10,
					change: function(height : uint) : void {
						_layerHeight = height;
						callback(_layerWidth, _layerHeight);
					}
				})
			);
			v.layout(this);
			setSize(v.visibleRect.width, v.visibleRect.height);
		}
	}
}