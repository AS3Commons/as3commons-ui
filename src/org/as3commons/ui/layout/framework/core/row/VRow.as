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
	 * @author Jens Struwe 17.03.2011
	 */
	public class VRow extends AbstractRow {

		public function VRow() {
			_x = "y";
			_y = "x";
			_width = "height";
			_height = "width";

			_align = "vAlign";
			_alignLeft = Align.TOP;
			_alignCenter = Align.MIDDLE;
			_alignRight = Align.BOTTOM;
	
			_oppositeAlign = "hAlign";
			_oppositeAlignTop = Align.LEFT;
			_oppositeAlignMiddle = Align.CENTER;
			_oppositeAlignBottom = Align.RIGHT;
		}

	}

}
