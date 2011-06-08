package org.as3commons.ui.layer.tooltip {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.layer.placement.AbstractPlacement;
	import org.as3commons.ui.layer.placement.PlacementAnchor;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author Jens Struwe 08.06.2011
	 */
	public class ToolTipAdapter extends AbstractPlacement {
		protected var _autoHideAfter : Number;
		protected var _hideDelay : uint;
		
		public function ToolTipAdapter() {
			_sourceAnchor = PlacementAnchor.TOP_RIGHT;
			_layerAnchor = PlacementAnchor.BOTTOM_LEFT;
		}

		public function set ownerAnchor(ownerAnchor : uint) : void {
			_sourceAnchor = ownerAnchor;
		}

		public function get ownerAnchor() : uint {
			return _sourceAnchor;
		}

		public function set toolTipAnchor(toolTipAnchor : uint) : void {
			_layerAnchor = toolTipAnchor;
		}
		
		public function get toolTipAnchor() : uint {
			return _layerAnchor;
		}
		
		public function set autoHideAfter(autoHideAfter : Number) : void {
			_autoHideAfter = autoHideAfter;
		}

		public function get autoHideAfter() : Number {
			return _autoHideAfter;
		}

		public function get toolTipGlobal() : Point {
			return _layerGlobal;
		}

		public function get toolTipLocal() : Point {
			return _layerLocal;
		}

		/*
		 * Internal
		 */

		as3commons_ui function setUp_internal(toolTip : DisplayObject) : void {
			_layer = toolTip;
			onToolTip(_layer);
		}

		as3commons_ui function add_internal(container : Sprite) : void {
			clearTimeout(_hideDelay);
			container.addChild(_layer);
		}

		as3commons_ui function show_internal(owner : DisplayObject, content : *) : void {
			// set owner
			_source = owner;
			// set content
			onContent(_layer, content);
			// place
			calculatePosition();
			// draw
			onDraw(
				_layer,
				_usedPlacement.sourceAnchor, _usedPlacement.layerAnchor,
				_usedPlacement.hShift, _usedPlacement.vShift
			);
			// set position
			onShow(_layer, _layerLocal);
		}

		as3commons_ui function remove_internal() : void {
			onRemove(_layer);
		}

		/*
		 * Protected
		 */

		protected function onToolTip(toolTip : DisplayObject) : void {
			// hook
		}

		protected function onContent(toolTip : DisplayObject, content : *) : void {
			// hook
		}

		protected function onDraw(toolTip : DisplayObject, ownerAnchor : uint, toolTipAnchor : uint, hShift : int, vShift : int) : void {
			// hook
		}

		protected function onShow(toolTip : DisplayObject, local : Point) : void {
			// hook
		}

		protected function onRemove(toolTip : DisplayObject) : void {
			// hook
			commitRemove();
		}

		protected function commitRemove() : void {
			if (!_layer.parent) return; // already removed
			
			_layer.parent.removeChild(_layer);
			_source = null;
			reset();
		}

		protected function startAutoHide() : void {
			if (_autoHideAfter) {
				clearTimeout(_hideDelay);
				_hideDelay = setTimeout(onRemove, _autoHideAfter, _layer);
			}
		}

	}
}
