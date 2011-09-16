package org.as3commons.ui.framework.uiservice {

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.framework.uiservice.errors.AdapterAlreadyRegisteredError;
	import org.as3commons.ui.framework.uiservice.errors.AdapterNotRegisteredError;
	import org.as3commons.ui.framework.uiservice.errors.ObjectAlreadyRegisteredError;
	import org.as3commons.ui.framework.uiservice.errors.ServiceDisposedError;
	import org.as3commons.ui.framework.uiservice.errors.ServiceNotStartedError;

	import flash.display.DisplayObject;

	use namespace as3commons_ui;

	/**
	 * Abstract UI service.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class AbstractUIService {

		/**
		 * The internal object to adapter mapping.
		 */
		protected var _registry : IMap;

		/**
		 * Flag that indicates, if the service already has been started.
		 */
		protected var _initialized : Boolean;

		/*
		 * as3commons_ui
		 */

		as3commons_ui function getAdapter_internal(displayObject : DisplayObject) : AbstractUIAdapter {
			if (!_registry) return null; // not started or disposed
			return _registry.itemFor(displayObject);
		}

		as3commons_ui function hasAdapter_internal(displayObject : DisplayObject) : Boolean {
			if (!_registry) return false; // not started or disposed
			return _registry.hasKey(displayObject);
		}

		/*
		 * protected
		 */

		/**
		 * Starts the service.
		 */
		protected function start_protected() : void {
			if (_initialized) return; // service already started

			_registry = new Map();
			_initialized = true;
			
			onStart();
		}

		/**
		 * Registers a display object.
		 */
		protected function registerDisplayObject_protected(displayObject : DisplayObject, adapter : AbstractUIAdapter) : void {
			if (!_initialized) throw new ServiceNotStartedError();
			if (!_registry) throw new ServiceDisposedError();

			if (_registry.hasKey(displayObject)) throw new ObjectAlreadyRegisteredError();
			if (adapter.displayObject) throw new AdapterAlreadyRegisteredError();

			_registry.add(displayObject, adapter);
			adapter.setUp_internal(displayObject, this);

			onRegister(adapter);
		}

		/**
		 * Unregisters a display object.
		 */
		protected function unregisterDisplayObject_protected(displayObject : DisplayObject) : void {
			if (!_initialized) throw new ServiceNotStartedError();
			if (!_registry) return; // service disposed

			if (!_registry.hasKey(displayObject)) throw new AdapterNotRegisteredError();

			unregisterDisplayObject_private(displayObject);
		}

		/**
		 * Disposes the service.
		 */
		protected function cleanUp_protected() : void {
			if (!_registry) return; // service disposed

			var iterator : ICollectionIterator = _registry.iterator() as ICollectionIterator;
			while (iterator.hasNext()) {
				var adapter : AbstractUIAdapter = iterator.next();
				unregisterDisplayObject_private(adapter.displayObject);
			}
			
			_registry = null;
			
			onCleanUp();
		}

		/**
		 * Start hook for subclasses.
		 */
		protected function onStart() : void {
		}

		/**
		 * Register hook for subclasses.
		 */
		protected function onRegister(adapter : AbstractUIAdapter) : void {
		}

		/**
		 * Unregister hook for subclasses.
		 */
		protected function onUnregister(adapter : AbstractUIAdapter, displayObject : DisplayObject) : void {
		}

		/**
		 * Clean up hook for subclasses.
		 */
		protected function onCleanUp() : void {
		}
		
		/*
		 * Private
		 */

		private function unregisterDisplayObject_private(displayObject : DisplayObject) : void {
			var adapter : AbstractUIAdapter = _registry.removeKey(displayObject);
			adapter.cleanUp_internal();
			
			onUnregister(adapter, displayObject);
		}
		
	}
}
