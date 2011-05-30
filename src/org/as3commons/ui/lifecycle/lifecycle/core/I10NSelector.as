package org.as3commons.ui.lifecycle.lifecycle.core {

	import org.as3commons.ui.lifecycle.i10n.II10NSelector;

	import flash.display.DisplayObject;

	/**
	 * <code>II10NSelector</code> implementation used by <code>LifeCycle</code>.
	 * 
	 * @author Jens Struwe 26.05.2011
	 */
	public class I10NSelector implements II10NSelector {

		/**
		 * Internal <code>LifeCycle</code> registry reference.
		 */
		private var _registry : LifeCycleRegistry;

		/**
		 * <code>I10NSelector</code> constructor.
		 */
		public function I10NSelector(registry : LifeCycleRegistry) {
			_registry = registry;
		}

		/**
		 * @inheritDoc
		 */
		public function approve(displayObject : DisplayObject) : Boolean {
			return _registry.componentRegistered(displayObject);
		}
	}
}
