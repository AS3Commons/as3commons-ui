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
package org.as3commons.ui.layout.framework.core.config {

	import flash.display.Sprite;

	/**
	 * Render config object.
	 * 
	 * @author Jens Struwe 24.03.2011
	 */
	public class RenderConfig {

		/**
		 * The container of the layout.
		 */
		public var container : Sprite;

		/**
		 * Flag to indicate that the item is to show during the next layout procedure.
		 */
		public var show : Boolean = false;

		/**
		 * Flag to indicate that the item is to hide during the next layout procedure.
		 */
		public var hide : Boolean = false;

		/**
		 * Render callback.
		 */
		public var renderCallback : Function;

		/**
		 * Hide callback.
		 */
		public var hideCallback : Function;

		/**
		 * Show callback.
		 */
		public var showCallback : Function;
		
		/**
		 * Clones a render config.
		 * 
		 * @return The cloned config.
		 */
		public function clone() : RenderConfig {
			var config : RenderConfig = new RenderConfig();
			config.container = container;
			config.show = show;
			config.hide = hide;
			config.renderCallback = renderCallback;
			config.hideCallback = hideCallback;
			config.showCallback = showCallback;
			return config;
		}

	}
}
