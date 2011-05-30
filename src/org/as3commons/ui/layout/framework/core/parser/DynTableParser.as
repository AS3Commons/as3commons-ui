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

	import org.as3commons.ui.layout.framework.IDynTable;
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.config.CellConfigMerge;

	/**
	 * Dynamic table parser.
	 * 
	 * @author Jens Struwe 19.03.2011
	 */
	public class DynTableParser extends TableParser {

		/**
		 * Max width of the layout.
		 */
		private var _maxContentWidth : uint;

		/**
		 * Horizontal space between items.
		 */
		private var _hGap : uint;

		/**
		 * List of the items with the biggest width.
		 */
		private var _maxItemWidths : MaxItemsList;

		/**
		 * Index of the widest item.
		 */
		private var _maxItemWidthIndex : uint;
		
		/**
		 * Min number of columns created by the layout.
		 */
		private var _minNumColumns : uint;

		/**
		 * Max number of columns created by the layout.
		 */
		private var _maxNumColumns : uint;

		/**
		 * @inheritDoc
		 */
		override public function prepare() : void {
			super.prepare();

			_maxContentWidth = IDynTable(_layout).maxContentWidth;
			_hGap = IDynTable(_layout).hGap;

			_maxItemWidths = new MaxItemsList(_maxContentWidth, _hGap);
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
			
			_cache.push(cell);

			var width : uint = getItemWidthByIndex(_cache.length - 1);
			if (width > _maxItemWidths.first) _maxItemWidthIndex = _cache.length - 1;
			_maxItemWidths.add(width);
		}

		/**
		 * @inheritDoc
		 */
		override public function finish() : ICell {
			_maxItemWidths.finalize();
			_minNumColumns = _maxNumColumns = _maxItemWidths.size;
			
			// all items fit into the max size
			if (_minNumColumns == _cache.length) {

			// the first item is already bigger than max content
			} else if (_maxItemWidths.first > _maxContentWidth) {
			
			// calculate a max number of cells from the biggest item added
			} else {
				estimateMaxNumCells();
			}
			
			calculateCellSizes();

			return super.finish();
		}

		/*
		 * Protected
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function get numColumns() : uint {
			return _maxNumColumns;
		}

		/**
		 * @inheritDoc
		 */
		override protected function get maxContentWidth() : uint {
			return _maxContentWidth;
		}

		/*
		 * Private
		 */
		
		/**
		 * Calculates the cell sizes.
		 */
		private function calculateCellSizes() : void {
			var i : uint, j : uint;
			var maxCellIndex : uint;
			var cellsTotal : uint;
			var size : uint;
			var cellHeightsIndex : uint;
			
			while (true) {
				_cellSizes = new Array();
				maxCellIndex = _maxItemWidthIndex % _maxNumColumns;
				_cellSizes[maxCellIndex] = cellsTotal = _maxItemWidths.first;
				if (maxCellIndex > 0) cellsTotal += _hGap;
				cellHeightsIndex = _maxNumColumns;
			
				outher : for (i = 0; i < _cache.length; i += _maxNumColumns) {
					for (j = 0; j < _maxNumColumns; j++) {
						if (i + j >= _cache.length) break;
						
						// cell width
						if (!_cellSizes[j]) {
							_cellSizes[j] = 0;
							if (j > 0) cellsTotal += _hGap;
						}
						
						size = getItemWidthByIndex(i + j);
						if (size > _cellSizes[j]) {
							cellsTotal += (size - _cellSizes[j]);
							_cellSizes[j] = size;
						}

						if (cellsTotal > _maxContentWidth) break outher;

						// cell height
						if (!_cellSizes[cellHeightsIndex]) _cellSizes[cellHeightsIndex] = 0;
						_cellSizes[cellHeightsIndex] = Math.max(_cellSizes[cellHeightsIndex], getItemHeightByIndex(i + j));
					}

					cellHeightsIndex++;
				}

				if (cellsTotal <= _maxContentWidth) break;
				if (_maxNumColumns == _minNumColumns) break;
				_maxNumColumns--;
			}
		}

		/**
		 * Finds a possible max number of cells.
		 */
		private function estimateMaxNumCells() : void {
			var rangeSize : uint = _maxItemWidths.first;
			var leftIndex : uint = _maxItemWidthIndex;
			var rightIndex : uint = _maxItemWidthIndex;
			
			var maxRangeSize : uint;
			
			while (true) {
				// no max range found yet - fill range
				if (!_maxNumColumns) {
					if (leftIndex > 0) shiftLeftToLeft();
					else shiftRightToRight();

				// move range by one to the right
				// break if shifting is not possible any longer
				} else {
					var shifted : Boolean = shiftLeftToRight();
					shifted = shifted || shiftRightToRight();
					if (!shifted) break;
				}
			}
			
			function shiftLeftToLeft() : void {
				var size : uint = getItemWidthByIndex(leftIndex - 1) + _hGap;
				if (!checkNextRange(size)) return;
				rangeSize += size;
				leftIndex--;
			}
		
			function shiftLeftToRight() : Boolean {
				if (leftIndex == _maxItemWidthIndex) return false;
				rangeSize -= (getItemWidthByIndex(leftIndex) + _hGap);
				leftIndex++;
				return true;
			}
		
			function shiftRightToRight() : Boolean {
				if (rightIndex == _cache.length - 1) return false;
				var size : uint = getItemWidthByIndex(rightIndex + 1) + _hGap;
				if (!checkNextRange(size)) return false;
				rangeSize += size;
				rightIndex++;
				return true;
			}
			
			function checkNextRange(size : uint) : Boolean {
				// if the next range exceeds the content size, we narrow the max range
				if (rangeSize + size > _maxContentWidth) {
					_maxNumColumns = rightIndex - leftIndex + 1;
					maxRangeSize = rangeSize; // size of the last fitting range
					return false;

				// the next range is not shorter but might have a higher total
				} else if (_maxNumColumns) {
					if (rangeSize + size > maxRangeSize) {
						maxRangeSize = rangeSize + size; // next range fits
					}
				}
				return true;
			}
		}
			
		/**
		 * Returns the width of a cell.
		 */
		private function getItemWidthByIndex(index : uint) : uint {
			return ICell(_cache[index]).space.width;
		}

		/**
		 * Returns the height of a cell.
		 */
		private function getItemHeightByIndex(index : uint) : uint {
			return ICell(_cache[index]).space.height;
		}

	}
}


import org.as3commons.collections.SortedList;
import org.as3commons.collections.utils.NumericComparator;

/**
 * Internal class to manage the list of the widest items of the layout.
 */
internal class MaxItemsList extends SortedList {
	private var _maxTotal : uint;
	private var _total : uint;
	private var _gap : uint;
	public function MaxItemsList(maxTotal : uint, gap : uint) {
		super(new NumericComparator(NumericComparator.ORDER_DESC));	
		_maxTotal = maxTotal;
		_gap = gap;
	}
	override public function add(itemSize : *) : uint {
		super.add(itemSize);
		_total += itemSize;
		if (size > 1) {
			while ((_total + gaps) - (last + _gap) > _maxTotal) _total -= removeLast();
		}
		return 0;
	}
	public function finalize() : void {
		if (size == 1) return;
		if (_total + gaps > _maxTotal) _total -= removeLast();
	}
	private function get gaps() : uint {
		return (size - 1) * _gap;
	}
}
