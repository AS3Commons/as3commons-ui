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

	/**
	 * Row properties.
	 * 
	 * @author Jens Struwe 18.03.2011
	 */
	public class AbstractRowDirection extends AbstractRowItem {

		/**
		 * Left position.
		 */
		protected var _x : String;

		/**
		 * Top position.
		 */
		protected var _y : String;

		/**
		 * With.
		 */
		protected var _width : String;

		/**
		 * Height
		 */
		protected var _height : String;
		
		/**
		 * Align property in row direction.
		 */
		protected var _align : String;

		/**
		 * Align.LEFT property in row direction.
		 */
		protected var _alignLeft : String;

		/**
		 * Align.CENTER property in row direction.
		 */
		protected var _alignCenter : String;

		/**
		 * Align.RIGHT property in row direction.
		 */
		protected var _alignRight : String;

		/**
		 * Align property in opposite direction.
		 */
		protected var _oppositeAlign : String;

		/**
		 * Align.TOP property in opposite direction.
		 */
		protected var _oppositeAlignTop : String;

		/**
		 * Align.MIDDLE property in opposite direction.
		 */
		protected var _oppositeAlignMiddle : String;

		/**
		 * Align.BOTTOM property in opposite direction.
		 */
		protected var _oppositeAlignBottom : String;

	}
}
