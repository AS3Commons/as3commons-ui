package layer.popup {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpcbeta.window.Window;
	import flash.display.Sprite;
	import org.as3commons.ui.layer.PopUpManager;
	import org.as3commons.ui.layout.shortcut.hgroup;

	public class SimplePopUp extends ControlPanelBase {
		private var _popUpManager : PopUpManager;
		private var _window : Window;
		private var _centerButton : Button;
		
		public function SimplePopUp() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);

			_centerButton = labelButton({
				label: "center",
				visible: false,
				click: centerHandler
			});
			
			_window = window({
				title: "PopUp",
				minimise: false
			});
			
			hgroup(
				"gap", 6,
				labelButton({
					toggle: true,
					label: "show",
					selectedlabel: "hide",
					change: showHideHandler
				}),
				_centerButton
			).layout(this);
		}
		
		private function showHideHandler(selected : Boolean) : void {
			if (selected) {
				_popUpManager.createPopUp(_window);
				_window.x = _window.y = 50;
			} else {
				_popUpManager.removePopUp(_window);
			}
			_centerButton.visible = selected;
		}

		private function centerHandler() : void {
			_popUpManager.center(_window);
		}
	}
}