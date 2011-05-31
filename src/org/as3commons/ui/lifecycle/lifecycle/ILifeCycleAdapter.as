package org.as3commons.ui.lifecycle.lifecycle {

	import flash.display.DisplayObject;

	/**
	 * <code>LifeCycle</code> component adapter definition.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public interface ILifeCycleAdapter {
		
		/**
		 * Component with that the adapter has been registered in LifeCycle.
		 */
		function get component() : DisplayObject;

		/**
		 * Registers a component to be updated right before an update is performed.
		 * 
		 * @param child The component to auto update.
		 */
		function autoUpdateBefore(child : DisplayObject) : void;
		
		/**
		 * Removes a component from the auto update list.
		 * 
		 * @param child The component to remove from auto updates.
		 */
		function removeAutoUpdateBefore(child : DisplayObject) : void;
		
		/**
		 * Starts an invalidation process.
		 * 
		 * <p>The optional <code>property</code> argument may be used to declare only parts
		 * of a component to be updated.</p>
		 * 
		 * <p>If <code>property</code> is set, a call to <code>isInvalid(property)</code> within
		 * the update hooks <code>onPrepareUpdate()</code> and <code>onUpdate()</code> will return
		 * <code>true</code>.</p>
		 * 
		 * <p>If <code>property</code> is not set, the system assumes the wish of a full update,
		 * and a call to <code>isInvalid(property)</code> withing the update hooks <code>onPrepareUpdate()</code>
		 * and <code>onUpdate()</code> will always return <code>true</code> regardless of the actual
		 * value of <code>property</code>.</p>
		 * 
		 * @param property An optional invalidation property.
		 */
		function invalidate(property : String = null) : void;
		
		/**
		 * Immediately performs an update.
		 * 
		 * <p>Components not invalidated beforehand are not validated.</p>
		 * 
		 * <p>Components currently not in the display list are not validated.</p>
		 */
		function validateNow() : void;

		/**
		 * Returns <code>true</code> if the <code>property</code> has been invalidated beforehand.
		 * 
		 * <p>Returns also <code>true</code> for any property value, if an invalidation
		 * process had been invoked without specification of an invalidation property
		 * (<code>invalidate()</code>).</p>
		 * 
		 * <p>This method might be used within the update hooks <code>onPrepareUpdate()</code>
		 * and <code>onUpdate()</code> to determine what properties of a component had been
		 * changed and should cause an visual update.</p>
		 * 
		 * @param property The property that might be invalid.
		 */
		function isInvalid(property : String) : Boolean;
		
		/**
		 * Defines an <code>updateKind</code> that can be considered within the <code>onUpdate</code> hook.
		 * 
		 * <p>This method might be used within the update hook <code>onPrepareUpdate()</code> to
		 * schedule a visual update that should be subsequently executed within the <code>onUpdate()</code>
		 * hook.</p>
		 * 
		 * @param updateKind The visual update to schedule.
		 */
		function scheduleUpdate(updateKind : String) : void;
		
		/**
		 * Returns <code>true</code> if the <code>updateKind</code> has been scheduled beforehand.
		 * 
		 * @param property The kind of update that could be executed.
		 */
		function shouldUpdate(updateKind : String) : Boolean;

		/**
		 * Removes all listeners and references of the particular adapter.
		 * 
		 * <p>The adapter is then eligible for garbage collection.</p>
		 * 
		 * <p>Calling <code>cleanUp</code> will subsequently invoke the clean up hook <code>onCleanUp()</code>
		 * to enable a client to perform further disposals.</p>
		 */
		function cleanUp() : void;

		/**
		 * Sets a custom callback for the init event.
		 * 
		 * <p>If specified, this callback is invoked instead of the protected <code>onInit()</code> hook.</p>
		 * 
		 * <p>Since the init hook is triggered at the time of registration, a custom handler must be set
		 * before the component has been registered.</p>
		 * 
		 * @param initHandler The init callback.
		 */
		function set initHandler(initHandler : Function) : void;
		
		/**
		 * Sets a custom callback for the draw event.
		 * 
		 * <p>If specified, this callback is invoked instead of the protected <code>onDraw()</code> hook.</p>
		 * 
		 * @param initHandler The draw callback.
		 */
		function set drawHandler(drawHandler : Function) : void;
		
		/**
		 * Sets a custom callback for the prepare update event.
		 * 
		 * <p>If specified, this callback is invoked instead of the protected <code>onPrepareUpdate()</code> hook.</p>
		 * 
		 * @param prepareUpdateHandler The prepare update callback.
		 */
		function set prepareUpdateHandler(prepareUpdateHandler : Function) : void;
		
		/**
		 * Sets a custom callback for the update event.
		 * 
		 * <p>If specified, this callback is invoked instead of the protected <code>onUpdate()</code> hook.</p>
		 * 
		 * @param prepareUpdateHandler The update callback.
		 */
		function set updateHandler(updateHandler : Function) : void;
		
		/**
		 * Sets a custom callback for the clean up event.
		 * 
		 * <p>If specified, this callback is invoked instead of the protected <code>onCleanUp()</code> hook.</p>
		 * 
		 * @param prepareUpdateHandler The clean up callback.
		 */
		function set cleanUpHandler(cleanUpHandler : Function) : void;

	}
}
