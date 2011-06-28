package org.as3commons.ui.layer.placement {

	import org.as3commons.ui.framework.core.as3commons_ui;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Placement abstract base class.
	 * 
	 * @author Jens Struwe 08.06.2011
	 */
	public class AbstractPlacement {

		/**
		 * The fix object.
		 */
		protected var _source : DisplayObject;

		/**
		 * Placement anchor of the fix object.
		 */
		protected var _sourceAnchor : uint = PlacementAnchor.TOP_LEFT;

		/**
		 * The object to place.
		 */
		protected var _layer : DisplayObject;

		/**
		 * Placement anchor of the object to place.
		 */
		protected var _layerAnchor : uint = PlacementAnchor.TOP_LEFT;

		/**
		 * Placement offset.
		 */
		protected var _offset : Point;

		/**
		 * Placement bounds.
		 */
		protected var _bounds : Rectangle;

		/**
		 * Horizontal anchor swap on bounds flag.
		 */
		protected var _autoSwapAnchorsH : Boolean;

		/**
		 * Vertical anchor swap on bounds flag.
		 */
		protected var _autoSwapAnchorsV : Boolean;

		/**
		 * Horizontal anchor swap tolerance.
		 */
		protected var _autoSwapAnchorsHDiff : uint;

		/**
		 * Vertical anchor swap tolerance.
		 */
		protected var _autoSwapAnchorsVDiff : uint;

		/**
		 * The calculated global position of the layer.
		 */
		protected var _layerGlobal : Point;

		/**
		 * The calculated local position of the layer.
		 */
		protected var _layerLocal : Point;

		/**
		 * Used placement values object.
		 */
		protected var _usedPlacement : UsedPlacement;

		/**
		 * AbstractPlacement constructor.
		 */
		public function AbstractPlacement() {
			_offset = new Point();
		}
		
		/**
		 * Placement offset.
		 * 
		 * <p>The layer's position will be first calculated and then
		 * modified by this offset.</p>
		 */
		public function set offset(offset : Point) : void {
			_offset = offset;
		}
		
		/**
		 * @private
		 */
		public function get offset() : Point {
			return _offset;
		}

		/**
		 * Placement bounds.
		 * 
		 * <p>If specified the layer will be auto corrected to stay within the bounds.</p>
		 * 
		 * <p>If auto swap anchors on bounds is enabled, the class will swap the anchors
		 * of source and layer to keep the layer within the bounds.</p>
		 */
		public function set bounds(bounds : Rectangle) : void {
			_bounds = bounds;
		}

		/**
		 * @private
		 */
		public function get bounds() : Rectangle {
			return _bounds;
		}

		/**
		 * Horizontal anchor swap on bounds flag.
		 * 
		 * <p>If bounds are specified and this property is set to <code>true</code>
		 * the class will swap the horizontal anchors of source and layer in the
		 * case the layer will exceed the specified bounds at left or right.</p>
		 * 
		 * <p><strong>Limitations</strong></p>
		 * 
		 * <p>Swapping is only performed under the following conditions:</p>
		 * 
		 * <ul>
		 * <li>Layer overlaps right and source anchor is right and layer anchor is left.</li>
		 * <li>Layer overlaps left and source anchor is left and layer anchor is right.</li>
		 * </ul>
		 */
		public function set autoSwapAnchorsH(autoSwap : Boolean) : void {
			_autoSwapAnchorsH = autoSwap;
		}

		/**
		 * @private
		 */
		public function get autoSwapAnchorsH() : Boolean {
			return _autoSwapAnchorsH;
		}

		/**
		 * Horizontal anchor swap tolerance.
		 * 
		 * <p>If horizontal auto swapping is enabled, this property defines
		 * a tolerance shift before swapping is performed. If the layer is
		 * placed out of bounds but still within this tolerance it will be
		 * auto corrected to the position of the bounds. If the layer is
		 * placed out of this tolerance value, anchors will be swapped.</p>
		 */
		public function set autoSwapAnchorsHDiff(diff : uint) : void {
			_autoSwapAnchorsHDiff = diff;
		}

		/**
		 * @private
		 */
		public function get autoSwapAnchorsHDiff() : uint {
			return _autoSwapAnchorsHDiff;
		}

		/**
		 * Vertical anchor swap on bounds flag.
		 * 
		 * <p>If bounds are specified and this property is set to <code>true</code>
		 * the class will swap the vertical anchors of source and layer in the
		 * case the layer will exceed the specified bounds at top or bottom.</p>
		 * 
		 * <p><strong>Limitations</strong></p>
		 * 
		 * <p>Swapping is only performed under the following conditions:</p>
		 * 
		 * <ul>
		 * <li>Layer overlaps bottom and source anchor is bottom and layer anchor is top.</li>
		 * <li>Layer overlaps top and source anchor is top and layer anchor is bottom.</li>
		 * </ul>
		 */
		public function set autoSwapAnchorsV(autoSwap : Boolean) : void {
			_autoSwapAnchorsV = autoSwap;
		}

		/**
		 * @private
		 */
		public function get autoSwapAnchorsV() : Boolean {
			return _autoSwapAnchorsV;
		}

		/**
		 * Vertical anchor swap tolerance.
		 * 
		 * <p>If vertical auto swapping is enabled, this property defines
		 * a tolerance shift before swapping is performed. If the layer is
		 * placed out of bounds but still within this tolerance it will be
		 * auto corrected to the position of the bounds. If the layer is
		 * placed out of this tolerance value, anchors will be swapped.</p>
		 */
		public function set autoSwapAnchorsVDiff(diff : uint) : void {
			_autoSwapAnchorsVDiff = diff;
		}

		/**
		 * @private
		 */
		public function get autoSwapAnchorsVDiff() : uint {
			return _autoSwapAnchorsVDiff;
		}

		/**
		 * Used placement values object.
		 * 
		 * <p>The object contains information about used anchors and shifts.</p>
		 * 
		 * <p>A used anchor may differ from the specified in case of auto
		 * anchor swappings.</p>
		 * 
		 * <p>A shift is the difference between the actual layer position regarding
		 * the used bounds and the actual calculated position.</p>
		 */
		public function get usedPlacement() : UsedPlacement {
			return _usedPlacement;
		}

		/*
		 * Protected
		 */
		
		/**
		 * Calculates the layer position.
		 * 
		 * @param moveLayer Flag to indicate if the layer should be moved to its new position by this method.
		 */
		protected function calculatePosition(moveLayer : Boolean = true) : void {
			var sourceAnchor : uint = _sourceAnchor;
			var layerAnchor : uint = _layerAnchor;
			var offset : Point = _offset.clone();
			var layerLocal : Point = getLayerLocal(sourceAnchor, layerAnchor, offset);
			_usedPlacement = new UsedPlacement();

			if (_bounds) {
				if (_autoSwapAnchorsH) {
					// right overlap
					if (layerLocal.x + _layer.width - _autoSwapAnchorsHDiff > _bounds.right) {
						if (PlacementAnchor.isRight(sourceAnchor) && PlacementAnchor.isLeft(layerAnchor)) {
							sourceAnchor = swapHorizontal(sourceAnchor);
							layerAnchor = swapHorizontal(layerAnchor);
							offset.x = - offset.x;
							_usedPlacement.hSwapped = true;
						}
						layerLocal = getLayerLocal(sourceAnchor, layerAnchor, offset);
					// left overlap
					} else if (layerLocal.x + _autoSwapAnchorsHDiff < _bounds.left) {
						if (PlacementAnchor.isLeft(sourceAnchor) && PlacementAnchor.isRight(layerAnchor)) {
							sourceAnchor = swapHorizontal(sourceAnchor);
							layerAnchor = swapHorizontal(layerAnchor);
							offset.x = - offset.x;
							_usedPlacement.hSwapped = true;
						}
						layerLocal = getLayerLocal(sourceAnchor, layerAnchor, offset);
					}
				}
					
				if (_autoSwapAnchorsV) {
					// bottom overlap
					if (layerLocal.y + _layer.height - _autoSwapAnchorsVDiff > _bounds.bottom) {
						if (PlacementAnchor.isBottom(sourceAnchor) && PlacementAnchor.isTop(layerAnchor)) {
							sourceAnchor = swapVertical(sourceAnchor);
							layerAnchor = swapVertical(layerAnchor);
							offset.y = - offset.y;
							_usedPlacement.vSwapped = true;
						}
						layerLocal = getLayerLocal(sourceAnchor, layerAnchor, offset);
					// top overlap
					} else if (layerLocal.y + _autoSwapAnchorsVDiff < _bounds.top) {
						if (PlacementAnchor.isTop(sourceAnchor) && PlacementAnchor.isBottom(layerAnchor)) {
							sourceAnchor = swapVertical(sourceAnchor);
							layerAnchor = swapVertical(layerAnchor);
							offset.y = - offset.y;
							_usedPlacement.vSwapped = true;
						}
						layerLocal = getLayerLocal(sourceAnchor, layerAnchor, offset);
					}
				}

				// used placement diff init
				_usedPlacement.hShift = -layerLocal.x;
				_usedPlacement.vShift = -layerLocal.y;
			
				// right
				layerLocal.x = Math.min(layerLocal.x, _bounds.right - _layer.width);
				// bottom
				layerLocal.y = Math.min(layerLocal.y, _bounds.bottom - _layer.height);
				// top
				layerLocal.y = Math.max(layerLocal.y, _bounds.y);
				// left
				layerLocal.x = Math.max(layerLocal.x, _bounds.x);

				// used placement diff update
				_usedPlacement.hShift += layerLocal.x;
				_usedPlacement.vShift += layerLocal.y;
			}
			
			_layerLocal = layerLocal;
			_layerGlobal = PlacementUtils.localToGlobal(_layer, _layerLocal);
			
			// update used placement
			_usedPlacement.sourceAnchor = sourceAnchor;
			_usedPlacement.layerAnchor = layerAnchor;
			
			// move layer
			if (moveLayer) {
				_layer.x = _layerLocal.x;
				_layer.y = _layerLocal.y;
			}
		}
		
		/**
		 * Resets all calculated placement values.
		 */
		protected function reset() : void {
			_layerGlobal = null;
			_layerLocal = null;
			_usedPlacement = null;
		}

		/**
		 * Calculates the uncorrected global layer position.
		 */
		private function getLayerGlobal(sourceAnchor : uint, layerAnchor : uint, offset : Point) : Point {
			var layerGlobal : Point = PlacementUtils.localToGlobal(_source);

			var sourceAnchorLocal : Point = PlacementUtils.anchorToLocal(sourceAnchor, _source);
			layerGlobal.x += sourceAnchorLocal.x;
			layerGlobal.y += sourceAnchorLocal.y;
			
			var layerAnchorLocal : Point = PlacementUtils.anchorToLocal(layerAnchor, _layer);
			layerGlobal.x -= layerAnchorLocal.x;
			layerGlobal.y -= layerAnchorLocal.y;
			
			if (_offset) {
				layerGlobal.x += offset.x; 
				layerGlobal.y += offset.y; 
			}
			
			return layerGlobal;
		}
		
		/**
		 * Calculates the uncorrected local layer position.
		 */
		private function getLayerLocal(sourceAnchor : uint, layerAnchor : uint, offset : Point) : Point {
			return PlacementUtils.globalToLocal(getLayerGlobal(sourceAnchor, layerAnchor, offset), _layer);
		}
		
		/**
		 * Swaps anchors horizontally.
		 */
		private function swapHorizontal(anchor : uint) : uint {
			var diff : int = PlacementAnchor.as3commons_ui::POSITION_LEFT - PlacementAnchor.as3commons_ui::POSITION_RIGHT;
			if (PlacementAnchor.isLeft(anchor)) diff *= -1;
			anchor += diff;
			return anchor;
		}

		/**
		 * Swaps anchors vertically.
		 */
		private function swapVertical(anchor : uint) : uint {
			var diff : int = PlacementAnchor.as3commons_ui::POSITION_TOP - PlacementAnchor.as3commons_ui::POSITION_BOTTOM;
			if (PlacementAnchor.isTop(anchor)) diff *= -1;
			anchor += diff;
			return anchor;
		}

	}
}
