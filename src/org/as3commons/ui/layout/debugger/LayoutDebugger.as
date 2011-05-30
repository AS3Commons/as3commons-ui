/**
 * Copyright 2011 The original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.ui.layout.debugger {

	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.framework.ILayoutItem;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Layout debugger.
	 * 
	 * @author Jens Struwe 23.02.2011
	 */
	public class LayoutDebugger extends Sprite {
		
		/**
		 * Flag to control the mouse over behaviour.
		 */
		public var showOnOver : Boolean = true;
		
		/**
		 * Flag indicated that the view is being locked.
		 */
		private var _locked : Boolean;

		/**
		 * Temporarily stores a dump.
		 */
		private var _dump : String;
		
		/**
		 * Base color.
		 */
		private var _contentColor : uint = 0xBBBBBB;
		
		/**
		 * <code>LayoutDebugger</code> constructor.
		 */
		public function LayoutDebugger() {
			if (showOnOver) alpha = 0;
			
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
			addEventListener(MouseEvent.CLICK, click);
		}

		/**
		 * Draws the debugging information.
		 * 
		 * @param layout The layout to be debugged.
		 */
		public function debug(layout : ILayout) : void {
			graphics.clear();

			debugCallback(layout, 0);
			var iterator : IRecursiveIterator = layout.recursiveIterator();
			while (iterator.hasNext()) {
				debugCallback(iterator.next(), iterator.depth + 1);
			}

		}
		
		/**
		 * Returns a debug string.
		 * 
		 * @param layout The layout to be debugged.
		 * @return A string containing the layout hierarchy.
		 */
		public function dumpAsString(layout : ILayout) : String {
			_dump = "";
			
			dumpAsStringCallback(layout, 0);

			var iterator : IRecursiveIterator = layout.recursiveIterator();
			while (iterator.hasNext()) {
				dumpAsStringCallback(iterator.next(), iterator.depth + 1);
			}
			
			return _dump;
		}

		/*
		 * Private
		 */
		
		/**
		 * Debug drawing callback.
		 */
		private function debugCallback(layoutItem : ILayoutItem, depth : uint) : void {
			var padding : uint = depth;

			if (layoutItem is ILayout) {
				drawLayoutItemRect(layoutItem.contentRect, padding, _contentColor, 1, 0x333333, 1, false);

			} else { // IDisplay
				drawLayoutItemRect(layoutItem.contentRect, padding, 0, 1, 0xFFFFFF, 1, false);
				drawLayoutItemRect(layoutItem.contentRect, padding + 1, 0, 1, _contentColor, 1, false);
				drawLayoutItemRect(layoutItem.visibleRect, padding + 2, 0xFFFFFF, 1, 0, 1, false);
			}
		}
			
		/**
		 * Draws a rect.
		 */
		private function drawLayoutItemRect(
			rect : Rectangle,
			padding : int,
			color : uint,
			colorAlpha : Number,
			border : uint,
			borderAlpha : Number,
			raster : Boolean
		) : void {
			if (!rect.width || !rect.height) return;
			
			rect = rect.clone();
			rect.inflate(- padding, - padding);

			if (rect.width < 0 || rect.height < 0) return;

			if (raster && color) {
				var rasterSize : uint = 1;
				var r1 : Rectangle = new Rectangle(0, 0, rasterSize, rasterSize);
				var r2 : Rectangle = new Rectangle(rasterSize, rasterSize, rasterSize, rasterSize);
				var r3 : Rectangle = new Rectangle(0, rasterSize, rasterSize, rasterSize);
				var r4 : Rectangle = new Rectangle(rasterSize, 0, rasterSize, rasterSize);
	
				var tile : BitmapData = new BitmapData(2 * rasterSize, 2 * rasterSize, true);
				
				var fillAlpha : uint = 0xFF * colorAlpha;
				tile.fillRect(r1, (fillAlpha << 24) + color);
				tile.fillRect(r2, (fillAlpha << 24) + color);
				tile.fillRect(r3, 0x00FFFFFF);
				tile.fillRect(r4, 0x00FFFFFF);
	
				with (graphics) {
					beginBitmapFill(tile, null, true);
					drawRect(rect.x, rect.y, rect.width, rect.height);
					endFill();
				}

			} else if (!raster) {
				var alpha : Number = color ? colorAlpha : 0;
				with (graphics) {
					beginFill(color, alpha);
					drawRect(rect.x, rect.y, rect.width, rect.height);
					endFill();
				}
			}
			
			if (border) {
				with (graphics) {
					lineStyle(1, border, borderAlpha);
					drawRect(rect.x, rect.y, rect.width - 1, rect.height - 1);
					lineStyle();
				}
			}
		}

		/**
		 * Debug string builder callback.
		 */
		private function dumpAsStringCallback(layoutItem : ILayoutItem, depth : uint) : void {
			_dump += prefix(depth) + layoutItem + "\n";

			function prefix(length : uint) : String {
				var prefix : String = "";
				for (var i : uint = 0; i < length; i++) {
					prefix += "....";
				}
				return prefix;
			}
		}

		/**
		 * RollOut handler.
		 */
		private function rollOut(event : MouseEvent) : void {
			if (_locked) return;
			alpha = showOnOver ? 0 : 1;
		}

		/**
		 * RollOver handler.
		 */
		private function rollOver(event : MouseEvent) : void {
			if (_locked) return;
			alpha = showOnOver ? 1 : 0;
		}

		/**
		 * Click handler.
		 */
		private function click(event : MouseEvent) : void {
			_locked = !_locked;
		}

	}
}
