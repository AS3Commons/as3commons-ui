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

	import org.as3commons.ui.layout.framework.core.sizeitem.SizeItem;

	/**
	 * Abstract row item implementation.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractRowItem extends SizeItem implements IRowItem {

		/**
		 * The next item in row.
		 */
		private var _nextRowItem : IRowItem;

		/**
		 * Flag, <code>true</code> it the item is the first in the row.
		 */
		protected var _isFirst : Boolean;

		/**
		 * Flag, <code>true</code> it the item is the last in the row.
		 */
		protected var _isLast : Boolean;

		/*
		 * IRowItem
		 */

		/**
		 * @inheritDoc
		 */
		public function set isFirst(isFirst : Boolean) : void {
			_isFirst = isFirst;
		}

		/**
		 * @inheritDoc
		 */
		public function get isFirst() : Boolean {
			return _isFirst;
		}

		/**
		 * @inheritDoc
		 */
		public function set isLast(isLast : Boolean) : void {
			_isLast = isLast;
		}

		/**
		 * @inheritDoc
		 */
		public function get isLast() : Boolean {
			return _isLast;
		}

		/**
		 * @inheritDoc
		 */
		public function set nextRowItem(row : IRowItem) : void {
			_nextRowItem = row;
		}

		/**
		 * @inheritDoc
		 */
		public function get nextRowItem() : IRowItem {
			return _nextRowItem;
		}

	}
}
