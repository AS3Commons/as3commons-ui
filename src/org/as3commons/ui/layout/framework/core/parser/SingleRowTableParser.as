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

	import org.as3commons.ui.layout.framework.IMultilineLayout;
	import org.as3commons.ui.layout.framework.core.row.HRow;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * Optimized parser for a table containg only a single row.
	 * 
	 * @author Jens Struwe 19.03.2011
	 */
	public class SingleRowTableParser extends AbstractGroupLayoutParser {

		/*
		 * Protected
		 */
		 
		/**
		 * @inheritDoc
		 */
		override protected function createRow() : IRow {
			var row : IRow = new HRow();

			row.config.minWidth = _layout.minWidth;
			row.config.minHeight = _layout.minHeight;
			row.config.gap = IMultilineLayout(_layout).hGap;
			row.config.hAlign = _layout.hAlign;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

	}
}
