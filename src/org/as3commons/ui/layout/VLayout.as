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

	import org.as3commons.ui.layout.framework.IVLayout;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.VLayoutParser;

	/**
	 * @author Jens Struwe 09.03.2011
	 */
	public class VLayout extends AbstractMultilineLayout implements IVLayout {

		private var _maxItemsPerColumn : uint;
		private var _maxContentHeight : uint;

		/*
		 * IVLayout
		 */
		
		// Config - Max Size
		
		public function set maxItemsPerColumn(maxItemsPerColumn : uint) : void {
			_maxItemsPerColumn = maxItemsPerColumn;
		}

		public function get maxItemsPerColumn() : uint {
			return _maxItemsPerColumn;
		}

		public function set maxContentHeight(maxContentHeight : uint) : void {
			_maxContentHeight = maxContentHeight;
		}

		public function get maxContentHeight() : uint {
			return _maxContentHeight;
		}

		// Info

		public function get numLayoutColumns() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		/*
		 * Info
		 */

		override public function toString() : String {
			return "[VLayout]" + super.toString();
		}

		/*
		 * Protected
		 */

		override protected function createParser() : ILayoutParser {
			var parser : ILayoutParser = new VLayoutParser();
			return parser;
		}

	}
}
