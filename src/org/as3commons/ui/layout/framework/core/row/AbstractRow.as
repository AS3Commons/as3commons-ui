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
package org.as3commons.ui.layout.framework.core.row {

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.constants.Align;

	import flash.geom.Rectangle;

	/**
	 * Abstract row implementation.
	 * 
	 * @author Jens Struwe 16.03.2011
	 */
	public class AbstractRow extends AbstractRowDirection implements IRow {

		/**
		 * The row config.
		 */
		private var _config : RowConfig;

		/**
		 * The parent row.
		 */
		private var _parentRow : IRow;

		/**
		 * The first item in row.
		 */
		private var _firstRowItem : IRowItem;

		/**
		 * The last item in row.
		 */
		private var _lastRowItem : IRowItem;
		
		/**
		 * The current parser position.
		 */
		private var _currentPosition : int;

		/**
		 * The measured size of the row.
		 */
		private var _measuredSize : uint;

		/**
		 * The number of row items.
		 */
		private var _numItems : uint;

		/**
		 * The visible rect.
		 */
		private var _visibleRect : Rectangle;

		/**
		 * <code>AbstractRow</code> constructor.
		 */
		public function AbstractRow() {
			_config = new RowConfig;

			_space = new Rectangle();
			_visibleRect = new Rectangle();
		}

		/*
		 * IRow
		 */
		
		// Config

		/**
		 * @inheritDoc
		 */
		public function get config() : RowConfig {
			return _config;
		}

		// Add

		/**
		 * @inheritDoc
		 */
		public function accepts(rowItem : IRowItem, cellConfig : CellConfig = null) : Boolean {
			// first item is always accepted
			if (_numItems) {
				if (_config.maxItems && _numItems == _config.maxItems) return false;
				if (_config.maxContentSize) {
					// consider the cell config, if any, instead of the measured size
					var width : uint;
					if (cellConfig && cellConfig[_width]) width = cellConfig[_width];
					else width = rowItem.space[_width];
					
					if (_currentPosition + _config.gap + rowItem.space[_x] + width > _config.maxContentSize) return false;
				}
			}

			return true;
		}

		/**
		 * @inheritDoc
		 */
		public function add(rowItem : IRowItem) : void {
			// add
			if (!_firstRowItem) {
				_firstRowItem = _lastRowItem = rowItem;
				_firstRowItem.isFirst = _firstRowItem.isLast = true;

			} else {
				_lastRowItem.isLast = false;
				_lastRowItem.nextRowItem = rowItem;
				_lastRowItem = rowItem;
				_lastRowItem.isLast = true;
			}

			_numItems++;
			
			// item position and space
			if (!rowItem.isFirst) _currentPosition += _config.gap;
			rowItem.position[_x] = _currentPosition;
			rowItem.space[_x] += _currentPosition;

			// position and space
			_currentPosition = rowItem.space[_x] + rowItem.space[_width];
			_space = _space.union(rowItem.space);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fillWithEmptyCell(cellSize : Rectangle) : void {
			_numItems++;
			
			_currentPosition += _config.gap;
			cellSize[_x] = _currentPosition;
			_currentPosition += cellSize[_width];
			_space = _space.union(cellSize);
		}

		/**
		 * @inheritDoc
		 */
		public function set parentRow(parentRow : IRow) : void {
			_parentRow = parentRow;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numItems() : uint {
			return _numItems;
		}

		/**
		 * @inheritDoc
		 */
		public function get firstRowItem() : IRowItem {
			return _firstRowItem;
		}

		/*
		 * IBox
		 */

		/**
		 * @inheritDoc
		 */
		override public function measure() : void {
			_measuredSize = _space[_width];

			if (_config.minWidth) _space.width = Math.max(_space.width, _config.minWidth);
			if (_config.minHeight) _space.height = Math.max(_space.height, _config.minHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function render() : void {
			var rowItem : IRowItem = _firstRowItem;
			var index : uint;
			while (rowItem) {
				rowItem.position.offset(_position.x, _position.y);
				alignRowItem(rowItem, index);
				
				rowItem.render();

				_visibleRect = rowItem.visibleRect.union(_visibleRect);

				rowItem = rowItem.nextRowItem;
				index++;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get visibleRect() : Rectangle {
			// template method
			return _visibleRect;
		}

		/*
		 * Private
		 */

		/**
		 * Aligns the given row item.
		 * 
		 * @param rowItem The row item to align.
		 * @param index The index of the row item.
		 */
		private function alignRowItem(rowItem : IRowItem, index : uint) : void {
			// align in row direction
			if (_config[_align] != _alignLeft) {
				var width : uint = _parentRow ? _parentRow.space[_width] : _space[_width];
				var diff : uint = width - _measuredSize;
				if (diff) {
					if (_config[_align] == Align.JUSTIFY) {
						if (_numItems > 1) {
							var gap : uint = Math.round(diff / (_numItems - 1));
							rowItem.position[_x] += gap * index;
							if (_numItems > 2) rowItem.position[_x] += getAdditionalGap();
						}
					} else {
						switch (_config[_align]) {
							case _alignCenter:
								rowItem.position[_x] += Math.round(diff / 2);
								break;
							case _alignRight:
								rowItem.position[_x] += diff;
								break;
						}
					}
				}
			}
			
			// align in opposite direction
			if (_config[_oppositeAlign] != _oppositeAlignTop) {
				var align : String;
				if (_parentRow && _config[_oppositeAlign] == Align.JUSTIFY && !_isFirst) {
					align = _isLast ? _oppositeAlignBottom : _oppositeAlignMiddle;
				} else {
					align = _config[_oppositeAlign];
				}
				
				var oppositeDiff : uint = _space[_height] - rowItem.space[_height];
				if (oppositeDiff) {
					switch (align) {
						case _oppositeAlignMiddle:
							rowItem.position[_y] += Math.round(oppositeDiff / 2);
							break;
						case _oppositeAlignBottom:
							rowItem.position[_y] += oppositeDiff;
							break;
					}
				}
			}

			// calculate an additional gap
			function getAdditionalGap() : int {
				var gapDiff : int = diff - (_numItems - 1) * gap;
				var absGapDiff : uint = Math.abs(gapDiff);
				var firstIndexToApply : uint = _numItems - absGapDiff;
				if (index >= firstIndexToApply) {
					return (index - firstIndexToApply + 1) * gapDiff / absGapDiff;
				}
				return 0;
			}
		}

	}
}
