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
	import org.as3commons.collections.StringMap;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.IOrderedMap;
	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.collections.iterators.RecursiveIterator;
	import org.as3commons.ui.framework.core.as3commons_ui;
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
	
	use namespace as3commons_ui;
	
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
		private var _items : IOrderedMap;

		/**
		 * Map of ids to layout items.
		 */
		private var _itemIds : IMap;

		/**
		 * List of sublayouts.
		 */
		private var _subLayouts : LinkedSet;
		
		/**
		 * Last used render config.
		 */
		private var _lastRenderConfig : RenderConfig;

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
			var items : Array = getItemsToAdd(args);
			for (var i : uint = 0; i < items.length; i += 2) {
				addItem(items[i], items[i + 1]);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addFirst(...args) : void {
			var items : Array = getItemsToAdd(args);
			for (var i : int = items.length - 2; i >= 0; i -= 2) {
				addItemFirst(items[i], items[i + 1]);
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
		public function getDisplayObject(...args) : DisplayObject {
			var layoutItem : ILayoutItem = getLayoutItem.apply(this, args);
			if (layoutItem && layoutItem is Display) return Display(layoutItem).displayObject;
			return null;
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
			if (LayoutLock.locked) return;
			
			LayoutLock.locked = true;
			
			var renderConfig : RenderConfig;
			var position : Point;

			if (relayout && _lastRenderConfig) {
				renderConfig = _lastRenderConfig;
				position = _position;
				
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

			LayoutLock.locked = false;
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
		 * as3commons_ui
		 */

		/**
		 * Updates all geometry data and stores the last render config.
		 */
		override as3commons_ui function notifyRenderFinished() : void {
			if (!_cell) return;

			_lastRenderConfig = _cell.renderConfig;
			
			super.notifyRenderFinished();
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
				
				// if our layout item is a display object, we want to
				// add it to the container if not done before. We need to
				// do this here in order to enable the object to set some dimensions
				// after it has been added to the stage.
				if (layoutItem is Display) {
					var displayObject : DisplayObject = Display(layoutItem).displayObject;
					if (displayObject.parent != renderConfig.container) {
						renderConfig.container.addChild(displayObject);
					}
				}
				
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
		 * Converts the given nested list of arguments into a flat one.
		 */
		private function getItemsToAdd(args : Array) : Array {
			var item : *;
			var items : Array = new Array();
			
			for (var i : uint = 0; i < args.length; i++) {
				item = args[i];
				
				// array of items
				if (item is Array) {
					items = items.concat(getItemsToAdd(item));
					continue;
				}
				
				// single item
				if (item is DisplayObject) {
					var display : Display = new Display();
					display.displayObject = item;
					items.push(item, display);

				} else if (item is AbstractLayoutItem) {
					if (item is Display) {
						if (!Display(item).displayObject) continue;
						items.push(Display(item).displayObject, item);

					} else if (item is AbstractLayout) {
						items.push(item, item);
					}

				} else {
					continue;
				}
			}

			return items;
		}

		/**
		 * Adds an item at end to the list.
		 */
		private function addItem(key : *, layoutItem : ILayoutItem) : void {
			_items.add(key, layoutItem);
			
			if (layoutItem is AbstractLayout) {
				if (!_subLayouts) _subLayouts = new LinkedSet();
				_subLayouts.add(layoutItem);
			}

			if (layoutItem.id) {
				if (!_itemIds) _itemIds = new StringMap();
				_itemIds.add(layoutItem.id, layoutItem);
			}
		}
		
		/**
		 * Adds an item in front of the list.
		 */
		private function addItemFirst(key : *, layoutItem : ILayoutItem) : void {
			_items.addFirst(key, layoutItem);
			
			if (layoutItem is AbstractLayout) {
				if (!_subLayouts) _subLayouts = new LinkedSet();
				_subLayouts.addFirst(layoutItem);
			}

			if (layoutItem.id) {
				if (!_itemIds) _itemIds = new Map();
				_itemIds.add(layoutItem.id, layoutItem);
			}
		}

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
