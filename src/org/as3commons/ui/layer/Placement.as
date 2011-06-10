package org.as3commons.ui.layer {

	import org.as3commons.ui.layer.placement.AbstractPlacement;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Layer placement util class.
	 * 
	 * <p>Util that allows you to relate the position of display objects living
	 * in different branched of the display list.</p>
	 * 
	 * <p>The placement class places a layer object beside a source object in respect
	 * to the specified anchors and optional further conditions.</p>
	 * 
	 * @author Jens Struwe 06.06.2011
	 */
	public class Placement extends AbstractPlacement {
		
		/**
		 * Placement constructor.
		 * 
		 * @param source The fix object.
		 * @param layer The object to place.
		 */
		public function Placement(source : DisplayObject = null, layer : DisplayObject = null) {
			_source = source;
			_layer = layer;
		}
		
		/**
		 * The fix object.
		 */
		public function set source(source : DisplayObject) : void {
			_source = source;
		}

		/**
		 * @private
		 */
		public function get source() : DisplayObject {
			return _source;
		}

		/**
		 * The object to place.
		 */
		public function set layer(layer : DisplayObject) : void {
			_layer = layer;
		}

		/**
		 * @private
		 */
		public function get layer() : DisplayObject {
			return _layer;
		}

		/**
		 * Placement anchor of the fix object.
		 */
		public function set sourceAnchor(sourceAnchor : uint) : void {
			_sourceAnchor = sourceAnchor;
		}

		/**
		 * @private
		 */
		public function get sourceAnchor() : uint {
			return _sourceAnchor;
		}

		/**
		 * Placement anchor of the object to place.
		 */
		public function set layerAnchor(layerAnchor : uint) : void {
			_layerAnchor = layerAnchor;
		}
		
		/**
		 * @private
		 */
		public function get layerAnchor() : uint {
			return _layerAnchor;
		}

		/**
		 * Calculates the position of the item to place (layer).
		 * 
		 * <p>If a <code>placeCallback</code> has been specified, this callback will
		 * be executed at the end of this method.</p>
		 * 
		 * <p>Else if <code>moveLayer</code> is set to <code>true</code>, the layer's
		 * position will be set automatically at the end of this method.</p>
		 */
		public function place(moveLayer : Boolean = true) : void {
			calculatePosition(moveLayer);
		}

		/**
		 * The calculated global position of the layer.
		 * 
		 * <p>Available after <code>place()</code> has been executed.</p>
		 */
		public function get layerGlobal() : Point {
			return _layerGlobal;
		}

		/**
		 * The calculated local position of the layer.
		 * 
		 * <p>Available after <code>place()</code> has been executed.</p>
		 */
		public function get layerLocal() : Point {
			return _layerLocal;
		}

	}
}
