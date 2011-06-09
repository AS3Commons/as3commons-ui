package layer.popup.alerttutorial.final {
	import flash.display.Sprite;
	public class ModalOverlay extends Sprite {
		public function ModalOverlay() {
			with (graphics) {
				clear();
				beginFill(0x000000, .3);
				drawRect(0, 0, 100, 100);
			}
		}
	}
}