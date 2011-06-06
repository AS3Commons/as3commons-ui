package org.as3commons.ui.layer {

	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.placement.PlacementUtils;

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
		private var _layerGlobal : Point;
		private var _layerLocal : Point;

		private var _offset : Point;
		private var _bounds : Rectangle;
		
		private var _placeCallback : Function;

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

		public function place(moveLayer : Boolean = true) : void {
			// layer global
			_layerGlobal = PlacementUtils.localToGlobal(_source);

			var sourceAnchorLocal : Point = PlacementUtils.anchorToLocal(_sourceAnchor, _source);
			_layerGlobal.x += sourceAnchorLocal.x;
			_layerGlobal.y += sourceAnchorLocal.y;
			
			var layerAnchorLocal : Point = PlacementUtils.anchorToLocal(_layerAnchor, _layer);
			_layerGlobal.x -= layerAnchorLocal.x;
			_layerGlobal.y -= layerAnchorLocal.y;
			
			// offset
			if (_offset) {
				_layerGlobal.x += _offset.x; 
				_layerGlobal.y += _offset.y; 
			}
			
			if (_bounds) {
				// right
				_layerGlobal.x = Math.min(_layerGlobal.x, _bounds.right - _layer.width);
				// bottom
				_layerGlobal.y = Math.min(_layerGlobal.y, _bounds.bottom - _layer.height);
				// top
				_layerGlobal.y = Math.max(_layerGlobal.y, _bounds.y);
				// left
				_layerGlobal.x = Math.max(_layerGlobal.x, _bounds.x);
			}
			
			// layer local
			_layerLocal = PlacementUtils.globalToLocal(_layerGlobal, _layer);
			
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

	}
}
