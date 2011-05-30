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

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.framework.IMultilineLayout;
	import org.as3commons.ui.layout.framework.ITable;
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.config.CellConfigMerge;
	import org.as3commons.ui.layout.framework.core.row.HRow;
	import org.as3commons.ui.layout.framework.core.row.IRow;
	import org.as3commons.ui.layout.framework.core.row.VRow;

	import flash.geom.Rectangle;

	/**
	 * Table parser.
	 * 
	 * @author Jens Struwe 19.03.2011
	 */
	public class TableParser extends AbstractMultilineLayoutParser {

		/**
		 * Cache of cells added to the parser.
		 */
		protected var _cache : Array;

		/**
		 * List if cell sizes.
		 */
		protected var _cellSizes : Array;

		/*
		 * ILayoutParser
		 */

		/**
		 * @inheritDoc
		 */
		override public function prepare() : void {
			_cache = new Array();
			_cellSizes = new Array();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parseCell(cell : ICell) : void {
			var hIndex : uint = _cache.length % numColumns;
			var vIndex : uint = Math.floor(_cache.length / numColumns);

			CellConfigMerge.merge(cell.config, _layout.getCellConfig(hIndex, vIndex));
			cell.measure();
			// skip empty cells
			if (cell.isEmpty()) return;
			
			// cell width
			// array index 0, ..., numCells - 1
			if (!_cellSizes[hIndex]) _cellSizes[hIndex] = 0;
			_cellSizes[hIndex] = Math.max(_cellSizes[hIndex], cell.space.width);
			
			// cell height
			// array index numCells, ..., numCells + numSubRows - 1
			vIndex += numColumns;
			if (!_cellSizes[vIndex]) _cellSizes[vIndex] = 0;
			_cellSizes[vIndex] = Math.max(_cellSizes[vIndex], cell.space.height);

			_cache.push(cell);
		}

		/**
		 * @inheritDoc
		 */
		override public function finish() : ICell {
			super.prepare();

			var cell : ICell;
			var vIndex : uint;
			var hIndex : uint;

			for (var i : uint = 0; i < _cache.length; i++) {
				cell = _cache[i];
				
				hIndex = i % numColumns;
				vIndex = Math.floor(i / numColumns);
			
				cell.config.width = _cellSizes[hIndex];
				cell.config.height = _cellSizes[vIndex + numColumns];
				
				super.parseCell(cell);
			}
			
			// do not fill the first row/column
			if (vIndex) {
				var config : CellConfig;
				var marginX : int;
				var marginY : int;
				for (i = hIndex + 1; i < numColumns; i++) {
					config = _layout.getCellConfig(i, vIndex);
					if (config) {
						marginX = config.marginX;
						marginY = config.marginY;
					}
					
					_subRow.fillWithEmptyCell(new Rectangle(
						0, 0, _cellSizes[i] + marginX, _cellSizes[vIndex + numColumns] + marginY
					));
				}
			}

			return super.finish();
		}
		 
		/*
		 * Protected
		 */
		 
		/**
		 * @inheritDoc
		 */
		override protected function getCellConfig(hIndex : uint, vIndex : uint) : CellConfig {
			/*
			 * A cellConfig is already being set in this class, so there is no need to
			 * check again for a config. 
			 */
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override protected function createRow() : IRow {
			var row : IRow = new VRow();

			row.config.minHeight = _layout.minHeight;
			row.config.gap = IMultilineLayout(_layout).vGap;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

		/**
		 * @inheritDoc
		 */
		override protected function createSubRow() : IRow {
			var row : IRow = new HRow();

			row.config.minWidth = _layout.minWidth;
			row.config.maxContentSize = maxContentWidth;
			row.config.maxItems = numColumns;
			row.config.gap = IMultilineLayout(_layout).hGap;
			row.config.hAlign = _layout.hAlign;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

		/**
		 * The number of table columns.
		 */
		protected function get numColumns() : uint {
			return ITable(_layout).numColumns;
		}

		/**
		 * The max width of the layout.
		 */
		protected function get maxContentWidth() : uint {
			return 0;
		}

	}
}
