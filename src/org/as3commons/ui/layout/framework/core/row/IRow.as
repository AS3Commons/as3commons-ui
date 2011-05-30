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

	import flash.geom.Rectangle;

	/**
	 * Row definition.
	 * 
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IRow extends IRowItem {

		/*
		 * Config
		 */

		/**
		 * The row config.
		 */
		function get config() : RowConfig;

		/*
		 * Add
		 */

		/**
		 * Returns <code>true</code>, if the row accepts the given <code>rowItem</code>.
		 * 
		 * @param rowItem The row item to test.
		 * @param cellConfig An optional cell config for the row item.
		 * @return <code>true</code>, if the item fits into the row.
		 */
		function accepts(rowItem : IRowItem, cellConfig : CellConfig = null) : Boolean;
		
		/**
		 * Adds the given <code>rowItem</code>.
		 * 
		 * @param rowItem The row item to add.
		 */
		function add(rowItem : IRowItem) : void;
		
		/**
		 * Fills the row with an empty cell of the specified size.
		 * 
		 * @param cellSize The size of the empty cell.
		 */
		function fillWithEmptyCell(cellSize : Rectangle) : void;
		
		/**
		 * The parent row.
		 */
		function set parentRow(parentRow : IRow) : void;
		
		/**
		 * The number of items in the row.
		 */
		function get numItems() : uint;
		
		/**
		 * The first row item.
		 */
		function get firstRowItem() : IRowItem;

	}
}
