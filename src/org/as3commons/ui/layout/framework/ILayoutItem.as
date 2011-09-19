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
package org.as3commons.ui.layout.framework {

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Basic layout item definition.
	 * 
	 * @author Jens Struwe 21.03.2011
	 */
	public interface ILayoutItem {

		/*
		 * Config - ID
		 */
		
		/**
		 * The id of the layout item.
		 */
		function set id(id : String) : void;
		
		/**
		 * @private
		 */
		function get id() : String;

		/*
		 * Config - Margin, Offset
		 */
		
		/**
		 * Horizontal margin.
		 */
		function set marginX(marginX : int) : void;
		
		/**
		 * @private
		 */
		function get marginX() : int;
		
		/**
		 * Vertical margin.
		 */
		function set marginY(marginY : int) : void;
		
		/**
		 * @private
		 */
		function get marginY() : int;
		
		/**
		 * Horizontal offset.
		 */
		function set offsetX(offsetX : int) : void;
		
		/**
		 * @private
		 */
		function get offsetX() : int;
		
		/**
		 * Vertical offset.
		 */
		function set offsetY(offsetY : int) : void;
		
		/**
		 * @private
		 */
		function get offsetY() : int;
		
		/*
		 * Config - Align
		 */
		
		/**
		 * Horizontal align.
		 */
		function set hAlign(hAlign : String) : void;
		
		/**
		 * @private
		 */
		function get hAlign() : String;
		
		/**
		 * Vertical align.
		 */
		function set vAlign(vAlign : String) : void;
		
		/**
		 * @private
		 */
		function get vAlign() : String;
		
		/*
		 * Config - Include, Exclude
		 */

		/**
		 * <code>true</code> if the layout item is not excluded from its parent layout.
		 */
		function get inLayout() : Boolean;

		/**
		 * Excludes an item from being considered in a layout procedure.
		 * 
		 * <p>The method automatically hides the layout item if not else specified.</p>
		 * 
		 * @param hide Flag to indicate if the item should be hidden.
		 */
		function excludeFromLayout(hide : Boolean = true) : void;
		
		/**
		 * Includes an item again in a layout.
		 * 
		 * <p>The method automatically sets the layout item visible if not else specified.</p>
		 * 
		 * @param hide Flag to indicate if the item should be set to visible.
		 */
		function includeInLayout(show : Boolean = true) : void;
		
		/*
		 * Layout
		 */

		/**
		 * Sets a custom render callback.
		 * 
		 * <p>The callback is invoked whenever the item is being layouted.
		 * This can be only once for a particular layout procedure.</p>
		 */
		function set renderCallback(renderCallback : Function) : void;

		/**
		 * @private
		 */
		function get renderCallback() : Function;

		/**
		 * Sets a custom hide callback.
		 * 
		 * <p>The callback is invoked once during a layout procedure and only after
		 * it has been excluded from a layout.</p>
		 */
		function set hideCallback(hideCallback : Function) : void;

		/**
		 * @private
		 */
		function get hideCallback() : Function;

		/**
		 * Sets a custom show callback.
		 * 
		 * <p>The callback is invoked once during a layout procedure and only after
		 * it has been included again into a layout. This callback is triggered right
		 * before the <code>renderCallback</code>.</p>
		 */
		function set showCallback(showCallback : Function) : void;

		/**
		 * @private
		 */
		function get showCallback() : Function;

		/*
		 * Info Data
		 */

		/**
		 * The origin of the layout item.
		 * 
		 * <p>Valid only right after a layouting procedure.</p>
		 */
		function get position() : Point;

		/**
		 * The spacing rect of the layout item.
		 * 
		 * <p>Valid only right after a layouting procedure.</p>
		 */
		function get contentRect() : Rectangle;
		
		/**
		 * The rect of the visible content.
		 * 
		 * <p>Valid only right after a layouting procedure.</p>
		 */
		function get visibleRect() : Rectangle;

	}
}
