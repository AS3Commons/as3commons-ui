package org.as3commons.ui.popup.popup {

	import flash.display.Shape;

	/**
	 * @author Jens Struwe 02.02.2011
	 */
	public class DefaultModalOverlay extends Shape	 {

		public function DefaultModalOverlay() {
			with (graphics) {
				clear();
				beginFill(0xFFFFFF, .5);
				drawRect(0, 0, 100, 100);
			}
		}

	}
}