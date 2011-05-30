package layout.showcase.base.tabs {

	import layout.showcase.base.ShowcaseConfig;

	import org.as3commons.ui.layout.debugger.LayoutDebugger;
	import org.as3commons.ui.layout.framework.ILayout;

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 29.03.2011
	 */
	public class AbstractTab extends ControlPanelBase {
		
		protected var _layout : ILayout;
		protected var _layoutContainer : Sprite;
		protected var _config : ShowcaseConfig;
		protected var _debugger : LayoutDebugger;
		
		public var tabLayout : ILayout;

		public function AbstractTab(layout : ILayout, layoutContainer : Sprite, config : ShowcaseConfig, debugger : LayoutDebugger) {
			_layout = layout;
			_layoutContainer = layoutContainer;
			_config = config;
			_debugger = debugger;
		}
		
		protected function updateLayout() : void {
			with (_layoutContainer.graphics) {
				clear();
				beginFill(0xF6F6F6);
				drawRect(_layout.position.x, _layout.position.y, _layout.minWidth, _layout.minHeight);
			}

			_layout.layout(_layoutContainer, true);
			
			_debugger.debug(_layout);
		}
		
	}
}
