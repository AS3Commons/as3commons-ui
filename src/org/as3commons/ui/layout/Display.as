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
package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.IDisplay;
	import org.as3commons.ui.layout.framework.core.AbstractLayoutItem;
	import org.as3commons.ui.layout.framework.core.cell.DisplayCell;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 15.03.2011
	 */
	public class Display extends AbstractLayoutItem implements IDisplay {

		private var _displayObject : DisplayObject;
		private var _width : uint;
		private var _height : uint;
		
		/*
		 * IDisplay
		 */
		
		// Config - DisplayObject
		
		public function set displayObject(displayObject : DisplayObject) : void {
			_displayObject = displayObject;
		}

		public function get displayObject() : DisplayObject {
			return _displayObject;
		}

		// Config - Size
		
		public function set width(width : uint) : void {
			_width = width;
		}

		public function get width() : uint {
			return _width;
		}

		public function set height(height : uint) : void {
			_height = height;
		}

		public function get height() : uint {
			return _height;
		}

		/*
		 * Info
		 */

		override public function toString() : String {
			return "[Display]" + super.toString() + ", object:" + _displayObject;
		}

		/*
		 * Protected
		 */

		override protected function excludeLayoutItem(renderConfig : RenderConfig) : void {
			if (_displayObject.parent != renderConfig.container) renderConfig.container.addChild(_displayObject);

			if (renderConfig.hide) {
				if (renderConfig.hideCallback != null) renderConfig.hideCallback(_displayObject);
				else _displayObject.visible = false;
			}
		}

		override protected function parseLayoutItem(renderConfig : RenderConfig) : void {
			_cell = new DisplayCell();
			DisplayCell(_cell).displayObject = _displayObject;
			_cell.renderConfig = renderConfig;

			_cell.config.marginX = _marginX;
			_cell.config.marginY = _marginY;
			_cell.config.offsetX = _offsetX;
			_cell.config.offsetY = _offsetY;
			_cell.config.hAlign = _hAlign;
			_cell.config.vAlign = _vAlign;
		}

	}
}
