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

	import org.as3commons.ui.layout.framework.IDynTable;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.DynTableParser;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.SingleRowTableParser;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * Dynamic table layout.
	 * 
	 * @author Jens Struwe 21.03.2011
	 */
	public class DynTable extends AbstractMultilineLayout implements IDynTable {

		/**
		 * Max layout width.
		 */
		private var _maxContentWidth : uint;

		/*
		 * ILayout
		 */

		/**
		 * @inheritDoc
		 */
		override public function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			cellConfig.width = cellConfig.height = 0;
			cellConfig.marginX = cellConfig.marginY = 0;
			cellConfig.offsetX = cellConfig.offsetY = 0;
			super.setCellConfig(cellConfig);
		}

		/*
		 * IDynamicTable
		 */
		
		// Config - Max Size
		
		/**
		 * @inheritDoc
		 */
		public function set maxContentWidth(maxContentWidth : uint) : void {
			_maxContentWidth = maxContentWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxContentWidth() : uint {
			return _maxContentWidth;
		}

		// Info

		/**
		 * @inheritDoc
		 */
		public function get numTableRows() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get numTableColumns() : uint {
			if (!_cell) return 0;
			var row : IRow = ILayoutCell(_cell).row.firstRowItem as IRow;
			if (!row) return 0;
			return row.numItems;
		}

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function createParser() : ILayoutParser {
			if (_maxContentWidth) return new DynTableParser();
			else return new SingleRowTableParser();
		}

	}
}
