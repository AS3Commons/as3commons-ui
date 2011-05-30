package layout.showcase.base {

	import layout.showcase.base.pinbar.PinBar;
	import layout.showcase.base.tabs.AbstractTab;
	import layout.showcase.base.tabs.AlignTab;
	import layout.showcase.base.tabs.BoxesTab;
	import layout.showcase.base.tabs.CellTab;
	import layout.showcase.base.tabs.SizeTab;

	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import org.as3commons.ui.layout.debugger.LayoutDebugger;
	import org.as3commons.ui.layout.framework.ILayout;

	import flash.display.Sprite;

	public class ShowcaseBase extends ControlPanelBase {
		
		[Embed(source="../assets/left.png")]
		private var _leftIcon : Class;
		[Embed(source="../assets/left_white.png")]
		private var _leftIconWhite : Class;
		[Embed(source="../assets/size.png")]
		private var _sizeIcon : Class;
		[Embed(source="../assets/size_white.png")]
		private var _sizeIconWhite : Class;
		[Embed(source="../assets/boxes.png")]
		private var _boxIcon : Class;
		[Embed(source="../assets/cell.png")]
		private var _cellIcon : Class;
		[Embed(source="../assets/cell_white.png")]
		private var _cellIconWhite : Class;

		public function ShowcaseBase() {
			var layout : ILayout = createLayout();
			var layoutContainer : Sprite = addChild(new Sprite()) as Sprite;
			var showcaseConfig : ShowcaseConfig = createShowcaseConfig();
			
			var debugger : LayoutDebugger = new LayoutDebugger();
			addChild(debugger);
			
			var windowContainer : WindowContainer = new WindowContainer();
			addChild(windowContainer);

			var sizeWindow : Window = new Window();
			sizeWindow.setSize(100, 100);
			sizeWindow.moveTo(360, 120);
			sizeWindow.setStyle(Window.style.windowIconSkin, _sizeIconWhite);
			sizeWindow.document = new SizeTab(layout, layoutContainer, showcaseConfig, debugger);
			sizeWindow.title = "Size";
			sizeWindow.minimisePosition = new WindowPosition(70, 0);
			windowContainer.addChild(sizeWindow);
			sizeWindow.setSize(
				AbstractTab(sizeWindow.document).tabLayout.visibleRect.width + 10,
				AbstractTab(sizeWindow.document).tabLayout.visibleRect.height + 46
			);

			var cellWindow : Window = new Window();
			cellWindow.setSize(100, 100);
			cellWindow.moveTo(280, 160);
			cellWindow.setStyle(Window.style.windowIconSkin, _cellIconWhite);
			cellWindow.document = new CellTab(layout, layoutContainer, showcaseConfig, debugger);
			cellWindow.title = "Cell";
			cellWindow.minimisePosition = new WindowPosition(210, 0);
			cellWindow.minimised = true;
			windowContainer.addChild(cellWindow);
			cellWindow.setSize(
				AbstractTab(cellWindow.document).tabLayout.visibleRect.width + 10,
				AbstractTab(cellWindow.document).tabLayout.visibleRect.height + 46
			);

			var boxWindow : Window = new Window();
			boxWindow.setSize(100, 100);
			boxWindow.moveTo(200, 200);
			boxWindow.setStyle(Window.style.windowIconSkin, _boxIcon);
			boxWindow.document = new BoxesTab(layout, layoutContainer, showcaseConfig, debugger);
			boxWindow.title = "Boxes";
			boxWindow.minimisePosition = new WindowPosition(0, 0);
			boxWindow.minimised = true;
			windowContainer.addChild(boxWindow);
			boxWindow.setSize(
				AbstractTab(boxWindow.document).tabLayout.visibleRect.width + 10,
				AbstractTab(boxWindow.document).tabLayout.visibleRect.height + 46
			);

			var alignWindow : Window = new Window();
			alignWindow.setSize(100, 100);
			alignWindow.moveTo(120, 240);
			alignWindow.setStyle(Window.style.windowIconSkin, _leftIconWhite);
			alignWindow.document = new AlignTab(layout, layoutContainer, showcaseConfig, debugger);
			alignWindow.title = "Align";
			alignWindow.minimisePosition = new WindowPosition(140, 0);
			windowContainer.addChild(alignWindow);
			alignWindow.setSize(
				AbstractTab(alignWindow.document).tabLayout.visibleRect.width + 10,
				AbstractTab(alignWindow.document).tabLayout.visibleRect.height + 46
			);

			var pinBar : PinBar = new PinBar();
			pinBar.setStyle(PinBar.style.position, Position.BOTTOM);
			
			pinBar.registerWindow(alignWindow, _leftIcon);
			pinBar.registerWindow(boxWindow, _boxIcon);
			pinBar.registerWindow(cellWindow, _cellIcon);
			pinBar.registerWindow(sizeWindow, _sizeIcon);
			
			addChild(pinBar);
			
			if (loaderInfo.parameters["path"]) { // loaded in
				pinBar.x -= 10;
				pinBar.y -= 10;
			}
		}
		
		protected function createLayout() : ILayout {
			// template method;
			return null;
		}
		
		protected function createShowcaseConfig() : ShowcaseConfig {
			// template method;
			return null;
		}
		
	}
}
