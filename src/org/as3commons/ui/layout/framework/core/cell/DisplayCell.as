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
package org.as3commons.ui.layout.framework.core.cell {

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Display object cell.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class DisplayCell extends AbstractCell implements IDisplayCell {
		
		/**
		 * The visible rect.
		 */
		private var _visibleRect : Rectangle;

		/**
		 * The display object.
		 */
		private var _displayObject : DisplayObject;
		
		/*
		 * IDisplayCell
		 */
		
		/**
		 * @inheritDoc
		 */
		public function set displayObject(displayObject : DisplayObject) : void {
			_displayObject = displayObject;
		}

		/**
		 * @inheritDoc
		 */
		public function get displayObject() : DisplayObject {
			return _displayObject;
		}

		/*
		 * Protected
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function measureCellContent() : void {
			_space.width = displayObject.width;
			_space.height = displayObject.height;
		}

		/**
		 * @inheritDoc
		 */
		override protected function renderCellContent(position : Point) : void {
			if (renderConfig.show) {
				if (renderConfig.showCallback != null) renderConfig.showCallback(_displayObject);
				else _displayObject.visible = true;
			}

			if (_renderConfig.renderCallback != null) {
				_renderConfig.renderCallback(displayObject, position.x, position.y);

			} else {
				displayObject.x = position.x;
				displayObject.y = position.y;
			}
			
			_visibleRect = new Rectangle(position.x, position.y, displayObject.width, displayObject.height);
		}
		
		/*
		 * IBox
		 */
		
		/**
		 * @inheritDoc
		 */
		override public function get visibleRect() : Rectangle {
			return _visibleRect;
		}

	}
}
