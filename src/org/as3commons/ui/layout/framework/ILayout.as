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

	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.ui.layout.CellConfig;

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface ILayout extends ILayoutItem, IIterable {

		/*
		 * Config - Cell
		 */

		function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void;

		function getCellConfig(hIndex : int = -1, vIndex : int = -1) : CellConfig;

		/*
		 * Config - Min Size
		 */

		function set minWidth(minWidth : uint) : void;
		
		function get minWidth() : uint;
		
		function set minHeight(minHeight : uint) : void;
		
		function get minHeight() : uint;

		/*
		 * Add, Get, Remove
		 */
		
		function add(...args) : void;
		
		function addAll(container : Sprite) : void;
		
		function getLayoutItem(...args) : ILayoutItem;
		
		function recursiveIterator() : IRecursiveIterator;
		
		function remove(key : *) : void;

		function get numItems() : uint;

		/*
		 * Layout
		 */

		function layout(container : Sprite, relayout : Boolean = false) : void;

	}
}
