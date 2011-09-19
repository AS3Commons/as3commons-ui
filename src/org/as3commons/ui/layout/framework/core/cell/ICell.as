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

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.framework.core.AbstractLayoutItem;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;
	import org.as3commons.ui.layout.framework.core.row.IRowItem;
	import org.as3commons.ui.layout.framework.core.sizeitem.ISizeItem;

	import flash.geom.Rectangle;

	/**
	 * Layout cell definition.
	 * 
	 * @author Jens Struwe 16.03.2011
	 */
	public interface ICell extends ISizeItem, IRowItem {
		
		/*
		 * Owner
		 */

		/**
		 * The layout item hosted by this cell.
		 */
		function set layoutItem(layoutItem : AbstractLayoutItem) : void;

		/*
		 * Config
		 */

		/**
		 * The cell config.
		 */
		function get config() : CellConfig;

		/**
		 * The render config.
		 */
		function set renderConfig(renderConfig : RenderConfig) : void;

		/**
		 * @private
		 */
		function get renderConfig() : RenderConfig;

		/*
		 * Size
		 */

		/**
		 * <code>true</code> if the cell does not have any visible content.
		 */
		function isEmpty() : Boolean;

		/*
		 * Data
		 */

		/**
		 * The cell's content rect.
		 */
		function get contentRect() : Rectangle;

	}
}
