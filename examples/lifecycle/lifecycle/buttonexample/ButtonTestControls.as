package lifecycle.lifecycle.buttonexample {
	import common.ControlPanelBase;
	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.shortcut.cellconfig;
	import org.as3commons.ui.layout.shortcut.hlayout;

	public class ButtonTestControls extends ControlPanelBase {
		private var _button : Button;
		private var _layout : HLayout;
		
		public function ButtonTestControls(button : Button) {
			_button = button;
			
			_layout = hlayout(
				"maxItemsPerRow", 2, "hGap", 10,
				cellconfig("vIndex", 1, "marginY", 4),
				
				label("Label:"),
				textInput({
					"diff": 50,
					"text": "Click",
					"change": labelChange
				}),
				
				label("Font size:"),
				sliderWithLabel({
					"id": "fsSlider",
					"minValue": 10,
					"maxValue": 40,
					"value": 10,
					"change": fontSizeChange
				}),
			
				label("Width:"),
				sliderWithLabel({
					"id": "wSlider",
					"minValue": 0,
					"maxValue": 400,
					"value": 100,
					"change": widthChange
				}),
			
				label("Height:"),
				sliderWithLabel({
					"id": "hSlider",
					"minValue": 0,
					"maxValue": 100,
					"value": 30,
					"change": heightChange
				})
			);
			_layout.layout(this);
		}

		private function labelChange(text : String) : void {
			_button.labelText = text;
		}

		private function fontSizeChange(size : uint) : void {
			_button.labelFontSize = size;
		}

		private function widthChange(width : uint) : void {
			_button.width = width;
		}

		private function heightChange(height : uint) : void {
			_button.height = height;
		}
	}
}