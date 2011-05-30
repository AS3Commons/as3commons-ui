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
package org.as3commons.ui.layout.framework.core {

	import org.as3commons.ui.layout.framework.IMultilineLayout;

	/**
	 * Abstract multiline layout implementation.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractMultilineLayout extends AbstractLayout implements IMultilineLayout {

		/**
		 * Horizontal space between items.
		 */
		private var _hGap : uint;

		/**
		 * Vertical space between items.
		 */
		private var _vGap : uint;

		/*
		 * IMultilineLayout
		 */
		
		// Config - Gap
		
		/**
		 * @inheritDoc
		 */
		public function set hGap(hGap : uint) : void {
			_hGap = hGap;
		}

		/**
		 * @inheritDoc
		 */
		public function get hGap() : uint {
			return _hGap;
		}

		/**
		 * @inheritDoc
		 */
		public function set vGap(vGap : uint) : void {
			_vGap = vGap;
		}

		/**
		 * @inheritDoc
		 */
		public function get vGap() : uint {
			return _vGap;
		}

	}
}
