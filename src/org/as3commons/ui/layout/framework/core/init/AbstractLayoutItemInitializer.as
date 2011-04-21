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

	import org.as3commons.ui.layout.framework.ILayoutItem;

	/**
	 * @author Jens Struwe 23.03.2011
	 */
	public class AbstractLayoutItemInitializer {
		
		protected var _layoutItem : ILayoutItem;
		private var _inLayout : Boolean = true;
		private var _hide : Boolean = true;
		
		public function init(layoutItem : ILayoutItem, args : Array) : void {
			_layoutItem = layoutItem;

			for (var i : uint = 0; i < args.length; i++) {
				// config property
				if (args[i] is String) {
					initProperty(args[i], args[i + 1]);
					i++;
	
				// display object
				} else {
					initOther(args[i]);
				}
			}
			
			if (!_inLayout) {
				_layoutItem.excludeFromLayout(_hide);
			}
		}
		
		/*
		 * Protected
		 */

		protected function initOther(arg : *) : void {
			// template method
		}
		
		/*
		 * Private
		 */

		private function initProperty(property : String, value : *) : void {
			if (property == "inLayout") {
				_inLayout = value;
			} else if (property == "visible") {
				_hide = !value;
			} else {
				try {
					_layoutItem[property] = value;
				} catch (e : Error) {
				}
			}
		}
		
	}
}
