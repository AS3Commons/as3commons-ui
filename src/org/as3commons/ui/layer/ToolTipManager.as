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
	 * @author Jens Struwe 01.06.2011
	 */
	public class ToolTipManager {

		private var _container : Sprite;
		private var _selectors : IOrderedMap;
		private var _currentAdapter : ToolTipAdapter;

		public function ToolTipManager(container : Sprite) {
			_container = container;
			_container.mouseEnabled = false;
			_container.mouseChildren = false;

			_selectors = new LinkedMap();
		}
		
		public function registerToolTip(selector : IToolTipSelector, adapter : ToolTipAdapter, toolTip : DisplayObject) : void {
			if (_selectors.hasKey(selector)) _selectors.replaceFor(selector, adapter);
			else _selectors.add(selector, adapter);
			
			adapter.as3commons_ui::setUp_internal(toolTip);
		}

		public function show(owner : DisplayObject, content : *, properties : Object = null) : void {
			if (_currentAdapter) hide();
			
			var adapter : ToolTipAdapter = getAdapter(owner);
			if (!adapter) return;
			
			adapter.as3commons_ui::add_internal(_container);
			adapter.as3commons_ui::show_internal(owner, content);
			_currentAdapter = adapter;
		}

		public function hide() : void {
			if (!_currentAdapter) return;
			
			_currentAdapter.as3commons_ui::remove_internal();
			_currentAdapter = null;
		}

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
