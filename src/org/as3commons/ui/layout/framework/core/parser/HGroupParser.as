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
package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.framework.core.row.HRow;

	/**
	 * Horizontal multiline layout parser.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class HGroupParser extends AbstractGroupLayoutParser {

		/**
		 * <code>HGroupParser</code> constructor.
		 */
		public function HGroupParser() {
			_RowType = HRow;
		}

		/**
		 * @inheritDoc
		 */
		override protected function getCellConfig(index : int) : CellConfig {
			return _layout.getCellConfig(index);
		}

	}
}
