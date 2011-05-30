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
package org.as3commons.ui.layout.framework.core.init {

	import org.as3commons.ui.layout.CellConfig;

	/**
	 * Cell configuration init object.
	 * 
	 * @author Jens Struwe 21.03.2011
	 */
	public dynamic class CellConfigInitObject {
		
		/**
		 * Horizontal index of items that are affected.
		 */
		public var hIndex : int = -1;

		/**
		 * Vertical index of items that are affected.
		 */
		public var vIndex : int = -1;

		/**
		 * Internal cell configuration object.
		 */
		public var cellConfig : CellConfig;

		/**
		 * <code>CellConfigInitObject</code> constructor.
		 */
		public function CellConfigInitObject() {
			cellConfig = new CellConfig();
		}

	}
}
