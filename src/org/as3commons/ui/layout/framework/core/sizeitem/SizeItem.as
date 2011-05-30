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
package org.as3commons.ui.layout.framework.core.sizeitem {

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Abstract implementation of an item that can be measured and rendered.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class SizeItem implements ISizeItem {

		/**
		 * Space consumed by the item.
		 */
		protected var _space : Rectangle;

		/**
		 * The position of the item.
		 */
		protected var _position : Point;

		/**
		 * <code>SizeItem</code> constructor.
		 */
		public function SizeItem() {
			_position = new Point();
		}

		/*
		 * IBox
		 */

		// Measure
		
		/**
		 * @inheritDoc
		 */
		public function measure() : void {
			// template method
		}

		/**
		 * @inheritDoc
		 */
		public function get space() : Rectangle {
			return _space;
		}
		
		// Render

		/**
		 * @inheritDoc
		 */
		public function get position() : Point {
			return _position;
		}

		/**
		 * @inheritDoc
		 */
		public function render() : void {
			// template method
		}

		// Data

		/**
		 * @inheritDoc
		 */
		public function get visibleRect() : Rectangle {
			// template method
			return null;
		}

	}
}
