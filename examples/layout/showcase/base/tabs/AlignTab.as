package layout.showcase.base.tabs {

	import layout.showcase.base.ShowcaseConfig;

	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.debugger.LayoutDebugger;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.layout.shortcut.vgroup;

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 29.03.2011
	 */
	public class AlignTab extends AbstractTab {

		[Embed(source="../../assets/left.png")]
		private var _left : Class;
		[Embed(source="../../assets/center.png")]
		private var _center : Class;
		[Embed(source="../../assets/right.png")]
		private var _right : Class;
		[Embed(source="../../assets/justify_h.png")]
		private var _justifyH : Class;

		[Embed(source="../../assets/top.png")]
		private var _top : Class;
		[Embed(source="../../assets/middle.png")]
		private var _middle : Class;
		[Embed(source="../../assets/bottom.png")]
		private var _bottom : Class;
		[Embed(source="../../assets/justify_v.png")]
		private var _justifyV : Class;

		public function AlignTab(layout : ILayout, layoutContainer : Sprite, config : ShowcaseConfig, debugger : LayoutDebugger) {
			super(layout, layoutContainer, config, debugger);

			tabLayout = vgroup(
				"offsetX", 4,
				"offsetY", 8,
				"gap", 4,
				
				hgroup(
					label("H:", -60),
					radioGroup(
						"hAlign",
						function(align : String) : void {
							_layout.hAlign = align;
							updateLayout();
						}
					),
					radioButton({
						group: "hAlign",
						value: Align.LEFT,
						selected: _layout.hAlign == Align.LEFT,
						icon: new _left(),
						diff: 6
					}),
	
					radioButton({
						group: "hAlign",
						value: Align.CENTER,
						selected: _layout.hAlign == Align.CENTER,
						icon: new _center(),
						diff: 6
					}),
					radioButton({
						group: "hAlign",
						value: Align.RIGHT,
						selected: _layout.hAlign == Align.RIGHT,
						icon: new _right(),
						diff: 6
					}),
					radioButton({
						group: "hAlign",
						value: Align.JUSTIFY,
						selected: _layout.hAlign == Align.JUSTIFY,
						icon: new _justifyH(),
						diff: 6
					})
				),
				
				hgroup(
					label("V:", -60),
					radioGroup(
						"vAlign",
						function(align : String) : void {
							_layout.vAlign = align;
							updateLayout();
						}
					),
					radioButton({
						group: "vAlign",
						value: Align.TOP,
						selected: _layout.vAlign == Align.TOP,
						icon: new _top(),
						diff: 6
					}),
					radioButton({
						group: "vAlign",
						value: Align.MIDDLE,
						selected: _layout.vAlign == Align.MIDDLE,
						icon: new _middle(),
						diff: 6
					}),
					radioButton({
						group: "vAlign",
						value: Align.BOTTOM,
						selected: _layout.vAlign == Align.BOTTOM,
						icon: new _bottom(),
						diff: 6
					}),
					radioButton({
						group: "vAlign",
						value: Align.JUSTIFY,
						selected: _layout.vAlign == Align.JUSTIFY,
						icon: new _justifyV(),
						diff: 10
					})
				)

			);

			tabLayout.layout(this);
		}


	}
}
