package org.as3commons.ui.layer {

	import org.as3commons.ui.layer.placement.AbstractPlacement;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class Placement extends AbstractPlacement {
		
		public function Placement(source : DisplayObject = null, layer : DisplayObject = null) {
			_source = source;
			_layer = layer;
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

		public function set placeCallback(placeCallback : Function) : void {
			_placeCallback = placeCallback;
		}
		
		public function get placeCallback() : Function {
			return _placeCallback;
		}
		
		public function place(moveLayer : Boolean = true) : void {
			calculatePosition(moveLayer);
		}

		public function get layerGlobal() : Point {
			return _layerGlobal;
		}

		public function get layerLocal() : Point {
			return _layerLocal;
		}

	}
}
