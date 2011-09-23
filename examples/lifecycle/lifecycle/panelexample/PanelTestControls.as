package lifecycle.lifecycle.panelexample {
	import common.ControlPanelBase;
	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.shortcut.hlayout;

	public class PanelTestControls extends ControlPanelBase {
		private var _panel : Panel;
		private var _layout : HLayout;

		public function PanelTestControls(panel : Panel) {
			_panel = panel;
			
			_layout = hlayout(
				"maxItemsPerRow", 2, "hGap", 10, "vGap", 2,

				label("Width:"),
				sliderWithLabel({
					"id": "wSlider",
					"minValue": 0,
					"maxValue": 300,
					"value": 100,
					"change": widthChange
				}),
			
				label("Height:"),
				sliderWithLabel({
					"id": "hSlider",
					"minValue": 0,
					"maxValue": 70,
					"value": 30,
					"change": heightChange
				})
			);
			_layout.layout(this);
		}

		private function widthChange(width : uint) : void {
			_panel.width = width;
		}

		private function heightChange(height : uint) : void {
			_panel.height = height;
		}
	}
}