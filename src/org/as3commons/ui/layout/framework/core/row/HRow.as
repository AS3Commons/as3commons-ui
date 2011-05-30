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

	import org.as3commons.ui.layout.constants.Align;

	/**
	 * Horizontal row.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class HRow extends AbstractRow {

		/**
		 * <code>HRow</code> constructor.
		 */
		public function HRow() {
			_x = "x";
			_y = "y";
			_width = "width";
			_height = "height";

			_align = "hAlign";
			_alignLeft = Align.LEFT;
			_alignCenter = Align.CENTER;
			_alignRight = Align.RIGHT;
	
			_oppositeAlign = "vAlign";
			_oppositeAlignTop = Align.TOP;
			_oppositeAlignMiddle = Align.MIDDLE;
			_oppositeAlignBottom = Align.BOTTOM;
		}

	}

}
