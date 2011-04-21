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

	import flash.geom.Rectangle;
	import org.as3commons.ui.layout.CellConfig;


	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IRow extends IRowItem {

		/*
		 * Config
		 */

		function get config() : RowConfig;

		/*
		 * Add
		 */

		function accepts(rowItem : IRowItem, cellConfig : CellConfig = null) : Boolean;
		
		function add(rowItem : IRowItem) : void;
		
		function fillWithEmptyCell(cellSize : Rectangle) : void;
		
		function set parentRow(parentRow : IRow) : void;
		
		function get numItems() : uint;
		
		function get firstRowItem() : IRowItem;

	}
}
