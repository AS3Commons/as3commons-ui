/**
 * Copyright 2011 The original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.ui.layout.framework.core {

	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.framework.ILayoutItem;
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Jens Struwe 15.03.2011
	 */
	public class AbstractLayoutItem implements ILayoutItem {
		
		protected const FALSE : String = "false";
		protected const HIDE : String = "hide";
		protected const SHOW : String = "show";
		
		private var _id : String;
		protected var _marginX : int;
		protected var _marginY : int;
		protected var _offsetX : int;
		protected var _offsetY : int;
		protected var _hAlign : String = Align.LEFT;
		protected var _vAlign : String = Align.TOP;
		protected var _renderCallback : Function;
		protected var _hideCallback : Function;
		protected var _showCallback : Function;
		
		protected var _inLayout : Boolean = true;
		protected var _showOrHide : String = FALSE;
		
		protected var _cell : ICell;
		
		/*
		 * ILayoutItem
		 */
		
		// Config - ID
		
		public function set id(id : String) : void {
			_id = id;
		}

		public function get id() : String {
			return _id;
		}

		// Config - Margin, Offset
		
		public function set marginX(marginX : int) : void {
			_marginX = marginX;
		}

		public function get marginX() : int {
			return _marginX;
		}

		public function set marginY(marginY : int) : void {
			_marginY = marginY;
		}

		public function get marginY() : int {
			return _marginY;
		}

		public function set offsetX(offsetX : int) : void {
			_offsetX = offsetX;
		}

		public function get offsetX() : int {
			return _offsetX;
		}

		public function set offsetY(offsetY : int) : void {
			_offsetY = offsetY;
		}

		public function get offsetY() : int {
			return _offsetY;
		}

		// Config - Align
		
		public function set hAlign(hAlign : String) : void {
			_hAlign = hAlign;
		}

		public function get hAlign() : String {
			return _hAlign;
		}

		public function set vAlign(vAlign : String) : void {
			_vAlign = vAlign;
		}

		public function get vAlign() : String {
			return _vAlign;
		}
		
		// Config - Include, Exclude

		public function get inLayout() : Boolean {
			return _inLayout;
		}

		public function excludeFromLayout(hide : Boolean = true) : void {
			if (!_inLayout) return;
			_inLayout = false;
			if (hide) _showOrHide = HIDE;
		}

		public function includeInLayout(show : Boolean = true) : void {
			if (_inLayout) return;
			_inLayout = true;
			if (show) _showOrHide = SHOW;
		}
		
		// Layout

		public function set renderCallback(renderCallback : Function) : void {
			_renderCallback = renderCallback;
		}

		public function get renderCallback() : Function {
			return _renderCallback;
		}

		public function set hideCallback(excludeCallback : Function) : void {
			_hideCallback = excludeCallback;
		}

		public function get hideCallback() : Function {
			return _hideCallback;
		}

		public function set showCallback(showCallback : Function) : void {
			_showCallback = showCallback;
		}

		public function get showCallback() : Function {
			return _showCallback;
		}

		// Info Data

		public function get position() : Point {
			return _cell ? _cell.position : new Point();
		}

		public function get contentRect() : Rectangle {
			return _cell && _cell.contentRect ? _cell.contentRect : new Rectangle();
		}

		public function get visibleRect() : Rectangle {
			return _cell && _cell.visibleRect ? _cell.visibleRect : new Rectangle();
		}

		/*
		 * Info
		 */
		
		public function toString() : String {
			return "" 
				+ (id ? " id:" + id + "," : "")
				+ " position:" + position
				+ ", content:" + contentRect
				+ ", visible:" + visibleRect
			;
		}

		/*
		 * Internal
		 */
		
		internal function parse(renderConfig : RenderConfig) : void {
			parseLayoutItem(renderConfig);
			_showOrHide = FALSE;
		}
		
		internal function exclude(renderConfig : RenderConfig) : void {
			excludeLayoutItem(renderConfig);
			_showOrHide = FALSE;
		}
		
		internal function createRenderConfig(parentRenderConfig : RenderConfig = null) : RenderConfig {
			var renderConfig : RenderConfig = parentRenderConfig ? parentRenderConfig.clone() : new RenderConfig();
			if (_showOrHide == SHOW) renderConfig.show = true;
			if (_showOrHide == HIDE) renderConfig.hide = true;
			if (_renderCallback != null) renderConfig.renderCallback = _renderCallback;
			if (_hideCallback != null) renderConfig.hideCallback = _hideCallback;
			if (_showCallback != null) renderConfig.showCallback = _showCallback;
			return renderConfig;
		}
		
		internal function get cell() : ICell {
			return _cell;
		}
		
		/*
		 * Protected
		 */
		
		protected function excludeLayoutItem(renderConfig : RenderConfig) : void {
			// template method
		}

		protected function parseLayoutItem(renderConfig : RenderConfig) : void {
			// template method
		}

	}
}
