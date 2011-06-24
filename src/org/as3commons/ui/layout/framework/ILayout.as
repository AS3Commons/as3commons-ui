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
package org.as3commons.ui.layout.framework {

	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.ui.layout.CellConfig;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * Basic layout definition.
	 * 
	 * @author Jens Struwe 21.03.2011
	 */
	public interface ILayout extends ILayoutItem, IIterable {

		/*
		 * Config - Cell
		 */

		/**
		 * Sets a cell config affecting all cells specified by <code>hIndex</code> and <code>vIndex</code>.
		 * 
		 * @param cellConfig The cell config.
		 * @param hIndex The horizontal index of the affected cell or cells.
		 * @param hIndex The vertical index of the affected cell or cells.
		 */
		function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void;

		/**
		 * Returns the cell config for the cell specified by <code>hIndex</code> and <code>vIndex</code>.
		 * 
		 * @param hIndex The horizontal index of the cell.
		 * @param hIndex The vertical index of the cell.
		 * @return The cell config.
		 */
		function getCellConfig(hIndex : int = -1, vIndex : int = -1) : CellConfig;

		/*
		 * Config - Min Size
		 */

		/**
		 * The min width of the layout.
		 */
		function set minWidth(minWidth : uint) : void;
		
		/**
		 * @private
		 */
		function get minWidth() : uint;
		
		/**
		 * The min height of the layout.
		 */
		function set minHeight(minHeight : uint) : void;
		
		/**
		 * @private
		 */
		function get minHeight() : uint;

		/*
		 * Add, Get, Remove
		 */
		
		/**
		 * Adds the given list of items to the layout.
		 * 
		 * <p>A single argument may be a plain display object, an <code>ILayoutItem</code> or an array
		 * containing each of them.</p>
		 * 
		 * @param args List of items to add to the layout.
		 */
		function add(...args) : void;
		
		/**
		 * Adds the given list of items in front of the layout.
		 * 
		 * <p>A single argument may be a plain display object, an <code>ILayoutItem</code> or an array
		 * containing each of them.</p>
		 * 
		 * <p>The item order of the given list is kept. The entire list is added in front and not
		 * its reversion.</p>
		 * 
		 * @param args List of items to add in front of the layout.
		 */
		function addFirst(...args) : void;
		
		/**
		 * Adds all display objects of the given container to the layout.
		 * 
		 * @param container The container to add its content to the layout.
		 */
		function addAll(container : Sprite) : void;
		
		/**
		 * Returns a layout item by a given key or list of keys.
		 * 
		 * <p>A single key may be an id (String) or a display object or
		 * an <code>ILayoutItem</code>.</p>
		 * 
		 * <p>If multiple arguments are given, the method tries to find the
		 * layout item hierarchically.</p>
		 * 
		 * @return The layout item found or <code>null</code>.
		 */
		function getLayoutItem(...args) : ILayoutItem;
		
		/**
		 * Returns a display object by a given key or list of keys.
		 * 
		 * <p>This is a convenient method to return a display object added
		 * to the layout. The method utilizes <code>getLayoutItem()</code>
		 * and casts the result to <code>DisplayObject</code> if possible.</p>
		 * 
		 * <p>A single key may be an id (String) or a display object or
		 * an <code>ILayoutItem</code>.</p>
		 * 
		 * <p>If multiple arguments are given, the method tries to find the
		 * display object hierarchically.</p>
		 * 
		 * @return The display object found or <code>null</code>.
		 */
		function getDisplayObject(...args) : DisplayObject;

		/**
		 * Returns an <code>IRecursiveIterator</code> over all added items.
		 * 
		 * @return An recursive iterator.
		 */
		function recursiveIterator() : IRecursiveIterator;
		
		/**
		 * Removes an item from the layout by the given key.
		 * 
		 * <p>A key may be an id (String) or a display object or
		 * an <code>ILayoutItem</code>.</p>
		 * 
		 * @param key The key identifying an item added to the layout.
		 */
		function remove(key : *) : void;

		/**
		 * Returns the number of items added to the layout.
		 */
		function get numItems() : uint;

		/*
		 * Layout
		 */

		/**
		 * Executed the layout procedure.
		 * 
		 * <p>If <code>relayout</code> is set to <code>true</code>, the layout will
		 * keep its origin from a former layout process. This may be useful if only
		 * a sublayout should be updated.</p>
		 * 
		 * @param container The container that contains the items.
		 * @param relayout Flag to indicate if a former position should be reused.
		 */
		function layout(container : Sprite, relayout : Boolean = false) : void;

	}
}
