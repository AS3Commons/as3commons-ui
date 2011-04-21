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
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.config.CellConfigMerge;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractMultilineLayoutParser extends AbstractLayoutParser {
		
		protected var _subRow : IRow;

		/*
		 * ILayoutParser
		 */
		
		override public function prepare() : void {
			super.prepare();
			
			_subRow = createSubRow();
		}
		
		override public function parseCell(cell : ICell) : void {
			// measure cell first
			cell.measure();
			// skip empty cells
			if (cell.isEmpty()) return;
			
			// create a new sub row if necessary
			if (!_subRow.accepts(cell, getCellConfig(_subRow.numItems, _layoutCell.row.numItems))) {
				// finish last row
				finishSubRow();
				// next row
				_subRow = createSubRow();
			}

			// assign cell config
			var cellConfig : CellConfig = getCellConfig(_subRow.numItems, _layoutCell.row.numItems);
			if (cellConfig) {
				CellConfigMerge.merge(cell.config, cellConfig);
				cell.measure();
			}

			// add item
			_subRow.add(cell);
		}
		
		override public function finish() : ICell {
			finishSubRow();
			
			return super.finish();
		}
		
		/*
		 * Protected
		 */
		
		protected function getCellConfig(hIndex : uint, vIndex : uint) : CellConfig {
			// Subclasses may return null with getCellConfig if they already fully control the
			// position of the cell within the layout.
			return _layout.getCellConfig(hIndex, vIndex);
		}

		protected function createSubRow() : IRow {
			// template method
			return null;
		}

		/*
		 * Private
		 */

		private function finishSubRow() : void {
			_subRow.measure();
			_subRow.parentRow = _layoutCell.row;
			_layoutCell.row.add(_subRow);
		}
	}

}
