package lifecycle.lifecycle.hboxexample {
	import common.ControlPanelBase;
	import com.sibirjak.asdpcbeta.slider.Slider;
	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.shortcut.hlayout;

	public class HBoxExampleControls extends ControlPanelBase {
		private var _hBox : HBox;
		private var _layout : HLayout;

		public function HBoxExampleControls(hBox : HBox) {
			_hBox = hBox;
			
			_layout = hlayout(
				"maxItemsPerRow", 2, "hGap", 10, "vGap", 2,

				label("Num items:"),
				sliderWithLabel({
					"id": "numSlider",
					"minValue": 0,
					"maxValue": 10,
					"value": 5,
					"change": setItems
				}),
			
				label("Item size:"),
				sliderWithLabel({
					"id": "sizeSlider",
					"minValue": 10,
					"maxValue": 20,
					"value": 15,
					"change": itemSizeChange
				}),
			
				label("Padding:"),
				sliderWithLabel({
					"id": "paddingSlider",
					"minValue": 0,
					"maxValue": 20,
					"value": 10,
					"change": paddingChange
				})
			);
			_layout.layout(this);
		}

		private function setItems(numItems : uint) : void {
			var c : AnyComponent;
			if (numItems > _hBox.numChildren) {
				var size : uint = Slider(_layout.getDisplayObject("sizeSlider")).value;
				var numChildren : uint = _hBox.numChildren;
				for (var i : uint = 0; i < numItems - numChildren; i++) {
					c = new AnyComponent();
					c.width = size;
					c.height = size;
					_hBox.addChild(c);
				}
			}
			while (_hBox.numChildren > numItems) {
				c = _hBox.getChildAt(0) as AnyComponent;
				_hBox.removeChild(c);
			}
		}

		private function itemSizeChange(size : uint) : void {
			for (var i : uint = 0; i < _hBox.numChildren; i++) {
				AnyComponent(_hBox.getChildAt(i)).width = size;
				AnyComponent(_hBox.getChildAt(i)).height = size;
			}
		}

		private function paddingChange(padding : uint) : void {
			_hBox.padding = padding;
		}
	}
}