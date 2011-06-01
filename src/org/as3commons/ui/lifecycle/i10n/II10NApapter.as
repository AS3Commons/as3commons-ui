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
package org.as3commons.ui.lifecycle.i10n {

	import org.as3commons.collections.framework.ISet;

	import flash.display.DisplayObject;

	/**
	 * <code>Invalidation</code> adapter definition.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public interface II10NApapter {
		
		/**
		 * Callback for the will validate event.
		 * 
		 * <p>Validation is executed in two steps. The first step looks at the
		 * next item (peek) in the internal validation queue and triggers this method. A
		 * custom adapter may here perform additional updates such as adding new
		 * invalidation properties or auto updating other components beforhand.
		 * After this method has finished the next item is removed from the validation
		 * queue (poll). So adding new invalidation properties within <code>validate()</code>
		 * will result in readding the component to the queue and hence updating the
		 * component twice.</p>
		 * 
		 * <p>Use this method if you want to modify the list of invalidate properties
		 * right before the actual validation.</p>
		 * 
		 * <p>It is possible to immediately validate the component during this method using
		 * <code>Invalidation.validateNow(component)</code>. In that case the <code>validate()</code>
		 * method will not be triggered.</p>
		 * 
		 * @param displayObject The component that will be validated next.
		 */
		function willValidate(displayObject : DisplayObject) : void;

		/**
		 * Callback for the validate event.
		 * 
		 * @param displayObject The component to be validated.
		 * @param properties List of invalid properties specified in <code>Invalidation.invalidate(property)</code>.
		 */
		function validate(displayObject : DisplayObject, properties : ISet) : void;
		
	}
}
