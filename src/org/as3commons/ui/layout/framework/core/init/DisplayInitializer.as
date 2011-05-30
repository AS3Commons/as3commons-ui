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

	import org.as3commons.ui.layout.Display;

	import flash.display.DisplayObject;

	/**
	 * Initializes a display object wrapper.
	 * 
	 * @author Jens Struwe 23.03.2011
	 */
	public class DisplayInitializer extends AbstractLayoutItemInitializer {

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function initOther(arg : *) : void {
			// display object
			if (arg is DisplayObject) {
				Display(_layoutItem).displayObject = arg;
			}
		}

	}
}
