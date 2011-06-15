package org.as3commons.ui.layer {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.framework.IOrderedMap;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.layer.tooltip.IToolTipSelector;
	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * Tooltip management class.
	 * 
	 * <p>Adds, removes and places tooltips.</p>
	 * 
	 * @author Jens Struwe 01.06.2011
	 */
	public class ToolTipManager {

		/**
		 * The tooltip container.
		 */
		private var _container : Sprite;

		/**
		 * The mappings of selectors to adapters.
		 */
		private var _selectors : IOrderedMap;

		/**
		 * Adapter of the tooltip currently being shown.
		 */
		private var _currentAdapter : ToolTipAdapter;

		/**
		 * ToolTipManager constructor.
		 */
		public function ToolTipManager(container : Sprite) {
			_container = container;
			_container.mouseEnabled = false;
			_container.mouseChildren = false;

			_selectors = new LinkedMap();
		}
		
		/**
		 * Registers a tooltip adapter.
		 * 
		 * @param selector The selector to decide for what source objects the adapter should be considered.
		 * @param adapter The adapter being able to call tooltip methods.
		 * @param toolTip The tooltip instance used with the given adapter.
		 */
		public function registerToolTip(selector : IToolTipSelector, adapter : ToolTipAdapter, toolTip : DisplayObject) : void {
			if (adapter.toolTip) throw new Error ("You cannot reuse a tooltip adapter");
			if (_selectors.hasKey(selector)) _selectors.replaceFor(selector, adapter);
			else _selectors.add(selector, adapter);
			
			adapter.as3commons_ui::setUp_internal(toolTip);
		}

		/**
		 * Removes a tooltip adapter.
		 * 
		 * @param selector The selector mapped to the adapter to remove.
		 */
		public function unregisterAdapter(selector : IToolTipSelector) : void {
			_selectors.removeKey(selector);
		}

		/**
		 * Shows a tooltip.
		 * 
		 * @param owner The tooltip owner.
		 * @param content The tooltip content (usually text).
		 */
		public function show(owner : DisplayObject, content : *) : void {
			if (_currentAdapter) hide();
			
			var adapter : ToolTipAdapter = getAdapter(owner);
			if (!adapter) return;
			
			adapter.as3commons_ui::add_internal(_container);
			adapter.as3commons_ui::show_internal(owner, content);
			_currentAdapter = adapter;
		}

		/**
		 * Hides the current tooltip, if any.
		 */
		public function hide() : void {
			if (!_currentAdapter) return;
			
			_currentAdapter.as3commons_ui::remove_internal();
			_currentAdapter = null;
		}

		/**
		 * Returns the latest added adapter whose selector matchs the given display object.
		 */
		private function getAdapter(displayObject : DisplayObject) : ToolTipAdapter {
			var adapter : ToolTipAdapter;
			var iterator : IMapIterator = _selectors.iterator() as IMapIterator;
			while (iterator.hasNext()) {
				iterator.next();
				if (IToolTipSelector(iterator.key).approve(displayObject)) {
					adapter = iterator.current;
				}
			}
			return adapter;
		}

	}
}
