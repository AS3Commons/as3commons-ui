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

	import org.as3commons.collections.framework.ISet;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;

	import flash.display.DisplayObject;


	/**
	 * <code>II10NApapter</code> implementation used by <code>LifeCycle</code>.
	 * 
	 * @author Jens Struwe 25.05.2011
	 */
	public class I10NAdapter implements II10NApapter {

		/**
		 * Internal <code>LifeCycle</code> reference.
		 */
		private var _lifeCycle : LifeCycle;

		/**
		 * <code>I10NAdapter</code> constructor.
		 */
		public function I10NAdapter(lifeCycleManager : LifeCycle) {
			_lifeCycle = lifeCycleManager;
		}

		/**
		 * @inheritDoc
		 */
		public function willValidate(displayObject : DisplayObject) : void {
			var adapter : LifeCycleAdapter = _lifeCycle.as3commons_ui::getAdapter_internal(displayObject);
			adapter.as3commons_ui::willValidate_internal();
		}

		/**
		 * @inheritDoc
		 */
		public function validate(displayObject : DisplayObject, properties : ISet) : void {
			var adapter : LifeCycleAdapter = _lifeCycle.as3commons_ui::getAdapter_internal(displayObject);
			adapter.as3commons_ui::validate_internal(properties);
		}

	}
}
