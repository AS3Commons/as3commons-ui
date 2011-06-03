package popup.popup {
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import com.sibirjak.asdpcbeta.window.Window;
	import org.as3commons.ui.popup.PopUpManager;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ModalPopUp extends ControlPanelBase {
		private var _popUpManager : PopUpManager;
		private var _windowId : uint;

		public function ModalPopUp() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);

			addChild(
				labelButton({
					label: "add",
					click: addHandler
				})
			);
		}
		
		private function addHandler() : void {
			var window : Window = window({
				x: 100, y: 40, w: 260, h: 120,
				title: "PopUp " + ++_windowId,
				minimised: true
			});
			window.document = new WinContent();
			window.addEventListener("close", closeHandler);
			window.addEventListener(WindowEvent.MINIMISED, minimiseHandler);
			
			_popUpManager.createPopUp(window, false, true);
			window.restore();
		}

		private function closeHandler(event : Event) : void {
			Window(event.currentTarget).minimise();
		}
		
		private function minimiseHandler(event : WindowEvent) : void {
			Window(event.currentTarget).removeEventListener(WindowEvent.MINIMISED, minimiseHandler);
			_popUpManager.removePopUp(_popUpManager.popUpOnTop);
		}
	}
}

import org.as3commons.ui.layout.constants.Align;
import org.as3commons.ui.layout.shortcut.hgroup;
import flash.events.Event;

internal class WinContent extends ControlPanelBase {
	override protected function draw() : void {
		hgroup(
			"minWidth", _width, "minHeight", _height - 5,
			"hAlign", Align.CENTER, "vAlign", Align.BOTTOM,
			labelButton({
				label: "close",
				click: function() : void {
					dispatchEvent(new Event("close", true));
				}
			})
			
		).layout(this);
	}
}