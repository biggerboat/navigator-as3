package com.epologee.navigator.integration.puremvc {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.NavigatorEvent;
	import com.epologee.navigator.SWFAddressNavigator;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.epologee.navigator.behaviors.INavigationResponder;
	import com.epologee.navigator.namespaces.hidden;

	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigationProxy extends Proxy {
		public static const NAME : String = getQualifiedClassName(NavigationProxy);
		//
		public static const TRANSITION_STATUS_UPDATED : String = NAME + ":TRANSITION_STATUS_UPDATED";
		public static const RESPONDER_ADDED : String = NAME + ":RESPONDER_ADDED";
		public static const RESPONDER_REMOVED : String = NAME + ":RESPONDER_REMOVED";
		public static const NAVIGATION_STARTED : String = NAME + ":NAVIGATION_STARTED";
		public static const STATE_CHANGED : String = NAME + ":STATE_CHANGED";
		//
		private var _navigator : Navigator;

		public function NavigationProxy(inUseSWFAddress : Boolean) {
			super(NAME);

			_navigator = inUseSWFAddress ? new SWFAddressNavigator() : new Navigator();
			_navigator.addEventListener(NavigatorEvent.TRANSITION_STATUS_UPDATED, handleTransitionStatusUpdate);
			_navigator.addEventListener(NavigatorEvent.STATE_CHANGED, handleStateChanged);
		}

		public function start(inDefaultState : NavigationState, inStartState : NavigationState = null) : void {
			_navigator.start(inDefaultState, inStartState);
			sendNotification(NAVIGATION_STARTED);
		}

		/**
		 * Will use the mediator names in the behavior nodes and register the actual mediator 
		 * instances in the corresponding navigation lists.
		 * 
		 * If you want to add non-mediator instances to show, update or validate, you can use
		 * the public add() method, with the appropriate behavior. See #NavigationBehaviors for
		 * the different options.
		 * 
		 * @param inMap an XML map following this example:
		 * 
		 * @example:
		 * 
		 *	var np : NavigationProxy = NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME));
		 *	
		 *	var map : XML = <map>
		 *		<state path="/">
		 *			<show>{LogoMediator.NAME}</show>
		 *			<show>{PortfolioMediator.NAME}</show>
		 *			<auto>{MenuMediator.NAME}</auto>
		 *			<show>{FullScreenMediator.NAME}</show>
		 *			<update>{MenuMediator.NAME}</update>
		 *		</state>
		 *		<state path="/portfolio/">
		 *			<validate>{PortfolioMediator.NAME}</validate>
		 *			<update>{PortfolioMediator.NAME}</update>
		 *		</state>
		 *	</map>;
		 *	
		 *	np.parseMediatorStateMap(map);
		 *
		 */
		public function parseMediatorStateMap(inMap : XML) : void {
			var states : XMLList = inMap.child("state");

			var leni : int = states.length();
			for (var i : int = 0;i < leni;i++) {
				var state : XML = states[i];
				var path : String = state.@path;

				var responders : XMLList = XMLList(states[i]).children();
				var lenj : int = responders.length();
				for (var j : int = 0;j < lenj;j++) {
					// responders must be mediator implementing inavigationresponder
					var node : XML = responders[j] as XML;
					var untypedResponder : * = facade.retrieveMediator(node);
					if (!untypedResponder) {
						untypedResponder = facade.retrieveProxy(node);
						if (!untypedResponder) {
							logger.error("Not found in Facade (tried mediator and proxy): " + node);
							continue;
						}
					}

					var responder : INavigationResponder = untypedResponder as INavigationResponder;
					try {
						add(responder, path, node.name().localName);
					} catch (e : Error) {
						if (e.errorID == 1034 && e.message.length > 11) {
							var type : String = e.message.split(" ").pop();
							type = type.substr(0, type.length - 1);
							logger.warn(untypedResponder + " should implement [" + type + "], if you want to use it as <" + node.name().localName + " />");
						} else {
							logger.warn(untypedResponder + " " + node.name().localName + ": " + e.message);
						}
					}
				}
			}
		}

		public function add(inResponder : INavigationResponder, inPathOrState : *, inBehavior : String):void {
			_navigator.add(inResponder, inPathOrState, inBehavior);
			sendNotification(RESPONDER_ADDED, inResponder, inBehavior);
		}

		public function registerHiddenState(inState : NavigationState, inExactMatch : Boolean = false) : void {
			if (_navigator is SWFAddressNavigator) {
				SWFAddressNavigator(_navigator).registerHiddenState(inState, inExactMatch);
			}
		}

		public function registerRedirect(inFrom : NavigationState, inTo : NavigationState) : void {
			_navigator.registerRedirect(inFrom, inTo);
		}

		/**
		 * Use this method when you want to pass in a simple string.
		 * If you already have a #NavigationState object, use the regular requestNewState() method.
		 */
		public function requestNewStateByPath(inPath : String) : void {
			_navigator.requestNewStateByPath(inPath);
		}

		/**
		 * Request a new state by providing a #NavigationState instance.
		 * If the new state is different from the current, it will be validated and granted.
		 */
		public function requestNewState(inNavigationState : NavigationState) : void {
			_navigator.requestNewState(inNavigationState);
		}

		public function getStatus(inResponder : IHasStateTransition) : int {
			return _navigator.hidden::getStatus(inResponder);
		}

		public function getCurrentState() : NavigationState {
			return _navigator.hidden::getCurrentState();
		}

		private function handleTransitionStatusUpdate(event : NavigatorEvent) : void {
			sendNotification(TRANSITION_STATUS_UPDATED, event.statusByResponder);
		}

		private function handleStateChanged(event : NavigatorEvent) : void {
			sendNotification(STATE_CHANGED, _navigator.hidden::getCurrentState());
		}

		/**
		 * Use this getter only for development feedback.
		 */
		hidden function get navigator() : Navigator {
			return _navigator;
		}
	}
}