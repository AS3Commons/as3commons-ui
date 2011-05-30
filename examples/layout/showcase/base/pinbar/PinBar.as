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
package layout.showcase.base.pinbar {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Sine;
	import layout.showcase.base.pinbar.core.PinBarButton;
	import layout.showcase.base.pinbar.core.PinBarIcon;
	import layout.showcase.base.pinbar.core.PinBarNavigation;
	import layout.showcase.base.pinbar.core.PinBarNavigationGeometry;
	import layout.showcase.base.pinbar.core.Pointer;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IMapIterator;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jes 26.11.2009
	 */
	public class PinBar extends View {

		/* style declarations */
		public static var style : PinBarStyles = new PinBarStyles();

		/* internals */
		private var _lastFixPinBarPosition : String = Position.MIDDLE;
		private var _currentPinBarPosition : String = Position.MIDDLE;
		private var _registeredWindows : LinkedMap;
		private var _open : Boolean;
		private var _leaveOpenOnMouseOut : Boolean = false;
		private var _navigationTween : GTween;
		private var _windowOverNavigationArea : Boolean;
		private var _movingWindow : MovingWindow;
		
		
		/* children */
		private var _navigationArea : Shape;
		private var _disabledFrame : GlassFrame;

		private var _navigationContainer : Sprite;
		private var _navigation : PinBarNavigation;
		private var _pinBarIcon : PinBarIcon;

		private var _pointerContainer : Sprite;
		private var _pointer : Pointer;

		public function PinBar() {
			
			setDefaultStyles([
				style.position, Position.TOP,
				
				style.size, 30,
				style.snapAreaSize, 60,
				
				style.buttonSize, 20,
				style.buttonSpace, 6
			]);
			
			_registeredWindows = new LinkedMap();
			
			addEventListener(PinBarButton.EVENT_CLIENT_MINIMISING, windowMinismisingHandler);
		}
		
		/*
		 * PinBar
		 */

		public function registerWindow(window : Window, iconSkin : Class) : void {
			window.addEventListener(WindowEvent.START_DRAG, windowStartsMovingHandler);

			_registeredWindows.add(window, iconSkin);
		}
		
		public function get registeredWindows() : LinkedMap {
			return _registeredWindows;
		}

		public function get numWindows() : uint {
			return _registeredWindows.size;
		}

		public function notifyPinBarStartsMoving() : void {
			drawSnapArea(_lastFixPinBarPosition);
			_navigationArea.visible = true;
			_disabledFrame.visible = true;
		}

		public function notifyPinBarMoves() : void {
			var position : String = _currentPinBarPosition;
			var snapAreaSize : uint = getStyle(style.snapAreaSize);
			
			/*
			 * Test if the pin bar should snap to a side.
			 */
			
			// test snap out
			
			var rectangleLayoutSize : Rectangle = PinBarNavigationGeometry.getSizeByLayout(PinBarNavigation.LAYOUT_RECTANGLE, this);

			if (position != Position.MIDDLE) {
				var snapOut : Boolean = false;
				switch (position) {
					case Position.LEFT:
						if (_navigation.x > snapAreaSize) snapOut = true;
						break;
					case Position.RIGHT:
						if (_navigation.x + rectangleLayoutSize.width < _width - snapAreaSize) snapOut = true;
						break;
					case Position.TOP:
						if (_navigation.y > snapAreaSize) snapOut = true;
						break;
					case Position.BOTTOM:
						if (_navigation.y + rectangleLayoutSize.height < _height - snapAreaSize) snapOut = true;
						break;
				}
				if (snapOut) position = Position.MIDDLE;
			}

			// test snap in
			
			if (position == Position.MIDDLE) {
				if (_navigation.x < snapAreaSize) {
					position = Position.LEFT;
				} else if (_navigation.x + rectangleLayoutSize.width > _width - snapAreaSize) {
					position = Position.RIGHT;
				} else if (_navigation.y < snapAreaSize) {
					position = Position.TOP;
				} else if (_navigation.y + rectangleLayoutSize.height > _height - snapAreaSize) {
					position = Position.BOTTOM;
				}
			}
			
			/*
			 * Switch the pin bar layout if position changes.
			 */

			if (position != _currentPinBarPosition) {

				setPinBarLayout(position);
				_navigation.validateNow();

				if (position == Position.MIDDLE) {
					drawSnapArea(_lastFixPinBarPosition);
				} else {
					drawSnapArea(position);
				}

				_navigationArea.visible = true;
			}
				
			/*
			 * Fix pin bar position
			 */

			setPinBarPosition(position, true);

			_currentPinBarPosition = position;

		}
		
		public function notifyPinBarStopsMoving() : void {
			
			if (_currentPinBarPosition == Position.MIDDLE) {
				setPinBarLayout(_lastFixPinBarPosition);
				setPinBarPosition(_lastFixPinBarPosition, true);
			} else {
				_lastFixPinBarPosition = _currentPinBarPosition;
			}

			_navigationArea.visible = false;
			_disabledFrame.visible = false;
		}

		/*
		 * View life cycle
		 */

		override protected function init() : void {
			_width = stage.stageWidth;
			_height = stage.stageHeight;
			
			_lastFixPinBarPosition = getStyle(style.position);

			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
		
		override protected function draw() : void {
			
			_disabledFrame = new GlassFrame(0xFFFFFF, .7);
			_disabledFrame.setSize(_width, _height);
			_disabledFrame.visible = false;
			addChild(_disabledFrame);

			_navigationArea = new Shape();
			drawSnapArea(_lastFixPinBarPosition);
			_navigationArea.visible = false;
			addChild(_navigationArea);

			var iconSize : uint = Math.round(2 * getStyle(style.size) / 3);
			iconSize += iconSize % 2; // even number
			_pinBarIcon = new PinBarIcon();
			_pinBarIcon.setSize(iconSize, iconSize);
			addChild(_pinBarIcon);
			
			// separate navigation window
			_navigationContainer = new Sprite();
			addChild(_navigationContainer);

			_navigation = new PinBarNavigation();
			_navigation.pinBar = this;

			setPinBarLayout(_lastFixPinBarPosition);
			_navigation.x = (_width - _navigation.width) / 2;
			_navigation.y = (_height - _navigation.height) / 2;
			setPinBarPosition(_lastFixPinBarPosition, false);
			
			_navigationContainer.addChild(_navigation);

			_navigationTween = new GTween(_navigation, .2);
			_navigationTween.paused = true;

			// pointer container

			_pointerContainer = new Sprite();
			_pointer = new Pointer();
			_pointer.setSize(16, 16);
			_pointer.visible = false;
			_pointerContainer.addChild(_pointer);
			addChild(_pointerContainer);
		}

		override protected function cleanUpCalled() : void {
			
			removeEventListener(PinBarButton.EVENT_CLIENT_MINIMISING, windowMinismisingHandler);

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			
			var window : Window;
			var iterator : IMapIterator = _registeredWindows.iterator() as IMapIterator;
			while (iterator.hasNext()) {
				iterator.next();
				window = iterator.key;

				window.removeEventListener(WindowEvent.STOP_DRAG, windowStopsMovingHandler);
				window.removeEventListener(WindowEvent.START_DRAG, windowStartsMovingHandler);
			}
			
		}

		/*
		 * Private
		 */

		private function getPinBarPosition(position : String, open : Boolean) : Point {
			
			var pinBarSize : uint = getStyle(style.size);
			
			var pinBarPosition : Point = new Point(_navigation.x, _navigation.y);

			switch (position) {
				case Position.LEFT:
					pinBarPosition.x = open ? 0 : - pinBarSize;

					pinBarPosition.y = Math.max(0, _navigation.y);
					pinBarPosition.y = Math.min(_height - _navigation.height, pinBarPosition.y);
					break;
				case Position.RIGHT:
					pinBarPosition.x = _width - _navigation.width;
					if (!open) pinBarPosition.x += pinBarSize;

					pinBarPosition.y = Math.max(0, _navigation.y);
					pinBarPosition.y = Math.min(_height - _navigation.height, pinBarPosition.y);
					break;
				case Position.TOP:
					pinBarPosition.x = Math.max(0, _navigation.x);
					pinBarPosition.x = Math.min(_width - _navigation.width, pinBarPosition.x);

					pinBarPosition.y = open ? 0 : - pinBarSize;
					break;
				case Position.BOTTOM:
					pinBarPosition.x = Math.max(0, _navigation.x);
					pinBarPosition.x = Math.min(_width - _navigation.width, pinBarPosition.x);

					pinBarPosition.y = _height - _navigation.height;
					if (!open) pinBarPosition.y += pinBarSize;
					break;
			}
			
			return pinBarPosition;
		}

		private function setPinBarPosition(position : String, open : Boolean) : void {
			var pinBarPosition : Point = getPinBarPosition(position, open);
			_navigation.x = pinBarPosition.x;
			_navigation.y = pinBarPosition.y;
			_pinBarIcon.x = _navigation.x + Math.round((_navigation.width - _pinBarIcon.width) / 2);
			_pinBarIcon.y = _navigation.y + Math.round((_navigation.height - _pinBarIcon.height) / 2);

			switch (position) {
				case Position.LEFT:
					_pinBarIcon.x = 2;
					_pinBarIcon.y = _navigation.y + 4;
					break;
				case Position.RIGHT:
					_pinBarIcon.x = _width - _pinBarIcon.width - 2;
					_pinBarIcon.y = _navigation.y + 4;
					break;
				case Position.TOP:
					_pinBarIcon.x = _navigation.x + 4;
					_pinBarIcon.y = 2;
					break;
				case Position.BOTTOM:
					_pinBarIcon.x = _navigation.x + 4;
					_pinBarIcon.y = _height - _pinBarIcon.height - 2;
					break;
			}
			
		}

		private function setPinBarLayout(position : String) : void {
			switch (position) {
				case Position.LEFT:
				case Position.RIGHT:
					_navigation.layout = PinBarNavigation.LAYOUT_VERTICAL;
					break;
				case Position.TOP:
				case Position.BOTTOM:
					_navigation.layout = PinBarNavigation.LAYOUT_HORIZONTAL;
					break;
				case Position.MIDDLE:
					_navigation.layout = PinBarNavigation.LAYOUT_RECTANGLE;
					break;
			}

			//_navigation.alpha = position == Position.MIDDLE ? .3 : 1;
			
			_pinBarIcon.direction = position;
		}

		private function drawSnapArea(position : String) : void {
			var size : uint = getStyle(style.size);

			var color : uint = 0xEEEEEE;

			with (_navigationArea.graphics) {
				clear();

				if (position != Position.MIDDLE) {
					
					beginFill(color, .5);
					lineStyle(0, color);
					
					switch (position) {
						case Position.LEFT:
							_navigationArea.x = - 400;
							_navigationArea.y = 0;
							drawRect(0, 0, 400 + size - 1, _height - 1);
							break;
						case Position.RIGHT:
							_navigationArea.x = _width - size;
							_navigationArea.y = 0;
							drawRect(0, 0, 400 + size - 1, _height - 1);
							break;
						case Position.TOP:
							_navigationArea.x = 0;
							_navigationArea.y = - 400;
							drawRect(0, 0, _width - 1, 400 + size - 1);
							break;
						case Position.BOTTOM:
							_navigationArea.x = 0;
							_navigationArea.y = _height - size;
							drawRect(0, 0, _width - 1, 400 + size - 1);
							break;
					}
					
				}
				
			}
			
		}
		
		/*
		 * Open, close
		 */

		private function open() : void {
			_open = true;
			
			var pinBarPosition : Point = getPinBarPosition(_lastFixPinBarPosition, true);
			_navigationTween.setValue("x", pinBarPosition.x);
			_navigationTween.setValue("y", pinBarPosition.y);
			_navigationTween.ease = Sine.easeIn;

			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
		}
		
		private function close() : void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);

			_open = false;
			_leaveOpenOnMouseOut = false;

			var pinBarPosition : Point = getPinBarPosition(_lastFixPinBarPosition, false);
			_navigationTween.setValue("x", pinBarPosition.x);
			_navigationTween.setValue("y", pinBarPosition.y);
			_navigationTween.ease = Sine.easeIn;
		}
		
		private function stageMouseDownHandler(event : MouseEvent) : void {
			
			// close if mouse down outside
			if (!_navigationArea.hitTestPoint(event.stageX, event.stageY)) {

				// do not close if a pin bar window is hit
				var parent : DisplayObject = event.target as DisplayObject;
				while (parent) {
					if (_registeredWindows.hasKey(parent)) return;
					parent = parent.parent;
				}
				close();

			// pin bar after mouse down
			} else {
				_leaveOpenOnMouseOut = true;
			}
		}

		/*
		 * Events
		 */

		private function mouseLeaveHandler(event : Event) : void {
			var exitPosition : String = Position.TOP;
			var currentDiff : uint = stage.mouseY;
			
			if (currentDiff > stage.stageWidth - stage.mouseX) {
				currentDiff = stage.stageWidth - stage.mouseX;
				exitPosition = Position.RIGHT;
			}
			
			if (currentDiff > stage.stageHeight - stage.mouseY) {
				currentDiff = stage.stageHeight - stage.mouseY;
				exitPosition = Position.BOTTOM;
			}
			
			if (currentDiff > stage.mouseX) {
				currentDiff = stage.mouseX;
				exitPosition = Position.LEFT;
			}
			
			if (exitPosition == _lastFixPinBarPosition) {
				if (!_open) {
					open();
				}
			}
		}

		private function mouseMoveHandler(event : MouseEvent) : void {
			
			if (_movingWindow) {
				if (_navigationArea.hitTestObject(DisplayObject(_movingWindow.window))) {
					if (!_open) {
						open();
					}
				} else {
					if (_open && !_leaveOpenOnMouseOut) close();
				}

				testMinimiseWindow();

			} else {
				if (_navigationArea.hitTestPoint(event.stageX, event.stageY)) {
					if (!_open) {
						open();
					}
				} else {
					if (_open && !_leaveOpenOnMouseOut) close();
				}
			}
			
			event.updateAfterEvent();
		}
		
		private function testMinimiseWindow() : void {
			var pinBarItem : PinBarButton = _registeredWindows.itemFor(_movingWindow.window);

			// add custom pointer if mouse enters the bar
			// set pointers position

			if (_navigationArea.hitTestPoint(stage.mouseX, stage.mouseY)) {

				if (!_windowOverNavigationArea) {
					_movingWindow.window.visible = false;
					_windowOverNavigationArea = true;

					setPointer();

					pinBarItem.selected = false;
					_navigation.enabled = false;
				}
				
				setPointerPosition();
				
			// remove pointer if mouse leaves the bar
			// calculate whether the window should be minimised
			} else {
				if (_windowOverNavigationArea) {

					_movingWindow.window.visible = true;
					_windowOverNavigationArea = false;
					
					removePointer();

					pinBarItem.selected = true;
					_navigation.enabled = true;
				}

				_movingWindow.lastDiffX = stage.mouseX - _movingWindow.lastX;
				_movingWindow.lastDiffY = stage.mouseY - _movingWindow.lastY;
				_movingWindow.lastX = stage.mouseX;
				_movingWindow.lastY = stage.mouseY;

			}

		}

		/*
		 * Pointer
		 */
		
		private function setPointer() : void {
			_pointer.pointer = new (_movingWindow.window.getStyle(Window.style.windowIconSkin))();
			_pointer.visible = true;
		}
			
		private function setPointerPosition() : void {

			_pointer.x = stage.mouseX - _pointer.width / 2;
			_pointer.y = stage.mouseY - _pointer.height / 2;

			var size : uint = getStyle(style.size);
			var pointerPosition : uint = Math.round((size - _pointer.width) / 2);

			switch (_lastFixPinBarPosition) {
				case Position.LEFT:
					_pointer.x = pointerPosition;
					break;
				case Position.RIGHT:
					_pointer.x = Math.round((size - _pointer.width) / 2);

					_pointer.x = _width - size + pointerPosition;
					break;
				case Position.TOP:
					_pointer.y = pointerPosition;
					break;
				case Position.BOTTOM:
					_pointer.y = _height - size + pointerPosition;
					break;
			}
		}
			
		private function removePointer() : void {
			_pointer.pointer = null;
			_pointer.visible = false;
		}

		/*
		 * Window events
		 */

		private function windowMinismisingHandler(event : Event) : void {
			if (!_open) {
				open();
			}
			_leaveOpenOnMouseOut = true;
		}

		private function windowStartsMovingHandler(event : WindowEvent) : void {
			_movingWindow = new MovingWindow(event.currentTarget as Window);
			_movingWindow.window.addEventListener(WindowEvent.STOP_DRAG, windowStopsMovingHandler);
		}
		
		private function windowStopsMovingHandler(event : WindowEvent) : void {
			_movingWindow.window.removeEventListener(WindowEvent.STOP_DRAG, windowStopsMovingHandler);
			
			var pinBarItem : PinBarButton = _registeredWindows.itemFor(_movingWindow.window);
			var itemPosition : Point = pinBarItem.globalPosition;
			var distAbs : Number;

			if (_windowOverNavigationArea) {

				// Add window to the pin bar

				// use the same tween duration as the window minimise tween
				var tween : GTween = new GTween(_pointer, .2);
				tween.setValue("x", itemPosition.x);
				tween.setValue("y", itemPosition.y);
				
				// accelerate minimising
				// <= 100 -> 1, 500 -> 1/2, 900 -> 1/3
				distAbs = Point.distance(new Point(_pointer.x, _pointer.y), itemPosition);
				if (distAbs > 100) tween.timeScale = 400 / ((distAbs - 100) + 400);
				
				tween.onComplete = function(tween:GTween) : void {
					_navigation.enabled = true;
					removePointer();
				};
				tween.ease = Cubic.easeIn;

				pinBarItem.window.minimise(); // mark window to be minimised

				// leave open after mouse out
				_leaveOpenOnMouseOut = true;

				// do not restore to the position where the window has
				// been released. 
				event.restorePosition = null;

			} else {
				
				// Test, if a just released window should be added to the taskbar.
	
				var diffX : int = _movingWindow.lastDiffX;
				var diffY : int = _movingWindow.lastDiffY;
				
				var maxDiff : uint = 5;
				
				var minimise : Boolean = false;
				switch (_lastFixPinBarPosition) {
					case Position.TOP:
						if (diffY < -maxDiff) minimise = true;
						break;
					case Position.RIGHT:
						if (diffX > maxDiff) minimise = true;
						break;
					case Position.BOTTOM:
						if (diffY > maxDiff) minimise = true;
						break;
					case Position.LEFT:
						if (diffX < -maxDiff) minimise = true;
						break;
				}

				if (minimise) {
					pinBarItem.minimiseWindow();

					// do not restore to the position where the window has
					// been released. 
					event.restorePosition = null;
				}

			}

			_windowOverNavigationArea = false;
			_movingWindow = null;

		}
	}
}

import com.sibirjak.asdpcbeta.window.Window;

internal class MovingWindow {
	
	public var window : Window;
	
	public var lastX : int;
	public var lastY : int;
	public var lastDiffX : int;
	public var lastDiffY : int;
	
	public function MovingWindow(theWindow : Window) {
		window = theWindow;
	}
}
