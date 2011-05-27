package org.as3commons.ui.lifecycle.lifecycle.core {

	import flash.display.DisplayObject;
	import org.as3commons.ui.lifecycle.i10n.II10NSelector;


	/**
	 * @author Jens Struwe 26.05.2011
	 */
	public class I10NSelector implements II10NSelector {

		private var _registry : LifeCycleRegistry;

		public function I10NSelector(registry : LifeCycleRegistry) {
			_registry = registry;
		}

		public function approve(displayObject : DisplayObject) : Boolean {
			return _registry.componentRegistered(displayObject);
		}
	}
}
