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

	import org.as3commons.ui.layout.framework.ITable;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.SingleRowTableParser;
	import org.as3commons.ui.layout.framework.core.parser.TableParser;

	/**
	 * Table or grid layout.
	 * 
	 * @author Jens Struwe 09.03.2011
	 */
	public class Table extends AbstractMultilineLayout implements ITable {

		/**
		 * Number of columns.
		 */
		private var _numColumns : uint;

		/*
		 * ITable
		 */
		
		// Config - Max Size
		
		/**
		 * @inheritDoc
		 */
		public function set numColumns(numColumns : uint) : void {
			_numColumns = numColumns;
		}

		/**
		 * @inheritDoc
		 */
		public function get numColumns() : uint {
			return _numColumns;
		}

		// Info

		/**
		 * @inheritDoc
		 */
		public function get numTableRows() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		/*
		 * Info
		 */

		/**
		 * @inheritDoc
		 */
		override public function toString() : String {
			return "[Table]" + super.toString();
		}

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function createParser() : ILayoutParser {
			if (_numColumns) return new TableParser();
			else return new SingleRowTableParser();
		}

	}
}
