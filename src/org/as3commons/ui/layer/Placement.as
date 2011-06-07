package org.as3commons.ui.layer {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.placement.PlacementUtils;
	import org.as3commons.ui.layer.placement.UsedPlacement;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class Placement {
		
		private var _source : DisplayObject;
		private var _sourceAnchor : uint = PlacementAnchor.TOP_LEFT;
		private var _layer : DisplayObject;
		private var _layerAnchor : uint = PlacementAnchor.TOP_LEFT;

		private var _offset : Point;
		private var _bounds : Rectangle;
		private var _placeCallback : Function;
		private var _autoSwapAnchorsH : Boolean;
		private var _autoSwapAnchorsV : Boolean;
		private var _autoSwapAnchorsHDiff : uint;
		private var _autoSwapAnchorsVDiff : uint;

		private var _layerGlobal : Point;
		private var _layerLocal : Point;
		private var _usedPlacement : UsedPlacement;

		public function Placement(source : DisplayObject = null, layer : DisplayObject = null) {
			_source = source;
			_layer = layer;
			
			_offset = new Point();
		}
		
		public function set source(source : DisplayObject) : void {
			_source = source;
		}

		public function get source() : DisplayObject {
			return _source;
		}

		public function set layer(layer : DisplayObject) : void {
			_layer = layer;
		}

		public function get layer() : DisplayObject {
			return _layer;
		}

		public function set sourceAnchor(sourceAnchor : uint) : void {
			_sourceAnchor = sourceAnchor;
		}

		public function get sourceAnchor() : uint {
			return _sourceAnchor;
		}

		public function set layerAnchor(layerAnchor : uint) : void {
			_layerAnchor = layerAnchor;
		}
		
		public function get layerAnchor() : uint {
			return _layerAnchor;
		}

		public function set offset(offset : Point) : void {
			_offset = offset;
		}
		
		public function get offset() : Point {
			return _offset;
		}

		public function set bounds(bounds : Rectangle) : void {
			_bounds = bounds;
		}

		public function get bounds() : Rectangle {
			return _bounds;
		}

		public function set placeCallback(placeCallback : Function) : void {
			_placeCallback = placeCallback;
		}
		
		public function set autoSwapAnchorsH(autoSwap : Boolean) : void {
			_autoSwapAnchorsH = autoSwap;
		}

		public function get autoSwapAnchorsH() : Boolean {
			return _autoSwapAnchorsH;
		}

		public function set autoSwapAnchorsHDiff(diff : uint) : void {
			_autoSwapAnchorsHDiff = diff;
		}

		public function get autoSwapAnchorsHDiff() : uint {
			return _autoSwapAnchorsHDiff;
		}

		public function set autoSwapAnchorsV(autoSwap : Boolean) : void {
			_autoSwapAnchorsV = autoSwap;
		}

		public function get autoSwapAnchorsV() : Boolean {
			return _autoSwapAnchorsV;
		}

		public function set autoSwapAnchorsVDiff(diff : uint) : void {
			_autoSwapAnchorsVDiff = diff;
		}

		public function get autoSwapAnchorsVDiff() : uint {
			return _autoSwapAnchorsVDiff;
		}

		public function place(moveLayer : Boolean = true) : void {
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
						}
						layerLocal = getLayerLocal(sourceAnchor, layerAnchor, offset);
					// left overlap
					} else if (layerLocal.x + _autoSwapAnchorsHDiff < _bounds.left) {
						if (PlacementAnchor.isLeft(sourceAnchor) && PlacementAnchor.isRight(layerAnchor)) {
							sourceAnchor = swapHorizontal(sourceAnchor);
							layerAnchor = swapHorizontal(layerAnchor);
							offset.x = - offset.x;
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
						}
						layerLocal = getLayerLocal(sourceAnchor, layerAnchor, offset);
					// top overlap
					} else if (layerLocal.y + _autoSwapAnchorsVDiff < _bounds.top) {
						if (PlacementAnchor.isTop(sourceAnchor) && PlacementAnchor.isBottom(layerAnchor)) {
							sourceAnchor = swapVertical(sourceAnchor);
							layerAnchor = swapVertical(layerAnchor);
							offset.y = - offset.y;
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
			if (_placeCallback != null) {
				_placeCallback(_layer, _layerLocal);

			} else if (moveLayer) {
				_layer.x = _layerLocal.x;
				_layer.y = _layerLocal.y;
			}
		}

		public function get layerGlobal() : Point {
			return _layerGlobal;
		}

		public function get layerLocal() : Point {
			return _layerLocal;
		}

		public function get usedPlacement() : UsedPlacement {
			return _usedPlacement;
		}

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
		
		private function getLayerLocal(sourceAnchor : uint, layerAnchor : uint, offset : Point) : Point {
			return PlacementUtils.globalToLocal(getLayerGlobal(sourceAnchor, layerAnchor, offset), _layer);
		}
		
		private function swapHorizontal(anchor : uint) : uint {
			var diff : int = PlacementAnchor.as3commons_ui::POSITION_LEFT - PlacementAnchor.as3commons_ui::POSITION_RIGHT;
			if (PlacementAnchor.isLeft(anchor)) diff *= -1;
			anchor += diff;
			return anchor;
		}

		private function swapVertical(anchor : uint) : uint {
			var diff : int = PlacementAnchor.as3commons_ui::POSITION_TOP - PlacementAnchor.as3commons_ui::POSITION_BOTTOM;
			if (PlacementAnchor.isTop(anchor)) diff *= -1;
			anchor += diff;
			return anchor;
		}

	}
}
