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
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import layout.showcase.base.pinbar.PinBar;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpcbeta.window.Window;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMapIterator;

	import flash.geom.Point;

	/**
	 * @author jes 27.11.2009
	 */
	public class PinBarButtonContainer extends View {
		
		/* properties */
		private var _pinBarNavigation : PinBarNavigation;
		
		public function PinBarButtonContainer() {
		}
		
		public function set pinBarNavigation(pinBarNavigation : PinBarNavigation) : void {
			_pinBarNavigation = pinBarNavigation;
		}
		
		public function minimiseAll() : void {
			var iterator : IIterator = windows.iterator();
			var pinBarButton : PinBarButton;
			while (iterator.hasNext()) {
				pinBarButton = iterator.next();
				if (!pinBarButton.selected) continue;
				
				pinBarButton.minimiseWindow();
			}
		}

		public function restoreAll(resetToStartPositions : Boolean) : void {
			var iterator : IMapIterator = windows.iterator() as IMapIterator;
			var pinBarButton : PinBarButton;
			while (iterator.hasNext()) {
				pinBarButton = iterator.next();
				
				if (resetToStartPositions) {
					pinBarButton.setStartPosition();
				} else {
					if (pinBarButton.selected) continue;
				}

			}

			// restore in reverse order of adding
			
			pinBarButton.restoreWindow();
			
			while (iterator.hasPrevious()) {
				pinBarButton = iterator.previous();
				pinBarButton.restoreWindow();
			}
		}

		/*
		 * View life cycle
		 */

		override protected function draw() : void {
			
			var buttonSize : uint = _pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSize);

			var window : Window;
			var iconSkin : Class;
			var pinBarButton : PinBarButton;
			var iterator : IMapIterator = windows.iterator() as IMapIterator;
			while (iterator.hasNext()) {
				iconSkin = iterator.next();
				window = iterator.key;

				pinBarButton = new PinBarButton();
	
				pinBarButton.setSize(buttonSize, buttonSize);
				
				pinBarButton.setStyles([
					ButtonSkin.style_overBackgroundColors, [0xFFFFFF, 0xEEEEEE],
					ButtonSkin.style_borderColors, [0xFFFFFF, 0xAAAAAA],

					ButtonSkin.style_cornerRadius, 0,

					Button.style.upSkin, null,

					Button.style.upIconSkin, iconSkin,
					Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.disabledIconSkinName, Button.UP_ICON_SKIN_NAME,
	
					Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedDisabledIconSkinName, Button.UP_ICON_SKIN_NAME,

				]);
				
				pinBarButton.toggle = true;
				pinBarButton.selected = !window.minimised;
				pinBarButton.window = window;
				
				addChild(pinBarButton);
				
				windows.replaceFor(window, pinBarButton);
			}

			layoutItems();
		}

		override protected function update() : void {
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				layoutItems();
			}
		}

		/*
		 * Private
		 */

		private function getNumRows(width : uint) : uint {
			var numRows : uint;
			
			switch (_pinBarNavigation.layout) {
				case PinBarNavigation.LAYOUT_HORIZONTAL:
					numRows = 1;
					break;
				case PinBarNavigation.LAYOUT_VERTICAL:
					numRows = windows.size;
					break;
				case PinBarNavigation.LAYOUT_RECTANGLE:
					var numItemsPerRow : uint = getNumColumns(width);
					numRows =
						windows.size % numItemsPerRow
						? Math.floor(windows.size / numItemsPerRow) + 1
						: windows.size / numItemsPerRow;
					break;
			}
			
			return numRows;
		}
		
		private function getNumColumns(width : uint) : uint {
			var buttonSize : uint = _pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSize);
			var buttonSpace : uint = _pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSpace);

			var numItemsPerRow : uint;
			
			switch (_pinBarNavigation.layout) {
				case PinBarNavigation.LAYOUT_HORIZONTAL:
					numItemsPerRow = windows.size;
					break;
				case PinBarNavigation.LAYOUT_VERTICAL:
					numItemsPerRow = 1;
					break;
				case PinBarNavigation.LAYOUT_RECTANGLE:
					var availableWidth : uint = width - buttonSpace;
					numItemsPerRow =
						availableWidth % (buttonSize + buttonSpace)
						? Math.floor(availableWidth / (buttonSize + buttonSpace))
						: availableWidth / (buttonSize + buttonSpace);
					break;
			}

			return numItemsPerRow;
		}

		private function getFirstItemPosition() : Point {
			var buttonSize : uint = _pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSize);
			var buttonSpace : uint = _pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSpace);
			var position : Point = new Point();
			
		 	var availableWidth : uint = _width - (getNumColumns(_width) * (buttonSize + buttonSpace) - buttonSpace);
			position.x = Math.round(availableWidth / 2);
			
		 	var availableHeight : uint = _height - (getNumRows(_width) * (buttonSize + buttonSpace) - buttonSpace);
			position.y = Math.round(availableHeight / 2);
			
			return position;
		}

		private function layoutItems() : void {
			
			var buttonSize : uint = _pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSize);
			var buttonSpace : uint = _pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSpace);
			
			var firstItemPosition : Point = getFirstItemPosition();

			var iterator : IIterator = windows.iterator();
			var pinBarButton : PinBarButton;
			var itemX : uint = firstItemPosition.x;
			var itemY : uint = firstItemPosition.y;
			
			while (iterator.hasNext()) {
				pinBarButton = iterator.next();
				pinBarButton.x = itemX;
				pinBarButton.y = itemY;
				
				itemX += buttonSize + buttonSpace;
				if (itemX > _width - (buttonSize + buttonSpace)) {
					itemX = firstItemPosition.x;
					itemY += buttonSize + buttonSpace;
				}
			}
		}

		private function get windows() : LinkedMap {
			return _pinBarNavigation.windows;
		}

	}
}
