package org.as3commons.ui.popup.popup {

	import flash.display.Sprite;

	/**
	 * Mouse sensitive transparent rectangular area.
	 * 
	 * <p>The GlassFrame automatically redraws after each resize operation.</p>
	 * 
	 * <p>The GlassFrame subclasses Sprite rather than Shape in order to be mouse sensitive.</p>
	 * 
 	 * <listing>
		_disabledFrame = new GlassFrame(0xFFFFFF, .5); // sets color and alpha
		_disabledFrame.setSize(_width, _height); // initially draws the frame
		addChild(_disabledFrame);
		...
		_disabledFrame.setSize(newWidth, newHeight); // immediately redraws the frame
	 * </listing>
	 * 
	 * @author Jens Struwe 02.02.2011
	 */
	public class DefaultModalOverlay extends Sprite	 {

		/**
		 * The color.
		 */
		private var _color : uint;

		/**
		 * The alpha.
		 */
		private var _alpha : Number;

		/**
		 * GlassFrame constructor.
		 * 
		 * <p>If an alpha value != 0 is passed, the GlassFrame becomes visible.</p>
		 * 
		 * @param color The background color.
		 * @param alpha The background alpha.
		 */
		public function DefaultModalOverlay(color : uint = 0xFFFFFF, alpha : Number = .5) {
			_color = color;
			_alpha = alpha;
		}
		
		/**
		 * Draws or redraws the GlassFrame with the specified dimensions.
		 * 
		 * @param width The frame width.
		 * @param height The frame height.
		 */
		public function setSize(width : uint, height : uint) : void {
			with (graphics) {
				clear();
				beginFill(_color, _alpha);
				drawRect(0, 0, width, height);
			}
		}

	}
}
