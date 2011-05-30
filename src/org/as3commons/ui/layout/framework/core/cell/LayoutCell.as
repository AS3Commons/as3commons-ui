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
package org.as3commons.ui.layout.framework.core.cell {

	import org.as3commons.ui.layout.framework.core.row.IRow;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Layout cell.
	 * 
	 * @author Jens Struwe 17.03.2011
	 */
	public class LayoutCell extends AbstractCell implements ILayoutCell {
		
		/**
		 * The first row of the layout.
		 */
		private var _row : IRow;
		
		/*
		 * ILayoutCell
		 */
		
		/**
		 * @inheritDoc
		 */
		public function set row(row : IRow) : void {
			_row = row;
		}

		/**
		 * @inheritDoc
		 */
		public function get row() : IRow {
			return _row;
		}
		
		/*
		 * IBox
		 */
		
		/**
		 * @inheritDoc
		 */
		override public function get visibleRect() : Rectangle {
			return _row.visibleRect;
		}

		/*
		 * Protected
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function measureCellContent() : void {
			_space = row.space.clone();
		}

		/**
		 * @inheritDoc
		 */
		override protected function renderCellContent(position : Point) : void {
			_row.position.x = position.x;
			_row.position.y = position.y;
			_row.render();
		}

	}
}
