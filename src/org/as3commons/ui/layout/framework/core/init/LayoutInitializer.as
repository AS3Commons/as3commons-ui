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

	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.framework.ILayoutItem;

	import flash.display.DisplayObject;

	/**
	 * Initializes a layout.
	 * 
	 * @author Jens Struwe 23.03.2011
	 */
	public class LayoutInitializer extends AbstractLayoutItemInitializer {
		
		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function initOther(arg : *) : void {
			// item or list of items to be added
			if (arg is Array || arg is DisplayObject || arg is ILayoutItem) {
				layout.add(arg);
			// config object
			} else if (arg is CellConfigInitObject) {
				var cellConfigInitObject : CellConfigInitObject = arg;
				layout.setCellConfig(cellConfigInitObject.cellConfig, cellConfigInitObject.hIndex, cellConfigInitObject.vIndex);
			}
		}
		
		/*
		 * Private
		 */

		/**
		 * Cast the internal layout item to <code>ILayout</code>.
		 */
		private function get layout() : ILayout {
			return _layoutItem as ILayout;
		}
		
	}
}
