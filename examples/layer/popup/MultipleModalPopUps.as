package layer.popup {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.as3commons.ui.layer.PopUpManager;

	public class MultipleModalPopUps extends ControlPanelBase {
		private var _popUpManager : PopUpManager;
		private var _windowId : uint;
		private var _startPosition : uint;
		private var _addButton : Button;

		public function MultipleModalPopUps() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_popUpManager = new PopUpManager(container);
			
			_addButton = addChild(labelButton({
				label: "add",
				click: addHandler
			})) as Button;
		}
		
		private function addHandler(event : Event = null) : void {
			_startPosition += 30;
			if (_startPosition > 170) _startPosition = 30;

			var window : Window = window({
				x: _startPosition * 2, y: _startPosition, w: 200, h: 120,
				title: "PopUp " + ++_windowId,
				minimised: true
			});
			window.document = new WinContent();
			window.addEventListener("add", addHandler);
			window.addEventListener(WindowEvent.MINIMISED, minimiseHandler);
			
			_popUpManager.createPopUp(window, false, true);
			window.restore();
		}

		private function minimiseHandler(event : WindowEvent) : void {
			var window : Window = event.currentTarget as Window;
			window.removeEventListener("add", addHandler);
			window.removeEventListener(WindowEvent.MINIMISED, minimiseHandler);
			_popUpManager.removePopUp(window);
		}
	}
}

import com.sibirjak.asdpcbeta.window.Window;
import org.as3commons.ui.layout.constants.Align;
import org.as3commons.ui.layout.shortcut.vgroup;
import flash.events.Event;

internal class WinContent extends ControlPanelBase {
	override protected function draw() : void {
		vgroup(
			"minWidth", _width, "minHeight", _height - 5,
			"marginX", 5, "vAlign", Align.BOTTOM, "gap", 5,
			labelButton({
				w: 46,
				label: "add",
				click: function() : void {
					dispatchEvent(new Event("add", true));
				}
			}),
			labelButton({
				w: 46,
				label: "close",
				click: function() : void {
					Window(parent).minimise();
				}
			})
		).layout(this);
	}
}