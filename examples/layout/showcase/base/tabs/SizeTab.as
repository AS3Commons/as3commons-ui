package layout.showcase.base.tabs {

	import layout.showcase.base.ShowcaseConfig;

	import com.sibirjak.asdpc.textfield.Label;

	import org.as3commons.ui.layout.debugger.LayoutDebugger;
	import org.as3commons.ui.layout.framework.IDisplay;
	import org.as3commons.ui.layout.framework.IDynTable;
	import org.as3commons.ui.layout.framework.IGroupLayout;
	import org.as3commons.ui.layout.framework.IHLayout;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.framework.IMultilineLayout;
	import org.as3commons.ui.layout.framework.ITable;
	import org.as3commons.ui.layout.framework.IVLayout;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import org.as3commons.ui.layout.shortcut.vgroup;

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 29.03.2011
	 */
	public class SizeTab extends AbstractTab {

		public function SizeTab(layout : ILayout, layoutContainer : Sprite, config : ShowcaseConfig, debugger : LayoutDebugger) {
			super(layout, layoutContainer, config, debugger);

			tabLayout = hlayout(
				"offsetX", 4,
				"offsetY", 8,
				"maxItemsPerRow", 2,
				"maxContentWidth", 150,
				"hGap", 8,
				"vGap", 4,
				
				headline("Min", 150),
			
				label("Width:", -20),
				sliderWithLabel({
					width: 50,
					minValue: 0,
					maxValue: 550,
					value: _config.minWidth,
					snapInterval: 10,
					change: function(minWidth : uint) : void {
						_layout.minWidth = minWidth;
						updateLayout();
					}
				}),

				label("Height:", -20),
				sliderWithLabel({
					width: 50,
					minValue: 0,
					maxValue: 400,
					value: _config.minHeight, 
					snapInterval: 10,
					change: function(minHeight : uint) : void {
						_layout.minHeight = minHeight;
						updateLayout();
					}
				}),
				
				vgroup(
					"gap", 4,
					dottedSeparator(144),

					"inLayout", !(_layout is IGroupLayout),
					headline("Max", 150)
				),
			
				hlayout(
					"maxItemsPerRow", 2,
					"maxContentWidth", 150,
					"hGap", 8,
					"vGap", 4,
					"inLayout", _layout is IHLayout || _layout is IDynTable,

					label("Width:", -20),
					sliderWithLabel({
						labelid: "maxwidthlabel",
						width: 50,
						minValue: 20,
						maxValue: 510,
						value: _config.maxSize, 
						snapInterval: 10,
						change: function(maxContentWidth : uint) : void {
							if (!(_layout is IHLayout) && !(_layout is IDynTable)) return;
							
							if (maxContentWidth == 510) {
								maxContentWidth = 0;
								var d : IDisplay = tabLayout.getLayoutItem("maxwidthlabel") as IDisplay;
								Label(d.displayObject).text = "0";
							}
							
							_layout["maxContentWidth"] = maxContentWidth;
							updateLayout();
						}
					})
				),
				
				hlayout(
					"maxItemsPerRow", 2,
					"maxContentWidth", 150,
					"hGap", 8,
					"vGap", 4,
					"inLayout", _layout is IVLayout,

					label("Height:", -20),
					sliderWithLabel({
						labelid: "maxheightlabel",
						width: 50,
						minValue: 40,
						maxValue: 380,
						value: _config.maxSize, 
						snapInterval: 10,
						change: function(maxContentHeight : uint) : void {
							if (!(_layout is IVLayout)) return;

							if (maxContentHeight == 380) {
								maxContentHeight = 0;
								var d : IDisplay = tabLayout.getLayoutItem("maxheightlabel") as IDisplay;
								Label(d.displayObject).text = "0";
							}
							
							_layout["maxContentHeight"] = maxContentHeight;
							updateLayout();
						}
					})
				),
				
				hlayout(
					"maxItemsPerRow", 2,
					"maxContentWidth", 150,
					"hGap", 8,
					"vGap", 4,
					"inLayout", _layout is IHLayout || _layout is IVLayout,

					label("Items:", -20),
					sliderWithLabel({
						labelid: "maxitemslabel",
						width: 50,
						minValue: 1,
						maxValue: 21,
						value: _config.maxItems, 
						snapInterval: 1,
						change: function(maxItemsPerRow : uint) : void {
							if (!(_layout is IHLayout) && !(_layout is IVLayout)) return;

							if (maxItemsPerRow == 21) {
								maxItemsPerRow = 0;
								var d : IDisplay = tabLayout.getLayoutItem("maxitemslabel") as IDisplay;
								Label(d.displayObject).text = "0";
							}

							if (_layout is IHLayout) _layout["maxItemsPerRow"] = maxItemsPerRow;
							if (_layout is IVLayout) _layout["maxItemsPerColumn"] = maxItemsPerRow;
							updateLayout();
						}
					})
				),
				
				hlayout(
					"maxItemsPerRow", 2,
					"maxContentWidth", 150,
					"hGap", 8,
					"vGap", 4,
					"inLayout", _layout is ITable,

					label("Columns:", -20),
					sliderWithLabel({
						width: 50,
						minValue: 1,
						maxValue: 30,
						value: _config.numColumns, 
						change: function(numColumns : uint) : void {
							if (!(_layout is ITable)) return;
							ITable(_layout).numColumns = numColumns;
							updateLayout();
						}
					})
				),

				dottedSeparator(144),

				headline("Gap", 150),
			
				hlayout(
					"maxItemsPerRow", 2,
					"maxContentWidth", 150,
					"hGap", 8,
					"vGap", 4,
					"inLayout", _layout is IMultilineLayout,

					label("HGap:", -20),
					sliderWithLabel({
						width: 50,
						minValue: 0,
						maxValue: 20,
						value: 5, 
						change: function(hGap : uint) : void {
							if (!(_layout is IMultilineLayout)) return;
							IMultilineLayout(_layout).hGap = hGap;
							updateLayout();
						}
					}),
					
					label("VGap:", -20),
					sliderWithLabel({
						width: 50,
						minValue: 0,
						maxValue: 20,
						value: 5, 
						change: function(vGap : uint) : void {
							if (!(_layout is IMultilineLayout)) return;
							IMultilineLayout(_layout).vGap = vGap;
							updateLayout();
						}
					})
				),
				
				hgroup(
					"gap", 8,
					"inLayout", _layout is IGroupLayout,

					label("Gap:", -20),
					sliderWithLabel({
						width: 50,
						minValue: 0,
						maxValue: 20,
						value: 5, 
						change: function(gap : uint) : void {
							if (!(_layout is IGroupLayout)) return;
							IGroupLayout(_layout).gap = gap;
							updateLayout();
						}
					})
				)
			);
			
			tabLayout.layout(this);
		}
	}
}
