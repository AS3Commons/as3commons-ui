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
package org.as3commons.ui.layout.framework {

	/**
	 * Dynamic table definition.
	 * 
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IDynTable extends IMultilineLayout {

		/*
		 * Config - Max Size
		 */
		
		/**
		 * The max width of the layout.
		 */
		function set maxContentWidth(maxContentWidth : uint) : void;
		
		/**
		 * @private
		 */
		function get maxContentWidth() : uint;

		/*
		 * Info
		 */

		/**
		 * The number of columns created by the layout.
		 */
		function get numTableRows() : uint;

		/**
		 * @private
		 */
		function get numTableColumns() : uint;

	}
}
