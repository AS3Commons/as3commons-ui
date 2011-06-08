package org.as3commons.ui.layer.popup {

	import flash.display.Sprite;

	/**
	 * Simple modal overlay class.
	 * 
	 * <p>The class extends Sprite in order to be mouse sensitiv.</p>
	 * 
	 * @author Jens Struwe 02.02.2011
	 */
	public class DefaultModalOverlay extends Sprite	 {

		/**
		 * DefaultModalOverlay constructor.
		 */
		public function DefaultModalOverlay() {
			with (graphics) {
				clear();
				beginFill(0xFFFFFF, .5);
				drawRect(0, 0, 100, 100);
			}
		}

	}
}