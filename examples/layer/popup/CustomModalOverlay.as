package layer.popup {
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import flash.display.Sprite;
	import org.as3commons.ui.layer.PopUpManager;

	public class CustomModalOverlay extends ControlPanelBase {
		private var _popUpManager : PopUpManager;
		private var _windowId : uint;

		public function CustomModalOverlay() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			_popUpManager.modalOverlay = ModalOverlay;

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
			window.addEventListener(WindowEvent.MINIMISED, minimiseHandler);
			
			_popUpManager.createPopUp(window, false, true);
			window.restore();
		}

		private function minimiseHandler(event : WindowEvent) : void {
			Window(event.currentTarget).removeEventListener(WindowEvent.MINIMISED, minimiseHandler);
			_popUpManager.removePopUp(_popUpManager.popUpOnTop);
		}
	}
}

import com.sibirjak.asdpcbeta.window.Window;
import org.as3commons.ui.layout.constants.Align;
import org.as3commons.ui.layout.shortcut.hgroup;
import flash.display.Sprite;

internal class WinContent extends ControlPanelBase {
	override protected function draw() : void {
		hgroup(
			"minWidth", _width, "minHeight", _height - 5,
			"hAlign", Align.CENTER, "vAlign", Align.BOTTOM,
			labelButton({
				label: "close",
				click: function() : void {
					Window(parent).minimise();
				}
			})
			
		).layout(this);
	}
}

internal class ModalOverlay extends Sprite {
	public function ModalOverlay() {
		with (graphics) {
			clear();
			beginFill(0x000000, .3);
			drawRect(0, 0, 100, 100);
		}
	}
}