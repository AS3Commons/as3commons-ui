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

	import org.as3commons.ui.layout.framework.core.AbstractGroupLayout;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.VGroupParser;

	/**
	 * Vertical single line layout.
	 * 
	 * @author Jens Struwe 09.03.2011
	 */
	public class VGroup extends AbstractGroupLayout {

		/*
		 * ILayout
		 */

		/**
		 * @inheritDoc
		 */
		override public function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			super.setCellConfig(cellConfig, -1, vIndex);
		}

		/*
		 * Info
		 */

		/**
		 * @inheritDoc
		 */
		override public function toString() : String {
			return "[VGroup]" + super.toString();
		}

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function createParser() : ILayoutParser {
			var parser : ILayoutParser = new VGroupParser();
			return parser;
		}

	}

}
