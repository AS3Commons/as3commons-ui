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

	import org.as3commons.ui.layout.Display;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Display object cell.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class DisplayCell extends AbstractCell {
		
		/**
		 * The visible rect.
		 */
		private var _visibleRect : Rectangle;

		/*
		 * Protected
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function measureCellContent() : void {
			_space.width = _displayObject.width;
			_space.height = _displayObject.height;
		}

		/**
		 * @inheritDoc
		 */
		override protected function renderCellContent(position : Point) : void {
			if (_renderConfig.show) {
				if (_renderConfig.showCallback != null) _renderConfig.showCallback(_displayObject);
				else _displayObject.visible = true;
			}

			if (_renderConfig.renderCallback != null) {
				_renderConfig.renderCallback(_displayObject, position.x, position.y);

			} else {
				_displayObject.x = position.x;
				_displayObject.y = position.y;
			}
			
			_visibleRect = new Rectangle(position.x, position.y, _displayObject.width, _displayObject.height);
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
		
		/*
		 * Private
		 */
		 
		private function get _displayObject() : DisplayObject {
			return Display(_layoutItem).displayObject;
		}

	}
}
