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
package org.as3commons.ui.lifecycle.lifecycle.core {

	import org.as3commons.ui.lifecycle.i10n.II10NSelector;

	import flash.display.DisplayObject;

	/**
	 * <code>II10NSelector</code> implementation used by <code>LifeCycle</code>.
	 * 
	 * @author Jens Struwe 26.05.2011
	 */
	public class I10NSelector implements II10NSelector {

		/**
		 * Internal <code>LifeCycle</code> registry reference.
		 */
		private var _registry : LifeCycleRegistry;

		/**
		 * <code>I10NSelector</code> constructor.
		 */
		public function I10NSelector(registry : LifeCycleRegistry) {
			_registry = registry;
		}

		/**
		 * @inheritDoc
		 */
		public function approve(displayObject : DisplayObject) : Boolean {
			return _registry.componentRegistered(displayObject);
		}
	}
}
