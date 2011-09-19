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

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.framework.ILayoutItem;
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace as3commons_ui;

	/**
	 * Abstact layout item implementation.
	 * 
	 * @author Jens Struwe 15.03.2011
	 */
	public class AbstractLayoutItem implements ILayoutItem {
		
		/**
		 * Constant to describe that an object should be neither shown nor hidden in the next layout procedure.
		 */
		protected const FALSE : String = "false";

		/**
		 * Constant to describe that an object should be hidden in the next layout procedure.
		 */
		protected const HIDE : String = "hide";

		/**
		 * Constant to describe that an object should be shown in the next layout procedure.
		 */
		protected const SHOW : String = "show";
		
		/**
		 * The id.
		 */
		private var _id : String;

		/**
		 * Horizontal margin.
		 */
		protected var _marginX : int;

		/**
		 * Vertical margin.
		 */
		protected var _marginY : int;

		/**
		 * Horizontal offset.
		 */
		protected var _offsetX : int;

		/**
		 * Vertical offset.
		 */
		protected var _offsetY : int;

		/**
		 * Horizontal align.
		 */
		protected var _hAlign : String = Align.LEFT;

		/**
		 * Vertical align.
		 */
		protected var _vAlign : String = Align.TOP;

		/**
		 * Custom render callback.
		 */
		protected var _renderCallback : Function;

		/**
		 * Custom hide callback.
		 */
		protected var _hideCallback : Function;

		/**
		 * Custom show callback.
		 */
		protected var _showCallback : Function;
		
		/**
		 * <code>true</code> if the layout item is not excluded from its parent layout.
		 */
		protected var _inLayout : Boolean = true;

		/**
		 * Flag to indicate if the item should be shown or hidden in the next layout procedure.
		 */
		protected var _showOrHide : String = FALSE;
		
		/**
		 * The layout item cell.
		 */
		protected var _cell : ICell;
		
		/**
		 * Origin.
		 * 
		 * <p>Valid only right after a layouting procedure.</p>
		 */
		protected var _position : Point;
		
		/**
		 * The content rect.
		 * 
		 * <p>Valid only right after a layouting procedure.</p>
		 */
		protected var _contentRect : Rectangle;
		
		/**
		 * The content rect.
		 * 
		 * <p>Valid only right after a layouting procedure.</p>
		 */
		protected var _visibleRect : Rectangle;

		public function AbstractLayoutItem() {
			_position = new Point();
			_contentRect = new Rectangle();
			_visibleRect = new Rectangle();
		}
		
		/*
		 * ILayoutItem
		 */
		
		// Config - ID
		
		/**
		 * @inheritDoc
		 */
		public function set id(id : String) : void {
			_id = id;
		}

		/**
		 * @inheritDoc
		 */
		public function get id() : String {
			return _id;
		}

		// Config - Margin, Offset
		
		/**
		 * @inheritDoc
		 */
		public function set marginX(marginX : int) : void {
			_marginX = marginX;
		}

		/**
		 * @inheritDoc
		 */
		public function get marginX() : int {
			return _marginX;
		}

		/**
		 * @inheritDoc
		 */
		public function set marginY(marginY : int) : void {
			_marginY = marginY;
		}

		/**
		 * @inheritDoc
		 */
		public function get marginY() : int {
			return _marginY;
		}

		/**
		 * @inheritDoc
		 */
		public function set offsetX(offsetX : int) : void {
			_offsetX = offsetX;
		}

		/**
		 * @inheritDoc
		 */
		public function get offsetX() : int {
			return _offsetX;
		}

		/**
		 * @inheritDoc
		 */
		public function set offsetY(offsetY : int) : void {
			_offsetY = offsetY;
		}

		/**
		 * @inheritDoc
		 */
		public function get offsetY() : int {
			return _offsetY;
		}

		// Config - Align
		
		/**
		 * @inheritDoc
		 */
		public function set hAlign(hAlign : String) : void {
			_hAlign = hAlign;
		}

		/**
		 * @inheritDoc
		 */
		public function get hAlign() : String {
			return _hAlign;
		}

		/**
		 * @inheritDoc
		 */
		public function set vAlign(vAlign : String) : void {
			_vAlign = vAlign;
		}

		/**
		 * @inheritDoc
		 */
		public function get vAlign() : String {
			return _vAlign;
		}
		
		// Config - Include, Exclude

		/**
		 * @inheritDoc
		 */
		public function get inLayout() : Boolean {
			return _inLayout;
		}

		/**
		 * @inheritDoc
		 */
		public function excludeFromLayout(hide : Boolean = true) : void {
			if (!_inLayout) return;
			_inLayout = false;
			if (hide) _showOrHide = HIDE;
		}

		/**
		 * @inheritDoc
		 */
		public function includeInLayout(show : Boolean = true) : void {
			if (_inLayout) return;
			_inLayout = true;
			if (show) _showOrHide = SHOW;
		}
		
		// Layout

		/**
		 * @inheritDoc
		 */
		public function set renderCallback(renderCallback : Function) : void {
			_renderCallback = renderCallback;
		}

		/**
		 * @inheritDoc
		 */
		public function get renderCallback() : Function {
			return _renderCallback;
		}

		/**
		 * @inheritDoc
		 */
		public function set hideCallback(excludeCallback : Function) : void {
			_hideCallback = excludeCallback;
		}

		/**
		 * @inheritDoc
		 */
		public function get hideCallback() : Function {
			return _hideCallback;
		}

		/**
		 * @inheritDoc
		 */
		public function set showCallback(showCallback : Function) : void {
			_showCallback = showCallback;
		}

		/**
		 * @inheritDoc
		 */
		public function get showCallback() : Function {
			return _showCallback;
		}

		// Info Data

		/**
		 * @inheritDoc
		 */
		public function get position() : Point {
			return _position;
		}

		/**
		 * @inheritDoc
		 */
		public function get contentRect() : Rectangle {
			return _contentRect;
		}

		/**
		 * @inheritDoc
		 */
		public function get visibleRect() : Rectangle {
			return _visibleRect;
		}

		/*
		 * Info
		 */
		
		/**
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
		
		/**
		 * Parses the layout item.
		 * 
		 * @param renderConfig The render config.
		 */
		internal function parse(renderConfig : RenderConfig) : void {
			parseLayoutItem(renderConfig);
			_showOrHide = FALSE;
		}
		
		/**
		 * Excludes the layout item.
		 * 
		 * @param renderConfig The render config.
		 */
		internal function exclude(renderConfig : RenderConfig) : void {
			excludeLayoutItem(renderConfig);
			_showOrHide = FALSE;
		}
		
		/**
		 * Creates or clones a render config.
		 * 
		 * @param renderConfig The render config.
		 * @return A new or cloned render config.
		 */
		internal function createRenderConfig(parentRenderConfig : RenderConfig = null) : RenderConfig {
			var renderConfig : RenderConfig = parentRenderConfig ? parentRenderConfig.clone() : new RenderConfig();
			if (_showOrHide == SHOW) renderConfig.show = true;
			if (_showOrHide == HIDE) renderConfig.hide = true;
			if (_renderCallback != null) renderConfig.renderCallback = _renderCallback;
			if (_hideCallback != null) renderConfig.hideCallback = _hideCallback;
			if (_showCallback != null) renderConfig.showCallback = _showCallback;
			return renderConfig;
		}
		
		/**
		 * The cell of the layout item.
		 */
		internal function get cell() : ICell {
			return _cell;
		}
		
		/*
		 * as3commons_ui
		 */

		/**
		 * Updates all geometry data.
		 */
		as3commons_ui function notifyRenderFinished() : void {
			if (!_cell) return;
			
			_position = _cell.position;
			_contentRect = _cell.contentRect;
			_visibleRect = _cell.visibleRect;
			
			_cell = null;
		}

		/*
		 * Protected
		 */
		
		/**
		 * Performs operations to exclude the layout item.
		 * 
		 * @param renderConfig The render config.
		 */
		protected function excludeLayoutItem(renderConfig : RenderConfig) : void {
			// template method
		}

		/**
		 * Parses the layout item.
		 * 
		 * @param renderConfig The render config.
		 */
		protected function parseLayoutItem(renderConfig : RenderConfig) : void {
			// template method
		}

	}
}
