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

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.collections.iterators.RecursiveIterator;
	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.Display;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.framework.ILayoutItem;
	import org.as3commons.ui.layout.framework.core.config.CellConfigCollection;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Abstract layout implementation.
	 * 
	 * @author Jens Struwe 15.03.2011
	 */
	public class AbstractLayout extends AbstractLayoutItem implements ILayout {

		/**
		 * Cell configurations.
		 */
		private var _cellConfigs : CellConfigCollection;

		/**
		 * Min width.
		 */
		private var _minWidth : uint;

		/**
		 * Min height.
		 */
		private var _minHeight : uint;

		/**
		 * Map of layout items.
		 */
		private var _items : LinkedMap;

		/**
		 * Map of ids to layout items.
		 */
		private var _itemIds : Map;

		/**
		 * List of sublayouts.
		 */
		private var _subLayouts : LinkedSet;
		
		/**
		 * <code>AbstractLayout</code> constructor.
		 */
		public function AbstractLayout() {
			_items = new LinkedMap();
		}

		/*
		 * ILayout
		 */

		// Config - Cell
		
		/**
		 * @inheritDoc
		 */
		public function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			if (!_cellConfigs) _cellConfigs = new CellConfigCollection();
			_cellConfigs.setConfig(cellConfig, hIndex, vIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function getCellConfig(hIndex : int = -1, vIndex : int = -1) : CellConfig {
			if (!_cellConfigs) return null;
			return _cellConfigs.getConfig(hIndex, vIndex);
		}

		// Config - Min Size

		/**
		 * @inheritDoc
		 */
		public function set minWidth(minWidth : uint) : void {
			_minWidth = minWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function get minWidth() : uint {
			return _minWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function set minHeight(minHeight : uint) : void {
			_minHeight = minHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function get minHeight() : uint {
			return _minHeight;
		}

		// Add, Get, Remove
		
		/**
		 * @inheritDoc
		 */
		public function add(...args) : void {
			var item : *;
			var layoutItem : AbstractLayoutItem;
			
			for (var i : uint = 0; i < args.length; i++) {
				item = args[i];
				
				// array of items
				if (item is Array) {
					add.apply(null, item);
					continue;
				}
				
				// single item
				if (item is DisplayObject) {
					var display : Display = new Display();
					display.displayObject = item;
					_items.add(item, display);
					
					layoutItem = display;

				} else if (item is AbstractLayoutItem) {
					if (item is Display) {
						if (!Display(item).displayObject) continue;
						_items.add(Display(item).displayObject, item);

					} else if (item is AbstractLayout) {
						_items.add(item, item);
	
						if (!_subLayouts) _subLayouts = new LinkedSet();
						_subLayouts.add(item);
					}
					layoutItem = item;

				} else {
					continue;
				}
				
				if (layoutItem.id) {
					if (!_itemIds) _itemIds = new Map();
					_itemIds.add(layoutItem.id, layoutItem);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addAll(container : Sprite) : void {
			var i : uint;
			while (i < container.numChildren) {
				add(container.getChildAt(i));
				i++;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getLayoutItem(...args) : ILayoutItem {
			var layoutItem : ILayoutItem;
			var layout : AbstractLayout = this;

			var i : uint;
			for (i = 0; i < args.length; i++) {
				layoutItem = layout.findLayoutItemByKey(args[i]);
				
				if (layoutItem && layoutItem is AbstractLayout) {
					layout = layoutItem as AbstractLayout;
				} else {
					i++;
					break;
				}
			}
			
			return i == args.length ? layoutItem : null;
		}

		/**
		 * @inheritDoc
		 */
		public function recursiveIterator() : IRecursiveIterator {
			return new RecursiveIterator(this);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(key : *) : void {
			var layoutItem : ILayoutItem = getLayoutItemByKey(key);
			if (!layoutItem) return;
			
			if (layoutItem is Display) {
				_items.removeKey(Display(layoutItem).displayObject);

			} else if (layoutItem is AbstractLayout) {
				_items.removeKey(layoutItem);

				_subLayouts.remove(layoutItem);
				if (!_subLayouts.size) _subLayouts = null;
			}

			if (layoutItem.id) {
				_itemIds.removeKey(layoutItem.id);
				if (!_itemIds.size) _itemIds = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get numItems() : uint {
			return _items.size;
		}

		// Layout

		/**
		 * @inheritDoc
		 */
		public function layout(container : Sprite, relayout : Boolean = false) : void {
			var renderConfig : RenderConfig;
			var position : Point;

			if (relayout && _cell) {
				renderConfig = _cell.renderConfig;
				position = _cell.position;
			} else {
				position = new Point();
			}
			
			if (!renderConfig) renderConfig = createRenderConfig();
			renderConfig.container = container;
			
			if (!_inLayout) {
				exclude(renderConfig);

			} else {
				parse(renderConfig);
				_cell.position.offset(position.x, position.y);
				_cell.render();
			}
		}

		/*
		 * IIterable
		 */

		/**
		 * @inheritDoc
		 */
		public function iterator(cursor : * = undefined) : IIterator {
			return _items.iterator();
		}

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function parseLayoutItem(renderConfig : RenderConfig) : void {
			var parser : ILayoutParser = createParser();
			parser.layout = this;
			parser.prepare();
			
			var iterator : IIterator = _items.iterator();
			var layoutItem : AbstractLayoutItem;
			var layoutItemRenderConfig : RenderConfig;
			
			while (iterator.hasNext()) {
				layoutItem = iterator.next();
				
				layoutItemRenderConfig = layoutItem.createRenderConfig(renderConfig);
				
				if (layoutItem.inLayout) {
					layoutItem.parse(layoutItemRenderConfig);
					parser.parseCell(layoutItem.cell);

				} else {
					layoutItem.exclude(layoutItemRenderConfig);
				}
			}
			
			_cell = parser.finish();
			_cell.renderConfig = renderConfig;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function excludeLayoutItem(renderConfig : RenderConfig) : void {
			var iterator : IIterator = _items.iterator();
			var layoutItem : AbstractLayoutItem;
			var layoutItemRenderConfig : RenderConfig;

			while (iterator.hasNext()) {
				layoutItem = iterator.next();
				
				layoutItemRenderConfig = layoutItem.createRenderConfig(renderConfig);
				layoutItem.exclude(layoutItemRenderConfig);
			}
		}

		/**
		 * Creates a layout parser specific to the particular layout.
		 * 
		 * @return The layout parser.
		 */
		protected function createParser() : ILayoutParser {
			// template method
			return null;
		}

		/*
		 * Private
		 */

		/**
		 * Tests if the layout contains the given layout item.
		 */
		private function hasLayoutItem(layoutItem : AbstractLayoutItem) : Boolean {
			return _items.hasKey(layoutItem);
		}

		/**
		 * Returns the layout item stored with the given display object.
		 */
		private function getLayoutItemByDisplayObject(displayObject : DisplayObject) : AbstractLayoutItem {
			return _items.itemFor(displayObject);
		}

		/**
		 * Returns the layout item stored with the given id.
		 */
		private function getLayoutItemById(id : String) : AbstractLayoutItem {
			if (!_itemIds) return null;
			return _itemIds.itemFor(id);
		}

		/**
		 * Returns the layout item by a given key.
		 * 
		 * The key can be one of the following:
		 * - The id of a sublayout or a display
		 * - A sublayout or display instance
		 * - A display object
		 */
		private function getLayoutItemByKey(key : *) : ILayoutItem {
			if (key is Display) key = Display(key).displayObject;
			
			if (key is String) return getLayoutItemById(key); // id
			else if (key is DisplayObject) return getLayoutItemByDisplayObject(key); // DisplayObject
			else if (key is AbstractLayout && hasLayoutItem(key)) return key; // Layout

			return null;
		}

		/**
		 * Finds a layout item by key recursively.
		 */
		private function findLayoutItemByKey(key : *) : ILayoutItem {
			var layoutItem : ILayoutItem = getLayoutItemByKey(key);
			if (layoutItem) return layoutItem;
			if (!_subLayouts) return null;

			var subLayout : AbstractLayout;
			var iterator : IIterator = _subLayouts.iterator();
			while (iterator.hasNext()) {
				subLayout = iterator.next();
				layoutItem = subLayout.findLayoutItemByKey(key);
				if (layoutItem) return layoutItem;
			}
			return null;
		}

	}
}
