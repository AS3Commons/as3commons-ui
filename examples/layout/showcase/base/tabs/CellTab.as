package layout.showcase.base.tabs {

	import layout.showcase.base.ShowcaseConfig;

	import com.sibirjak.asdpc.textfield.Label;

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.debugger.LayoutDebugger;
	import org.as3commons.ui.layout.framework.IDisplay;
	import org.as3commons.ui.layout.framework.IDynTable;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.shortcut.cellconfig;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.layout.shortcut.hlayout;

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 29.03.2011
	 */
	public class CellTab extends AbstractTab {

		[Embed(source="../../assets/cell_topleft.png")]
		protected var _cellTopLeft : Class;
		[Embed(source="../../assets/cell_top.png")]
		protected var _cellTop : Class;
		[Embed(source="../../assets/cell_topright.png")]
		protected var _cellTopRight : Class;

		[Embed(source="../../assets/cell_left.png")]
		protected var _cellLeft : Class;
		[Embed(source="../../assets/cell_center.png")]
		protected var _cellCenter : Class;
		[Embed(source="../../assets/cell_right.png")]
		protected var _cellRight : Class;

		[Embed(source="../../assets/cell_bottomleft.png")]
		protected var _cellBottomLeft : Class;
		[Embed(source="../../assets/cell_bottom.png")]
		protected var _cellBottom : Class;
		[Embed(source="../../assets/cell_bottomright.png")]
		protected var _cellBottomRight : Class;

		private var _cellAlign : String = "topleft";
		private var _cellWidth : uint;
		private var _cellHeight : uint;

		public function CellTab(layout : ILayout, layoutContainer : Sprite, config : ShowcaseConfig, debugger : LayoutDebugger) {
			super(layout, layoutContainer, config, debugger);

			tabLayout = hlayout(
				"offsetX", 4,
				"offsetY", 8,
				"maxItemsPerRow", 4,
				"maxContentWidth", 180,
				"hGap", 8,
				"vGap", 4,
				
				hlayout(
					"maxItemsPerRow", 2,
					"maxContentWidth", 180,
					"hGap", 8,
					"vGap", 4,
					"inLayout", !(_layout is IDynTable),

					headline("Size", 180),
		
					label("Width:", -20),
	
					sliderWithLabel({
						labelid: "cellwidth",
						width: 80,
						minValue: 20,
						maxValue: 81,
						value: 81,
						change: function(cellWidth : uint) : void {
							if (cellWidth == 81) {
								cellWidth = 0;
								var d : IDisplay = tabLayout.getLayoutItem("cellwidth") as IDisplay;
								Label(d.displayObject).text = "0";
							}
	
							_cellWidth = cellWidth;
							_layout.setCellConfig(getCellConfig());
							updateLayout();
						}
					}),
	
					label("Height:", -20),
					sliderWithLabel({
						labelid: "cellheight",
						width: 80,
						minValue: 20,
						maxValue: 81,
						value: 81,
						change: function(cellHeight : uint) : void {
							if (_layout is IDynTable) return;
	
							if (cellHeight == 81) {
								cellHeight = 0;
								var d : IDisplay = tabLayout.getLayoutItem("cellheight") as IDisplay;
								Label(d.displayObject).text = "0";
							}
	
							_cellHeight = cellHeight;
							_layout.setCellConfig(getCellConfig());
							updateLayout();
						}
					}),
	
					dottedSeparator(170)
				),

				headline("Align", 180),
	
				radioGroup(
					"cellAlign",
					function(align : String) : void {
						_cellAlign = align;
						_layout.setCellConfig(getCellConfig());
						updateLayout();
					}
				),

				label("Top:", -30),
				
				hgroup(
					radioButton({
						group: "cellAlign",
						value: "topleft",
						selected: _cellAlign == "topleft",
						icon: new _cellTopLeft(),
						diff: 6
					}),
	
					radioButton({
						group: "cellAlign",
						value: "top",
						selected: _cellAlign == "top",
						icon: new _cellTop(),
						diff: 6
					}),
					radioButton({
						group: "cellAlign",
						value: "topright",
						selected: _cellAlign == "topright",
						icon: new _cellTopRight(),
						diff: 6
					})
				),

				label("Middle:", -30),
				
				hgroup(
					radioButton({
						group: "cellAlign",
						value: "left",
						selected: _cellAlign == "left",
						icon: new _cellLeft(),
						diff: 6
					}),
					radioButton({
						group: "cellAlign",
						value: "center",
						selected: _cellAlign == "center",
						icon: new _cellCenter(),
						diff: 6
					}),
					radioButton({
						group: "cellAlign",
						value: "right",
						selected: _cellAlign == "right",
						icon: new _cellRight(),
						diff: 6
					})
				),
	
				label("Bottom:", -30),

				hgroup(
					radioButton({
						group: "cellAlign",
						value: "bottomleft",
						selected: _cellAlign == "bottomleft",
						icon: new _cellBottomLeft(),
						diff: 6
					}),
					radioButton({
						group: "cellAlign",
						value: "bottom",
						selected: _cellAlign == "bottom",
						icon: new _cellBottom(),
						diff: 6
					}),
					radioButton({
						group: "cellAlign",
						value: "bottomright",
						selected: _cellAlign == "bottomright",
						icon: new _cellBottomRight(),
						diff: 6
					})
				)
			);

			tabLayout.layout(this);
		}

		private function getCellConfig() : CellConfig {
			var hCellAlign : String;
			var vCellAlign : String;

			switch (_cellAlign) {
				case "topleft":
					hCellAlign = Align.LEFT;
					vCellAlign = Align.TOP;
					break;
				case "top":
					hCellAlign = Align.CENTER;
					vCellAlign = Align.TOP;
					break;
				case "topright":
					hCellAlign = Align.RIGHT;
					vCellAlign = Align.TOP;
					break;
				case "left":
					hCellAlign = Align.LEFT;
					vCellAlign = Align.MIDDLE;
					break;
				case "center":
					hCellAlign = Align.CENTER;
					vCellAlign = Align.MIDDLE;
					break;
				case "right":
					hCellAlign = Align.RIGHT;
					vCellAlign = Align.MIDDLE;
					break;
				case "bottomleft":
					hCellAlign = Align.LEFT;
					vCellAlign = Align.BOTTOM;
					break;
				case "bottom":
					hCellAlign = Align.CENTER;
					vCellAlign = Align.BOTTOM;
					break;
				case "bottomright":
					hCellAlign = Align.RIGHT;
					vCellAlign = Align.BOTTOM;
					break;
			}

			return cellconfig(
				"width", _cellWidth,
				"height", _cellHeight,
				"hAlign", hCellAlign,
				"vAlign", vCellAlign
			).cellConfig;
		}

	}
}
