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

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.framework.core.AbstractLayoutItem;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;
	import org.as3commons.ui.layout.framework.core.row.AbstractRowItem;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Basic cell implementation.
	 * 
	 * @author Jens Struwe 16.03.2011
	 */
	public class AbstractCell extends AbstractRowItem implements ICell {
		
		/**
		 * The layout item hosted by this cell.
		 */
		protected var _layoutItem : AbstractLayoutItem;
		
		/**
		 * The cell config.
		 */
		protected var _config : CellConfig;

		/**
		 * The render config.
		 */
		protected var _renderConfig : RenderConfig;
		
		/**
		 * The measured rect.
		 */
		protected var _measured : Rectangle;

		/**
		 * The content rect.
		 */
		protected var _contentRect : Rectangle;
		
		/**
		 * <code>AbstractCell</code> constructor.
		 */
		public function AbstractCell() {
			_config = new CellConfig();
		}
		
		/*
		 * ICell
		 */

		// Owner
		
		/**
		 * @inheritDoc
		 */
		public function set layoutItem(layoutItem : AbstractLayoutItem) : void {
			_layoutItem = layoutItem;
		}

		// Config
		
		/**
		 * @inheritDoc
		 */
		public function get config() : CellConfig {
			return _config;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set renderConfig(renderConfig : RenderConfig) : void {
			_renderConfig = renderConfig;
		}

		/**
		 * @inheritDoc
		 */
		public function get renderConfig() : RenderConfig {
			return _renderConfig;
		}

		// Size

		/**
		 * @inheritDoc
		 */
		public function isEmpty() : Boolean {
			return !_space || !_space.width || !_space.height;
		}

		// Data

		/**
		 * @inheritDoc
		 */
		public function get contentRect() : Rectangle {
			return _contentRect;
		}

		/*
		 * IBox
		 */

		/**
		 * @inheritDoc
		 */
		override public function measure() : void {
			_space = new Rectangle();

			measureCellContent();

			// measured size
			_measured = _space.clone();

			// space
			if (_config.width) _space.width = _config.width;
			if (_config.height) _space.height = _config.height;
			_space.offset(_config.marginX, _config.marginY);
		}

		/**
		 * @inheritDoc
		 */
		override public function render() : void {
			var offsetX : int = _config.marginX + _config.offsetX;
			var offsetY : int = _config.marginY + _config.offsetY;

			// content
			_contentRect = new Rectangle();
			_contentRect.offsetPoint(_position);
			_contentRect.offsetPoint(_measured.topLeft);
			_contentRect.offset(offsetX, offsetY);
			_contentRect.size = _space.size;
			
			// content position
			var position : Point = _position.clone();
			position.offset(offsetX, offsetY);
			alignCellContent(position);
			renderCellContent(position);
			
			AbstractLayoutItem(_layoutItem).as3commons_ui::notifyRenderFinished();
		}
		
		/*
		 * Protected
		 */

		/**
		 * Measures the cell content.
		 */
		protected function measureCellContent() : void {
			// template method
		}

		/**
		 * Renders the cell content.
		 */
		protected function renderCellContent(position : Point) : void {
			// template method
		}

		/*
		 * Private
		 */

		/**
		 * Aligns the cell content.
		 */
		private function alignCellContent(position : Point) : void {
			var diff : uint;
			
			if (_config.hAlign != Align.LEFT) {
				if (_contentRect.width > _measured.width) {
					diff = _contentRect.width - _measured.width;
					switch (_config.hAlign) {
						case Align.CENTER:
							position.x += Math.round(diff / 2);
							break;
						case Align.RIGHT:
							position.x += diff;
							break;
					}
				}
			}
			
			if (_config.vAlign != Align.TOP) {
				if (_contentRect.height > _measured.height) {
					diff = _contentRect.height - _measured.height;
					switch (_config.vAlign) {
						case Align.MIDDLE:
							position.y += Math.round(diff / 2);
							break;
						case Align.BOTTOM:
							position.y += diff;
							break;
					}
				}
			}
		}

	}
}
