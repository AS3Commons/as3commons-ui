package layout.showcase.base.tabs {

	import layout.common.box.Box;
	import layout.showcase.base.ShowcaseConfig;

	import com.sibirjak.asdpcbeta.slider.Slider;

	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.ui.layout.debugger.LayoutDebugger;
	import org.as3commons.ui.layout.framework.IDisplay;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.layout.shortcut.hlayout;

	import flash.display.Sprite;
	/**
	 * @author Jens Struwe 29.03.2011
	 */
	public class BoxesTab extends AbstractTab {

		private var _maxNumBoxes : uint;
		private var _numBoxes : uint;

		private var _minBoxSize : uint;
		private var _maxBoxSize : uint;

		public function BoxesTab(layout : ILayout, layoutContainer : Sprite, config : ShowcaseConfig, debugger : LayoutDebugger) {
			super(layout, layoutContainer, config, debugger);
			
			_maxNumBoxes = _config.maxNumBoxes; 
			_numBoxes = _config.numBoxes; 
			
			_minBoxSize = _config.minBoxSize; 
			_maxBoxSize = _config.maxBoxSize; 
			
			tabLayout = hlayout(
				"offsetX", 4,
				"offsetY", 8,
				"maxItemsPerRow", 2,
				"maxContentWidth", 200,
				"hGap", 8,
				"vGap", 4,
				
				label("Quantity:", -20),
				sliderWithLabel({
					width: 80,
					minValue: 0,
					maxValue: _maxNumBoxes,
					value: _numBoxes, 
					change: setNumBoxes
				}),
			
				label("MinSize:", -20),
				sliderWithLabel({
					id: "boxMinSize",
					width: 80,
					minValue: 20,
					maxValue: 40,
					value: _minBoxSize, 
					snapInterval: 2,
					change: function(minSize : uint) : void {
						var maxSlider : Slider = IDisplay(tabLayout.getLayoutItem("boxMaxSize")).displayObject as Slider;
						if (maxSlider && maxSlider.value < minSize) {
							maxSlider.value = minSize;
						}
					
						_minBoxSize = minSize;
					}
				}),

				label("MaxSize:", -20),
				sliderWithLabel({
					id: "boxMaxSize",
					width: 80,
					minValue: 20,
					maxValue: 40,
					value: _maxBoxSize, 
					snapInterval: 2,
					change: function(maxSize : uint) : void {
						var minSlider : Slider = IDisplay(tabLayout.getLayoutItem("boxMinSize")).displayObject as Slider;
						if (minSlider && minSlider.value > maxSize) {
							minSlider.value = maxSize;
						}

						_maxBoxSize = maxSize;
					}
				}),

				hgroup(
					"marginY", 4,
					"gap", 8,
					label("Refresh:", -20),
					button({
						w: 50,
						h: 18,
						label: "Refresh",
						click: refreshAll
					})
				)
			);
			
			tabLayout.layout(this);
		}

		private function createBoxes(numBoxes : uint) : Array {
			Box.setNextID(_layout.numItems + 1);
			return Box.create(numBoxes, true, _minBoxSize, _maxBoxSize);
		}
		
		private function refreshAll() : void {
			var numBoxes : uint = _numBoxes;
			setNumBoxes(0),
			setNumBoxes(numBoxes);
		}
		
		private function setNumBoxes(numBoxes : uint) : void {
			if (numBoxes > _layout.numItems) {
				_layout.add(createBoxes(numBoxes - _layout.numItems));

			} else if (numBoxes < _layout.numItems) {
				var iterator : ICollectionIterator = _layout.iterator() as ICollectionIterator;
				iterator.end();
				var displayItem : IDisplay;
				while (_layout.numItems > numBoxes && iterator.hasPrevious()) {
					displayItem = iterator.previous();
					iterator.remove();
					_layoutContainer.removeChild(displayItem.displayObject);
				}				
			} else {
				return;
			}
			
			_numBoxes = numBoxes;
			updateLayout();
		}
		
	}
}
