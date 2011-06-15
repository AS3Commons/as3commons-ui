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
	 * Basic tooltip adapter.
	 * 
	 * @author Jens Struwe 08.06.2011
	 */
	public class ToolTipAdapter extends AbstractPlacement {
		
		/**
		 * Auto hide delay.
		 */
		protected var _autoHideAfter : Number;

		/**
		 * Auto hide interval.
		 */
		protected var _hideDelay : uint;
		
		/**
		 * ToolTipAdapter constructor.
		 */
		public function ToolTipAdapter() {
			_sourceAnchor = PlacementAnchor.TOP_RIGHT;
			_layerAnchor = PlacementAnchor.BOTTOM_LEFT;
		}

		/**
		 * The tooltip.
		 * 
		 * <p>The property is first available within the <code>onToolTip()</code> hook.</p>
		 */
		public function get toolTip() : DisplayObject {
			return _layer;
		}

		/**
		 * The current tooltip's owner.
		 * 
		 * <p>The property is first available within the <code>onContent()</code> hook.</p>
		 */
		public function get owner() : DisplayObject {
			return _source;
		}

		/**
		 * Anchor of the tooltip owner.
		 */
		public function set ownerAnchor(ownerAnchor : uint) : void {
			_sourceAnchor = ownerAnchor;
		}

		/**
		 * @private
		 */
		public function get ownerAnchor() : uint {
			return _sourceAnchor;
		}

		/**
		 * Anchor of the tooltip.
		 */
		public function set toolTipAnchor(toolTipAnchor : uint) : void {
			_layerAnchor = toolTipAnchor;
		}
		
		/**
		 * @private
		 */
		public function get toolTipAnchor() : uint {
			return _layerAnchor;
		}
		
		/**
		 * Milliseconds after a tooltip shall be hidden automatically.
		 * 
		 * <p>Auto hide is disabled if set to 0 (zero).</p>
		 */
		public function set autoHideAfter(autoHideAfter : Number) : void {
			_autoHideAfter = autoHideAfter;
		}

		/**
		 * @private
		 */
		public function get autoHideAfter() : Number {
			return _autoHideAfter;
		}

		/**
		 * The calculated global tooltip position.
		 */
		public function get toolTipGlobal() : Point {
			return _layerGlobal;
		}

		/**
		 * The calculated local tooltip position.
		 */
		public function get toolTipLocal() : Point {
			return _layerLocal;
		}

		/*
		 * Internal
		 */

		/**
		 * Internal method to setup the tooltip initially.
		 * 
		 * @param toolTip The tooltip.
		 */
		as3commons_ui function setUp_internal(toolTip : DisplayObject) : void {
			_layer = toolTip;
			onToolTip(_layer);
		}

		/**
		 * Internal method to add the tooltip to the container.
		 * 
		 * @param container The container to add the tooltip to.
		 */
		as3commons_ui function add_internal(container : Sprite) : void {
			clearTimeout(_hideDelay);
			container.addChild(_layer);
		}

		/**
		 * Internal method to perform steps to calculate and set the tooltips position.
		 * 
		 * @param owner The tooltip's owner.
		 * @param content The tooltip' content (usually text).
		 */
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

		/**
		 * Internal method to remove the tooltip again.
		 */
		as3commons_ui function remove_internal() : void {
			onRemove(_layer);
		}

		/*
		 * Protected
		 */

		/**
		 * Hook that is invoked after the tooltip has been set to the adapter initially.
		 * 
		 * <p>The tooltip is supposed to perform some initial setups.</p>
		 * 
		 * <p>Called once for each adapter.</p>
		 * 
		 * @param toolTip The tooltip.
		 */
		protected function onToolTip(toolTip : DisplayObject) : void {
			// hook
		}

		/**
		 * Hook that is invoked after the tooltip content has been set or reset.
		 * 
		 * <p>The tooltip is supposed to calculate here it's final dimensions.</p>
		 * 
		 * <p>Called whenever the source object and content have been changed.</p>
		 * 
		 * @param toolTip The tooltip.
		 * @param content The tooltip' content (usually text).
		 */
		protected function onContent(toolTip : DisplayObject, content : *) : void {
			// hook
		}

		/**
		 * Hook that is invoked after the tooltip position has been calculated.
		 * 
		 * <p>The tooltip is supposed to finalize its visualization.</p>
		 * 
		 * <p>Called whenever the source object and content have been changed.</p>
		 * 
		 * @param toolTip The tooltip.
		 * @param ownerAnchor The used anchor of the owner.
		 * @param toolTipAnchor The used anchor of the tooltip.
		 * @param hShift Horizontal placement shift.
		 * @param vShift Vertical placement shift.
		 */
		protected function onDraw(toolTip : DisplayObject, ownerAnchor : uint, toolTipAnchor : uint, hShift : int, vShift : int) : void {
			// hook
		}

		/**
		 * Hook that is invoked when the tooltip should be shown.
		 * 
		 * <p>The tooltip is supposed to set the tooltip's position.</p>
		 * 
		 * <p>Called whenever a hidden tooltip should be shown.</p>
		 * 
		 * <p>If not overridden, the method will set the tooltips position right away.</p>
		 * 
		 * @param toolTip The tooltip.
		 * @param local The tooltip's local position.
		 */
		protected function onShow(toolTip : DisplayObject, local : Point) : void {
			// hook
			toolTip.x = local.x;
			toolTip.y = local.y;
			startAutoHide();
		}

		/**
		 * Hook that is invoked in order to remove a tooltip.
		 * 
		 * <p>Called whenever a tooltip should be hidden.</p>
		 * 
		 * <p>To finalize the removal, the adapter needs to commit the removal
		 * by invocation of <code>commitRemove()</code>. The adapter may call
		 * that method synchronously or asynchronously. The latter case is appropriate
		 * if some transitions should be performed before the tooltip leaves.</p>
		 * 
		 * <p>If not overridden, the method will commit the removal right away.</p>
		 * 
		 * @param toolTip The tooltip.
		 */
		protected function onRemove(toolTip : DisplayObject) : void {
			// hook
			commitRemove();
		}

		/**
		 * Commits a removal.
		 * 
		 * <p>A custom adapter needs to invoke this method within the <code>onRemove()</code>
		 * hook in order to finalize a removal.</p>
		 * 
		 * <p>It is possible to apply remove transitions and call <code>commitRemove()</code>
		 * asynchronously after the transitions has been completed.</p>
		 */
		protected function commitRemove() : void {
			if (!_layer.parent) return; // already removed
			
			_layer.parent.removeChild(_layer);
			_source = null;
			reset();
		}

		/**
		 * Starts the auto hide timer.
		 * 
		 * <p>Since the adapter does not know at which time the auto hide timer
		 * should start (e.g. in case of show tweens where auto hiding should not
		 * start before the tip is shown), this must be triggered explicitly.</p>
		 */
		protected function startAutoHide() : void {
			if (_autoHideAfter) {
				clearTimeout(_hideDelay);
				_hideDelay = setTimeout(onRemove, _autoHideAfter, _layer);
			}
		}

	}
}
