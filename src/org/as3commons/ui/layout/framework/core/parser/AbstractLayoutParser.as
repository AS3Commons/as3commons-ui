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
package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.framework.core.AbstractLayout;
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.cell.LayoutCell;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * Abstract layout parser implementation.
	 * 
	 * @author Jens Struwe 16.03.2011
	 */
	public class AbstractLayoutParser implements ILayoutParser {
		
		/**
		 * The layout to be parsed.
		 */
		protected var _layout : AbstractLayout;

		/**
		 * The cell corresponding to the layout.
		 */
		protected var _layoutCell : ILayoutCell;

		/*
		 * ILayoutParser
		 */

		/**
		 * @inheritDoc
		 */
		public function set layout(layout : AbstractLayout) : void {
			_layout = layout;
		}

		/**
		 * @inheritDoc
		 */
		public function prepare() : void {
			_layoutCell = new LayoutCell();
			_layoutCell.layoutItem = _layout;
			_layoutCell.config.marginX = _layout.marginX;
			_layoutCell.config.marginY = _layout.marginY;
			_layoutCell.config.offsetX = _layout.offsetX;
			_layoutCell.config.offsetY = _layout.offsetY;
			
			var row : IRow = createRow();
			row.isFirst = row.isLast = true;
			_layoutCell.row = row;
		}

		/**
		 * @inheritDoc
		 */
		public function parseCell(cell : ICell) : void {
			// template method
		}

		/**
		 * @inheritDoc
		 */
		public function finish() : ICell {
			_layoutCell.row.measure();
			_layoutCell.measure();
			return _layoutCell;
		}
		
		/*
		 * Protected
		 */

		/**
		 * Creates the first row of the layout.
		 */
		protected function createRow() : IRow {
			// template method
			return null;
		}

	}
}
