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
package org.as3commons.ui.lifecycle.i10n {

	import flash.display.DisplayObject;

	/**
	 * <code>Invalidation</code> selector definition.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public interface II10NSelector {

		/**
		 * Returns <code>true</code>, if the adapter mapped to this selector
		 * should be considered for the given display object.
		 * 
		 * @param displayObject The component to test.
		 * @return <code>true</code> if the mapped adapter should be applied to this component. 
		 */
		function approve(displayObject : DisplayObject) : Boolean;

	}
}
