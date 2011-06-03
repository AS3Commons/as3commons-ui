package popup.popup {
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import org.as3commons.ui.popup.PopUpManager;
	import flash.display.Sprite;
	import flash.events.Event;

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
				title: "PopUp " + ++_windowId
			});
			window.x = 100;
			window.y = 40;
			window.document = new WinContent();
			window.addEventListener("close", closeHandler);
			window.addEventListener(WindowEvent.MINIMISED, minimiseHandler);
			
			_popUpManager.createPopUp(window, false, true);
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
import flash.display.Shape;
import flash.events.Event;

internal class WinContent extends ControlPanelBase {
	override protected function draw() : void {
		hgroup(
			"minWidth", _width, "minHeight", _height - 10,
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

internal class ModalOverlay extends Shape {
	public function ModalOverlay() {
		with (graphics) {
			clear();
			beginFill(0x000000, .3);
			drawRect(0, 0, 100, 100);
		}
	}
}