package org.as3commons.ui.popup.popup {

	import flash.display.Sprite;

	/**
	 * Mouse sensitive transparent rectangular area.
	 * 
	 * The DefaultModalOverlay subclasses Sprite rather than Shape in order to be mouse sensitive.
	 * 
	 * @author Jens Struwe 02.02.2011
	 */
	public class DefaultModalOverlay extends Sprite	 {

		public function DefaultModalOverlay() {
			with (graphics) {
				clear();
				beginFill(0xFFFFFF, .5);
				drawRect(0, 0, 100, 100);
			}
		}

	}
}