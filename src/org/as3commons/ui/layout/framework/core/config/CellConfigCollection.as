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
package org.as3commons.ui.layout.framework.core.config {

	import org.as3commons.ui.layout.CellConfig;

	/**
	 * Cell config storage table.
	 * 
	 * @author Jens Struwe 21.03.2011
	 */
	public class CellConfigCollection {
		
		/**
		 * The width of the table.
		 */
		private var _width : uint;

		/**
		 * The height of the table.
		 */
		private var _height : uint;

		/**
		 * The cell configurations.
		 */
		private var _cellConfigs : Object;

		/**
		 * <code>CellConfigCollection</code> constructor.
		 */
		public function CellConfigCollection() {
			_cellConfigs = new Object();
		}
		
		/*
		 * Public
		 */

		/**
		 * Sets a cell config affecting all cells specified by <code>hIndex</code> and <code>vIndex</code>.
		 * 
		 * @param cellConfig The cell config.
		 * @param hIndex The horizontal index of the affected cell or cells.
		 * @param hIndex The vertical index of the affected cell or cells.
		 */
		public function setConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			var x : uint = hIndex + 1;
			var y : uint = vIndex + 1;

			if (x >= _width || y >= _height) resize(x + 1, y + 1);
			_cellConfigs[y * _width + x] = cellConfig;
		}

		/**
		 * Returns the cell config for the cell specified by <code>hIndex</code> and <code>vIndex</code>.
		 * 
		 * @param hIndex The horizontal index of the cell.
		 * @param hIndex The vertical index of the cell.
		 * @return The cell config.
		 */
		public function getConfig(hIndex : int = -1, vIndex : int = -1) : CellConfig {
			var x : uint = hIndex + 1;
			var y : uint = vIndex + 1;
			if (x >= _width) x = 0;
			if (y >= _height) y = 0;

			var cellConfig : CellConfig;
			cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[0]);
			if (x) cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[x]);
			if (y) cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[y * _width]);
			if (x && y) cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[y * _width + x]);

			return cellConfig;
		}
		
		/*
		 * Private
		 */

		/**
		 * Resizes the internal storage table.
		 */
		private function resize(width : uint, height : uint) : void {
			width = Math.max(width, _width);
			height = Math.max(height, _height);
			var cellConfigs : Object = new Object();
			var x : uint;
			var y : uint;
			var oldIndex : uint;

			for (var property : String in _cellConfigs) {
				oldIndex = parseInt(property);
				x = oldIndex % _width;
				y = Math.floor(oldIndex / _width);

				cellConfigs[y * width + x] = _cellConfigs[oldIndex];
			}
			
			_cellConfigs = cellConfigs; 
			_width = width;
			_height = height;
		}
		
	}
}
