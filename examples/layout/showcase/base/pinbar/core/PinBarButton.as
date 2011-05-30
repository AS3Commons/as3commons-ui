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
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author jes 26.11.2009
	 */
	public class PinBarButton extends Button {
		
		public static const EVENT_CLIENT_MINIMISING : String = "pinBarButton_minimising";

		private var _window : Window;
		private var _pulseTween : GTween;
		private var _startPosition : Point;

		public function PinBarButton() {
		}
		
		public function set window(window : Window) : void {
			
			toolTip = window.title;
			
			_window = window;

			_window.minimisePosition = new WindowPosition(function() : Point {
				return globalPosition;
			});

			_window.addEventListener(WindowEvent.MINIMISE_START, clientMinimiseStartHandler);
			_window.addEventListener(WindowEvent.MINIMISED, clientMinimisedHandler);
			
			_pulseTween = new GTween(this, .15);
			_pulseTween.reflect = true;
			_pulseTween.repeatCount = 2;
			_pulseTween.ease = Sine.easeInOut;
			_pulseTween.paused = true;
			
			_startPosition = window.restorePosition.point;
		}
		
		public function get window() : Window {
			return _window;
		}
		
		public function get globalPosition() : Point {
			return localToGlobal(new Point(0, 0));
		}

		public function setStartPosition() : void {
			_window.restorePosition = new WindowPosition(_startPosition);
		}

		public function minimiseWindow() : void {
			_window.minimise();
		}

		public function restoreWindow() : void {
			_window.restore();
			selected = true;
		}
		
		public function get startPosition() : Point {
			return _startPosition;
		}

		public function pulse() : void {
			
			// do not start pulsing during a pulse :-)
			if (!_pulseTween.paused) return;
			
			var scale : Number = (_width + 12) / _width;

			_pulseTween.setValue("scaleX", scale);
			_pulseTween.setValue("scaleY", scale);
			_pulseTween.setValue("x", x - 6);
			_pulseTween.setValue("y", y - 6);
			_pulseTween.setValue("alpha", .7);
			
		}
		
		/*
		 * View life cycle
		 */

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			_window.removeEventListener(WindowEvent.MINIMISE_START, clientMinimiseStartHandler);
			_window.removeEventListener(WindowEvent.MINIMISED, clientMinimisedHandler);
		}

		/*
		 * Protected
		 */

		override protected function onSelectionChanged() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

			if (selected) {
				restoreWindow();
			} else {
				minimiseWindow();
			}
		}

		override protected function onMouseUpOutside() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		override protected function onMouseDown() : void {
			if (selected) return;
			
			_moveStartPosition = new Point(stage.mouseX, stage.mouseY);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/*
		 * Events
		 */

		private var _moveStartPosition : Point;
		
		private function mouseMoveHandler(event : MouseEvent) : void {
			
			// avoid dragging icon when clicking while slightly moving mouse, which
			// often occurs.
			if (Point.distance(new Point(stage.mouseX, stage.mouseY), _moveStartPosition) < 3) {
				return;
			}

			if (!hitTestPoint(stage.mouseX, stage.mouseY)) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				return;
			}

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

			// restore to the mouse postion rather than to the last fix position
			_window.restore(false, new WindowPosition(stage.mouseX - 20, stage.mouseY - 10));
			_window.visible = false;
			_window.startMoving();
		}

		/*
		 * Client events
		 */
		
		private function clientMinimiseStartHandler(event : WindowEvent) : void {
			dispatchEvent(new Event(EVENT_CLIENT_MINIMISING, true));
		}

		private function clientMinimisedHandler(event : WindowEvent) : void {
			selected = false;
			pulse();
		}
	}
}
