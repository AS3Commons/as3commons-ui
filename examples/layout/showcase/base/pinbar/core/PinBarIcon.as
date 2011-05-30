/**
 * ActionScript Data Provider Controls
 * 
 * Copyright (c) 2010 Jens Struwe, http://www.sibirjak.com/
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package layout.showcase.base.pinbar.core {
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;

	import flash.display.Shape;

	/**
	 * @author jes 27.11.2009
	 */
	public class PinBarIcon extends View {
		
		public static const style_color : String = "pinBarIcon_color";
		public static const style_backgroundColor : String = "pinBarIcon_backgroundColor";
		public static const style_backgroundAlpha : String = "pinBarIcon_backgroundAlpha";
		public static const style_borderColor : String = "pinBarIcon_borderColor";
		public static const style_borderSize : String = "pinBarIcon_borderSize";
		public static const style_borderAlpha : String = "pinBarIcon_borderAlpha";
		public static const style_size : String = "pinBarIcon_size";

		private var _icon : Shape;
		private var _background : Shape;
		
		public function PinBarIcon() {
			
			setDefaultStyles([
				style_color, 0xCCCCCC,
				style_backgroundColor, 0xFFFFFF,
				style_backgroundAlpha, 1,
				style_borderColor, 0xCCCCCC,
				style_borderSize, 1,
				style_borderAlpha, 1
			]);
		}
		
		public function set direction(direction : String) : void {
			switch (direction) {
				case Position.TOP:
					_icon.rotation = 180;
					break;
				case Position.RIGHT:
					_icon.rotation = -90;
					break;
				case Position.BOTTOM:
					_icon.rotation = 0;
					break;
				case Position.LEFT:
					_icon.rotation = 90;
					break;
			}
			
			visible = direction != Position.MIDDLE;
		}

		override protected function draw() : void {
			
			var radius : uint = _width / 2;
			var iconSize : uint = Math.round(radius / 3);
			iconSize += iconSize % 2; // even number
			var borderSize : uint = getStyle(style_borderSize);

			_background = new Shape();
			
			with (_background.graphics) {
				lineStyle(borderSize, getStyle(style_borderColor), getStyle(style_borderAlpha));
				beginFill(getStyle(style_backgroundColor), getStyle(style_backgroundAlpha));
				drawCircle(radius, radius, radius - borderSize);
			}
			
			addChild(_background);
			
			_icon = new Shape();
			

			with (_icon.graphics) {

				beginFill(getStyle(style_color));
				moveTo(- iconSize, - iconSize + 1);
				lineTo(iconSize, - iconSize + 1);
				lineTo(0, iconSize - 1);
				lineTo(- iconSize, - iconSize + 1);
				
			}
			
			_icon.x = _icon.y = radius;

			addChild(_icon);
			
			
			
		}


	}
}
