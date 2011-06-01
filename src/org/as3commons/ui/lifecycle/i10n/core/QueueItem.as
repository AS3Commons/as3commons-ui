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
package org.as3commons.ui.lifecycle.i10n.core {

	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;

	import flash.display.DisplayObject;

	/**
	 * Validation queue item.
	 * 
	 * @author Jens Struwe 27.05.2011
	 */
	public class QueueItem {

		/**
		 * The component to be validated.
		 */
		private var _displayObject : DisplayObject;
		
		/**
		 * List of invalid properties.
		 */
		private var _properties : IOrderedSet;
	
		/**
		 * <code>QueueItem</code> constructor.
		 * 
		 * @param theDisplayObject The component.
		 */
		public function QueueItem(theDisplayObject : DisplayObject) {
			_displayObject = theDisplayObject;
		}
	
		/**
		 * The component to be validated.
		 */
		public function get displayObject() : DisplayObject {
			return _displayObject;
		}
	
		/**
		 * Adds a property to the invalid properties list.
		 * 
		 * <p>If the list already contains the property <code>Invalidation.ALL_PROPERTIES</code>
		 * any other property will be refused.</p>
		 * 
		 * <p>If the given property is <code>Invalidation.ALL_PROPERTIES</code>
		 * any other property will be removed from the list.</p>
		 * 
		 * @param property The property to add.
		 */
		public function addProperty(property : String) : void {
			if (!_properties) _properties = new LinkedSet();
			if (_properties.has(Invalidation.ALL_PROPERTIES)) return;
			if (property == Invalidation.ALL_PROPERTIES) _properties.clear();
			_properties.add(property);
		}
	
		/**
		 * Returns the list of properties.
		 * 
		 * @return The list of properties.
		 */
		public function getProperties() : IOrderedSet {
			return _properties;
		}
	
	}
}
