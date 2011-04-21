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
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractRowItem extends SizeItem implements IRowItem {

		private var _nextRowItem : IRowItem;
		protected var _isFirst : Boolean;
		protected var _isLast : Boolean;

		/*
		 * IRowItem
		 */

		public function set isFirst(isFirst : Boolean) : void {
			_isFirst = isFirst;
		}

		public function get isFirst() : Boolean {
			return _isFirst;
		}

		public function set isLast(isLast : Boolean) : void {
			_isLast = isLast;
		}

		public function get isLast() : Boolean {
			return _isLast;
		}

		public function set nextRowItem(row : IRowItem) : void {
			_nextRowItem = row;
		}

		public function get nextRowItem() : IRowItem {
			return _nextRowItem;
		}

	}
}
