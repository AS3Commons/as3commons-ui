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
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import layout.showcase.base.pinbar.PinBar;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.tooltip.ToolTip;
	import com.sibirjak.asdpcbeta.window.core.ITitleBar;
	import com.sibirjak.asdpcbeta.window.core.TitleBar;

	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author jes 26.11.2009
	 */
	public class NavigationTitleBar extends TitleBar implements ITitleBar {
		
		/* styles */
		public static const style_iconColor : String = "navigationTitleBar_iconColor";
		public static const style_moveIconSkin : String = "navigationTitleBar_moveIconSkin";
		public static const style_minimiseAllIconSkin : String = "navigationTitleBar_minimiseAllIconSkin";
		public static const style_restoreAllIconSkin : String = "navigationTitleBar_restoreAllIconSkin";
		public static const style_toolTipButtonIconSkin : String = "navigationTitleBar_toolTipButtonIconSkin";
		
		/* children */
		private var _moveIcon : DisplayObject;
		private var _hideButton : IButton;
		private var _showButton : IButton;
		private var _toolTipButton : IButton;
		
		/* internal */
		private  var _timer : Timer;

		/* assets */
		[Embed(source="../assets/move.png")]
		protected var _moveIconSkin : Class;
		[Embed(source="../assets/minimise_all.gif")]
		private var _minimiseAllIconSkin : Class;
		[Embed(source="../assets/restore_all.gif")]
		private var _restoreAllIconSkin : Class;
		[Embed(source="../assets/tooltip.png")]
		private var _toolTipsIconSkin : Class;
		
		public function NavigationTitleBar() {

			setDefaultStyles([
				style_moveIconSkin, _moveIconSkin,
				style_minimiseAllIconSkin, _minimiseAllIconSkin,
				style_restoreAllIconSkin, _restoreAllIconSkin,
				style_toolTipButtonIconSkin, _toolTipsIconSkin,
				style_iconColor, 0xA3A3A3
			]);
		}

		/*
		 * View life cycle
		 */

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			_hideButton.removeEventListener(ButtonEvent.MOUSE_DOWN, minimiseAllButtonMouseDownHandler);

			_showButton.removeEventListener(ButtonEvent.MOUSE_DOWN, restoreAllButtonMouseDownHandler);
			_showButton.removeEventListener(ButtonEvent.CLICK, restoreAllButtonClickHandler);

			if (_timer) _timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}

		/*
		 * TitleBar
		 */

		override protected function createButtons() : void {
			var iconColor : uint = getStyle(style_iconColor);
			
			_moveIcon = new (getStyle(style_moveIconSkin))();
			DisplayObjectAdapter.colorise(_moveIcon, iconColor);
			addChild(_moveIcon);
			
			var buttonSize : uint = pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSize);
			var buttonStyles : Array = [
				ButtonSkin.style_overBackgroundColors, [0xEEEEEE, 0xBBBBBB],
				ButtonSkin.style_borderColors, [0xF5F5F5, 0x999999],

				ButtonSkin.style_cornerRadius, 1,

				Button.style.upSkin, null,
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
				
				Button.style.coloriseIcon, true,
				Button.style.iconColor, iconColor
			];

			_hideButton = new Button();
			_hideButton.setSize(buttonSize, buttonSize);
			_hideButton.setStyles(buttonStyles);
			_hideButton.setStyle(Button.style.upIconSkin, getStyle(style_minimiseAllIconSkin));
			_hideButton.toolTip = "Minimise all";
			_hideButton.addEventListener(ButtonEvent.MOUSE_DOWN, minimiseAllButtonMouseDownHandler);
			addChild(DisplayObject(_hideButton));

			_showButton = new Button();
			_showButton.setSize(buttonSize, buttonSize);
			_showButton.setStyles(buttonStyles);
			_showButton.setStyle(Button.style.upIconSkin, getStyle(style_restoreAllIconSkin));
			_showButton.toolTip = "Restore all\n\nKeep mouse pressed to reset all window positions";
			_showButton.addEventListener(ButtonEvent.MOUSE_DOWN, restoreAllButtonMouseDownHandler);
			_showButton.addEventListener(ButtonEvent.CLICK, restoreAllButtonClickHandler);
			addChild(DisplayObject(_showButton));

			_toolTipButton = new Button();
			_toolTipButton.setSize(buttonSize, buttonSize);
			_toolTipButton.toggle = true;
			_toolTipButton.selected = true;
			_toolTipButton.toolTip = "Tooltips disabled";
			_toolTipButton.selectedToolTip = "Tooltips enabled";
			_toolTipButton.setStyles(buttonStyles);
			_toolTipButton.setStyles([
				Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.upIconSkin, getStyle(style_toolTipButtonIconSkin)
			]);
			ToolTip.master = _toolTipButton as DisplayObject;
			_toolTipButton.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, ToolTip, "enabled");
			addChild(DisplayObject(_toolTipButton));
		}
		
		override protected function layoutButtons() : void {
			var buttonSize : uint = pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSize);
			var buttonSpace : uint = pinBarNavigation.pinBar.getStyle(PinBar.style.buttonSpace);

			var diffXMoveIcon : uint = Math.round(buttonSize - _moveIcon.width) / 2;
			
			// horizontal
			if (_width > _height) {
				var y : uint = Math.round((_height - buttonSize) / 2);

				
				DisplayObjectAdapter.moveTo(_moveIcon, buttonSpace + diffXMoveIcon, y + diffXMoveIcon);
				_hideButton.moveTo(buttonSpace + (buttonSpace + buttonSize), y);
				_showButton.moveTo(buttonSpace + 2 * (buttonSpace + buttonSize), y);
				_toolTipButton.moveTo(buttonSpace + 3 * (buttonSpace + buttonSize), y);

			// vertical
			} else {
				var x : uint = Math.round((_width - buttonSize) / 2);

				DisplayObjectAdapter.moveTo(_moveIcon, x + diffXMoveIcon, buttonSpace + diffXMoveIcon);
				_hideButton.moveTo(x, buttonSpace + (buttonSpace + buttonSize));
				_showButton.moveTo(x, buttonSpace + 2 * (buttonSpace + buttonSize));
				_toolTipButton.moveTo(x, buttonSpace + 3 * (buttonSpace + buttonSize));
			}
		}

		/*
		 * Private
		 */

		private function get pinBarNavigation() : PinBarNavigation {
			return _window as PinBarNavigation;
		}
			

		/*
		 * Events
		 */

		private function minimiseAllButtonMouseDownHandler(event : ButtonEvent) : void {
			PinBarNavigation(_window).titleBarMinimiseAllClick();
		}

		private function restoreAllButtonMouseDownHandler(event : ButtonEvent) : void {
			PinBarNavigation(_window).titleBarRestoreAllClick();
			
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}
		
		private function timerHandler(event : TimerEvent) : void {
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			PinBarNavigation(_window).titleBarRestoreAllKeptDown();
		}

		private function restoreAllButtonClickHandler(event : ButtonEvent) : void {
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}

	}
}
