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

	import org.as3commons.ui.layout.constants.Align;

	/**
	 * Layout cell config object.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class CellConfig {
		
		/**
		 * Cell width.
		 */
		private var _width : uint;

		/**
		 * Cell height.
		 */
		private var _height : uint;

		/**
		 * Cell horizontal margin.
		 */
		private var _marginX : int;

		/**
		 * Cell vertical margin.
		 */
		private var _marginY : int;

		/**
		 * Cell horizontal offset.
		 */
		private var _offsetX : int;

		/**
		 * Cell vertical offset.
		 */
		private var _offsetY : int;

		/**
		 * Cell horizontal align.
		 */
		private var _hAlign : String = Align.LEFT;

		/**
		 * Cell vertical align.
		 */
		private var _vAlign : String = Align.TOP;
		
		/**
		 * Changed properties.
		 */
		private var _propertiesSet : Object;

		/**
		 * CellConfig constructor.
		 */
		public function CellConfig() {
			_propertiesSet = new Object();
		}

		/**
		 * Cell width.
		 */
		public function set width(width : uint) : void {
			_width = width;
			_propertiesSet["width"] = true;
		}

		/**
		 * @private
		 */
		public function get width() : uint {
			return _width;
		}

		/**
		 * Cell height.
		 */
		public function set height(height : uint) : void {
			_height = height;
			_propertiesSet["height"] = true;
		}

		/**
		 * @private
		 */
		public function get height() : uint {
			return _height;
		}

		/**
		 * Cell horizontal margin.
		 */
		public function set marginX(marginX : int) : void {
			_marginX = marginX;
			_propertiesSet["marginX"] = true;
		}

		/**
		 * @private
		 */
		public function get marginX() : int {
			return _marginX;
		}

		/**
		 * Cell vertical margin.
		 */
		public function set marginY(marginY : int) : void {
			_marginY = marginY;
			_propertiesSet["marginY"] = true;
		}

		/**
		 * @private
		 */
		public function get marginY() : int {
			return _marginY;
		}

		/**
		 * Cell horizontal offset.
		 */
		public function set offsetX(offsetX : int) : void {
			_offsetX = offsetX;
			_propertiesSet["offsetX"] = true;
		}

		/**
		 * @private
		 */
		public function get offsetX() : int {
			return _offsetX;
		}

		/**
		 * Cell vertical offset.
		 */
		public function set offsetY(offsetY : int) : void {
			_offsetY = offsetY;
			_propertiesSet["offsetY"] = true;
		}

		/**
		 * @private
		 */
		public function get offsetY() : int {
			return _offsetY;
		}

		/**
		 * Cell horizontal align.
		 */
		public function set hAlign(hAlign : String) : void {
			_hAlign = hAlign;
			_propertiesSet["hAlign"] = true;
		}

		/**
		 * @private
		 */
		public function get hAlign() : String {
			return _hAlign;
		}

		/**
		 * Cell vertical align.
		 */
		public function set vAlign(vAlign : String) : void {
			_vAlign = vAlign;
			_propertiesSet["vAlign"] = true;
		}

		/**
		 * @private
		 */
		public function get vAlign() : String {
			return _vAlign;
		}
		
		public function propertyExplicitlySet(property : String) : Boolean {
			return _propertiesSet.hasOwnProperty(property);
		}

	}
}
