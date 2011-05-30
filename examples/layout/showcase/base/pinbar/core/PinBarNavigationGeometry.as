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
	import layout.showcase.base.pinbar.PinBar;

	import flash.geom.Rectangle;

	/**
	 * @author jes 27.11.2009
	 */
	public class PinBarNavigationGeometry {
		
		public static function getSizeByLayout(layout : String, pinBarContainer : PinBar) : Rectangle {
			var titleBarSize : Rectangle = getTitleBarSizeByLayout(layout, pinBarContainer);
			var itemContainerSize : Rectangle = getItemContainerSizeByLayout(layout, pinBarContainer);

			var rectangle : Rectangle = new Rectangle();

			switch (layout) {
				case PinBarNavigation.LAYOUT_HORIZONTAL:
					rectangle.width = titleBarSize.width + itemContainerSize.width;
					rectangle.height = titleBarSize.height;
					break;
				case PinBarNavigation.LAYOUT_VERTICAL:
				case PinBarNavigation.LAYOUT_RECTANGLE:
					rectangle.width = titleBarSize.width;
					rectangle.height = titleBarSize.height + itemContainerSize.height;
					break;
			}
		
			return rectangle;
			
		}
		
		public static function getTitleBarSizeByLayout(layout : String, pinBarContainer : PinBar) : Rectangle {
			var pinBarSize : uint = pinBarContainer.getStyle(PinBar.style.size);
			var buttonSize : uint = pinBarContainer.getStyle(PinBar.style.buttonSize);
			var buttonSpace : uint = pinBarContainer.getStyle(PinBar.style.buttonSpace);

			var titleBarSize : uint = 4 * (buttonSize + buttonSpace) + buttonSpace;

			var rectangle : Rectangle = new Rectangle();

			switch (layout) {
				case PinBarNavigation.LAYOUT_HORIZONTAL:
				case PinBarNavigation.LAYOUT_RECTANGLE:
					rectangle.width = titleBarSize;
					rectangle.height = pinBarSize;
					break;
				case PinBarNavigation.LAYOUT_VERTICAL:
					rectangle.width = pinBarSize;
					rectangle.height = titleBarSize;
					break;
			}

			return rectangle;
		}

		public static function getItemContainerSizeByLayout(layout : String, pinBarContainer : PinBar) : Rectangle {
			var pinBarSize : uint = pinBarContainer.getStyle(PinBar.style.size);
			var buttonSize : uint = pinBarContainer.getStyle(PinBar.style.buttonSize);
			var buttonSpace : uint = pinBarContainer.getStyle(PinBar.style.buttonSpace);
			var numItems : uint = pinBarContainer.registeredWindows.size;

			var titleBarSize : Rectangle = getTitleBarSizeByLayout(layout, pinBarContainer);

			var rectangle : Rectangle = new Rectangle();
			
			switch (layout) {
				 case PinBarNavigation.LAYOUT_HORIZONTAL:
				 	rectangle.x = titleBarSize.width;
				 	rectangle.y = 0;

				 	rectangle.width = numItems * (buttonSize + buttonSpace) + buttonSpace;
				 	rectangle.height = pinBarSize;
					break;
				 case PinBarNavigation.LAYOUT_VERTICAL:
				 	rectangle.x = 0;
				 	rectangle.y = titleBarSize.height;

				 	rectangle.width = pinBarSize;
				 	rectangle.height = numItems * (buttonSize + buttonSpace) + buttonSpace;
					break;
				 case PinBarNavigation.LAYOUT_RECTANGLE:
				 	rectangle.x = 0;
				 	rectangle.y = titleBarSize.height;

				 	rectangle.width = titleBarSize.width;

					var availableWidth : uint = rectangle.width - buttonSpace;
					var numItemsPerRow : uint =
						availableWidth % (buttonSize + buttonSpace)
						? Math.floor(availableWidth / (buttonSize + buttonSpace))
						: availableWidth / (buttonSize + buttonSpace);
					var numRows : uint =
						numItems % numItemsPerRow
						? Math.floor(numItems / numItemsPerRow) + 1
						: numItems / numItemsPerRow;

					rectangle.height = numRows * (buttonSize + buttonSpace) + buttonSpace;

					break;
			}

			return rectangle;
		}
	}
}
