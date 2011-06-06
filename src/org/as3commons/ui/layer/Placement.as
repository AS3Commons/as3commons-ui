package org.as3commons.ui.layer {

	import org.as3commons.ui.layer.placement.PlacementRules;
	import org.as3commons.ui.utils.UIUtils;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Jens Struwe 06.06.2011
	 */
	public class Placement {
		
		private var _source : DisplayObject;
		private var _sourceAnchor : uint;

		private var _layer : DisplayObject;
		private var _layerAnchor : uint;
		private var _layerGlobal : Point;
		private var _layerLocal : Point;
		
		public function set source(source : DisplayObject) : void {
			_source = source;
		}

		public function set layer(layer : DisplayObject) : void {
			_layer = layer;
		}

		public function set sourceAnchor(sourceAnchor : uint) : void {
			_sourceAnchor = sourceAnchor;
		}

		public function set layerAnchor(layerAnchor : uint) : void {
			_layerAnchor = layerAnchor;
		}
		
		public function place() : void {
			var sourceGlobal : Point = UIUtils.localToGlobal(_source);
			_layerGlobal = new Point();
			
			/*
			 * layer x
			 */

			if (PlacementRules.isLeft(_sourceAnchor)) {
				_layerGlobal.x = sourceGlobal.x;
			} else if (PlacementRules.isCenter(_sourceAnchor)) {
				_layerGlobal.x = sourceGlobal.x + Math.round(_source.width / 2);
			} else {
				_layerGlobal.x = sourceGlobal.x + _source.width;
			}
			
			if (PlacementRules.isLeft(_layerAnchor)) {
				// keep source origin
			} else if (PlacementRules.isCenter(_layerAnchor)) {
				_layerGlobal.x -= Math.round(_layer.width / 2);
			} else {
				_layerGlobal.x -= _layer.width;
			}
			
			/*
			 * layer y
			 */
			
			if (PlacementRules.isTop(_sourceAnchor)) {
				_layerGlobal.y = sourceGlobal.y;
			} else if (PlacementRules.isMiddle(_sourceAnchor)) {
				_layerGlobal.y = sourceGlobal.y + Math.round(_source.height / 2);
			} else {
				_layerGlobal.y = sourceGlobal.y + _source.height;
			}
			
			if (PlacementRules.isTop(_layerAnchor)) {
				// keep source origin
			} else if (PlacementRules.isMiddle(_layerAnchor)) {
				_layerGlobal.y -= Math.round(_layer.height / 2);
			} else {
				_layerGlobal.y -= _layer.height;
			}
			
			_layerLocal = UIUtils.globalToLocal(_layerGlobal, _layer);
		}

		public function get layerGlobal() : Point {
			return _layerGlobal;
		}

		public function get layerLocal() : Point {
			return _layerLocal;
		}

		public function get sourceAnchor() : uint {
			return _sourceAnchor;
		}

		public function get layerAnchor() : uint {
			return _layerAnchor;
		}
		
	}
}
