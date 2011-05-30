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

	import org.as3commons.ui.layout.framework.IHLayout;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.HLayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;

	/**
	 * Horizontal multiline layout.
	 * 
	 * @author Jens Struwe 09.03.2011
	 */
	public class HLayout extends AbstractMultilineLayout implements IHLayout {
		
		/**
		 * Max number of items per row.
		 */
		private var _maxItemsPerRow : uint;

		/**
		 * Max width of the layout.
		 */
		private var _maxContentWidth : uint;

		/*
		 * IHLayout
		 */
		
		// Config - Max Size
		
		/**
		 * @inheritDoc
		 */
		public function set maxItemsPerRow(maxItemsPerRow : uint) : void {
			_maxItemsPerRow = maxItemsPerRow;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxItemsPerRow() : uint {
			return _maxItemsPerRow;
		}

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
		public function get numLayoutRows() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		/*
		 * Info
		 */

		/**
		 * @inheritDoc
		 */
		override public function toString() : String {
			return "[HLayout]" + super.toString();
		}

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function createParser() : ILayoutParser {
			var parser : ILayoutParser = new HLayoutParser();
			return parser;
		}

	}
}
