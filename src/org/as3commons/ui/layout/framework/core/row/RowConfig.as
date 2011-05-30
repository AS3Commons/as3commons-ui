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

	import org.as3commons.ui.layout.constants.Align;

	/**
	 * Row config object.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class RowConfig {

		/**
		 * The min width of the row.
		 */
		public var minWidth : uint;

		/**
		 * The min height of the row.
		 */
		public var minHeight : uint;

		/**
		 * The max size of the row.
		 */
		public var maxContentSize : uint;

		/**
		 * The max number of items of the row.
		 */
		public var maxItems : uint;

		/**
		 * The space between items.
		 */
		public var gap : uint;

		/**
		 * Horizontal align.
		 */
		public var hAlign : String = Align.LEFT;

		/**
		 * Vertical align.
		 */
		public var vAlign : String = Align.TOP;

	}
}
