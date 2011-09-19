package org.as3commons.ui.layout.testhelper {

	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.layout.Display;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.framework.ILayoutItem;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 19.09.2011
	 */
	public class LayoutValidator {
		
		public static function validateItems(expectedItems : Array, layout : ILayout) : Boolean {
			var result : Array = new Array();
			var i : uint;
			var iterator : IIterator = layout.iterator();
			while (iterator.hasNext()) {
				
				var item : ILayoutItem = iterator.next();
				
				if (expectedItems[i] is DisplayObject && item is Display) {
					result.push(Display(item).displayObject);
				} else {
					result.push(item);
				}
				
				i++;
			}
			
			if (!ArrayUtils.arraysEqual(expectedItems, result)) {
				trace ("ERROR validateItems");
				trace ("-- ", expectedItems);
				trace ("---", result);
			}
			return ArrayUtils.arraysEqual(expectedItems, result);
		}
		
		public static function validateItemsRecursively(expectedItems : Array, layout : ILayout) : Boolean {
			var result : Array = new Array();
			var i : uint;
			var iterator : IIterator = layout.recursiveIterator();
			while (iterator.hasNext()) {
				
				var item : ILayoutItem = iterator.next();
				
				if (expectedItems[i] is DisplayObject && item is Display) {
					result.push(Display(item).displayObject);

				} else {
					result.push(item);
				}
				
				i++;
			}
			
			if (!ArrayUtils.arraysEqual(expectedItems, result)) {
				trace ("ERROR validateItemsRecursively");
				trace ("-- ", expectedItems);
				trace ("---", result);
			}
			
			return ArrayUtils.arraysEqual(expectedItems, result);
		}
		
	}
}
