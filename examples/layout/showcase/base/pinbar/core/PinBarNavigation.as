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

	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowStyles;
	import com.sibirjak.asdpcbeta.window.skins.TitleBarSkin;
	import com.sibirjak.asdpcbeta.window.skins.WindowSkin;

	import org.as3commons.collections.LinkedMap;

	import flash.geom.Rectangle;

	/**
	 * @author jes 26.11.2009
	 */
	public class PinBarNavigation extends Window {

		public static var style : WindowStyles = new WindowStyles();

		public static const LAYOUT_HORIZONTAL : String = "horizontal";
		public static const LAYOUT_VERTICAL : String = "vertical";
		public static const LAYOUT_RECTANGLE : String = "rectangle";
		
		/* properties */
		private var _pinBar : PinBar;
		private var _layout : String;
		
		/* internal */
		private var _titleBarSize : uint;

		/* children */
		private var _pinBarItemContainer : PinBarButtonContainer;
		private var _disabledFrame : GlassFrame;
		
		public function PinBarNavigation() {
			setStyles([
				style.shadow, false,
				style.titleBarAlphaMoving, 1,
				style.windowIconSkin, null,
				style.minimiseOnDoubleClick, false,
	
				WindowSkin.style_backgroundLightColor, 0xDDDDDD,
				WindowSkin.style_backgroundDarkColor, 0xFFFFFF,
				WindowSkin.style_borderLightColor, 0xEEEEEE,
				WindowSkin.style_borderDarkColor, 0xBBBBBB,
	
				TitleBarSkin.style_backgroundLightColor, 0xEEEEEE,
				TitleBarSkin.style_backgroundDarkColor, 0xBBBBBB,
				TitleBarSkin.style_borderLightColor, 0xEEEEEE,
				TitleBarSkin.style_borderDarkColor, 0x999999
			]);
		}
		
		public function set pinBar(pinBar : PinBar) : void {
			_pinBar = pinBar;
		}

		public function get pinBar() : PinBar {
			return _pinBar;
		}

		public function get windows() : LinkedMap {
			return _pinBar.registeredWindows;
		}

		public function set layout(layout : String) : void {
			_layout = layout;
			
			var size : Rectangle = PinBarNavigationGeometry.getSizeByLayout(layout, _pinBar);
			setSize(size.width, size.height);
		}
		
		public function get layout() : String {
			return _layout;
		}
		
		public function set enabled(enabled : Boolean) : void {
			_disabledFrame.visible = !enabled;
		}

		public function titleBarMinimiseAllClick() : void {
			_pinBarItemContainer.minimiseAll();
		}

		public function titleBarRestoreAllClick() : void {
			_pinBarItemContainer.restoreAll(false);
		}

		public function titleBarRestoreAllKeptDown() : void {
			_pinBarItemContainer.restoreAll(true);
		}

		/*
		 * View life cycle
		 */

		override protected function init() : void {
			super.init();
			
			var buttonSize : uint = _pinBar.getStyle(PinBar.style.buttonSize);
			var buttonSpace : uint = _pinBar.getStyle(PinBar.style.buttonSpace);
			_titleBarSize = 3 * (buttonSize + buttonSpace) + buttonSpace;
		}

		override protected function draw() : void {
			super.draw();
			
			_pinBarItemContainer = new PinBarButtonContainer();
			_pinBarItemContainer.pinBarNavigation = this;
			setPinBarItemContainerSize();
			_pinBarItemContainer.visible = true;
			updateAutomatically(_pinBarItemContainer);
			addChild(_pinBarItemContainer);
			
			_disabledFrame = new GlassFrame(0xFFFFFF, .5);
			_disabledFrame.setSize(_width, _height);
			_disabledFrame.visible = false;
			addChild(_disabledFrame);
		}

		override protected function update() : void {
			super.update();
			
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				setPinBarItemContainerSize();
				_disabledFrame.setSize(_width, _height);
			}
		}

		/*
		 * Window
		 */

		override protected function getTitleBarClass() : Class {
			return NavigationTitleBar;
		}

		override protected function getTitleBarDimensions() : Rectangle {
			return PinBarNavigationGeometry.getTitleBarSizeByLayout(_layout, _pinBar);
		}

		override protected function windowStartsMoving() : void {
			_pinBar.notifyPinBarStartsMoving();
		}
		
		override protected function windowMoves() : void {
			_pinBar.notifyPinBarMoves();
		}
		
		override protected function windowStopsMoving() : void {
			_pinBar.notifyPinBarStopsMoving();
		}

		/*
		 * Private
		 */

		private function setPinBarItemContainerSize() : void {
			var size : Rectangle = PinBarNavigationGeometry.getItemContainerSizeByLayout(_layout, _pinBar);
			_pinBarItemContainer.setSize(size.width, size.height);
			_pinBarItemContainer.moveTo(size.x, size.y);
		}
		
	}
}
