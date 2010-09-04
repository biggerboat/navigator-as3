package com.epologee.navigator.integration.puremvc {
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.puremvc.view.TimelineMediator;

	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * This is a standard base class for use with the NavigationProxy.
	 */
	public class TransitionMediator extends TimelineMediator implements IHasStateInitialization, IHasStateTransition {
		public function TransitionMediator(inName : String, inTimeline : Sprite) {
			super(inName, inTimeline);

			timeline.addEventListener(NavigationEvent.REQUEST_STATE, handleNavigationEvent);
		}

		/**
		 * Implementation of the #IHasStateInitialization interface.
		 * Will be called right before the first call to transitionIn(), update() or validate();
		 */
		public function initialize() : void {
			// override for initialization purposes.
			timeline.visible = false;
		}

		/**
		 * Implementation of the #IHasStateTransition interface.
		 */
		public function transitionOut(inCallOnComplete : Function) : void {
			timeline.visible = false;
			inCallOnComplete();
		}

		/**
		 * Implementation of the #IHasStateTransition interface.
		 */
		public function transitionIn(inCallOnComplete : Function) : void {
			timeline.visible = true;
			inCallOnComplete();
		}

		/**
		 * Dispatch NavigationEvents within timeline components to trigger a (bubbled) navigation request.
		 */
		protected function handleNavigationEvent(event : NavigationEvent) : void {
			NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME)).requestNewState(event.state);
		}
	}
}
