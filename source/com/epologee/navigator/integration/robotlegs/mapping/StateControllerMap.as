package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.behaviors.IHasStateUpdate;

	import org.robotlegs.base.ContextError;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Command;

	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class StateControllerMap implements IStateControllerMap, IHasStateUpdate {
		private var _navigator : Navigator;
		private var _injector : IInjector;
		private var _commandsByState : Dictionary;
		private var _verifiedCommandClasses : Dictionary;

		public function StateControllerMap(inNavigator : Navigator, inInjector : IInjector) {
			_navigator = inNavigator;
			_injector = inInjector;

			_commandsByState = new Dictionary();
			_verifiedCommandClasses = new Dictionary();

			_navigator.add(this, "");
		}

		public function mapCommand(inStateOrPath : *, inCommandClass : Class, inExactMatch : Boolean = false, inOneShot : Boolean = false) : void {
			var state : NavigationState = NavigationState.make(inStateOrPath);
			var commands : Array = _commandsByState[state.path] ||= [];

			if (hasCommand(commands, inCommandClass)) {
				logger.warn("Already mapped " + inCommandClass + " to state " + state);
				return;
			}

			verifyCommandClass(inCommandClass);

			commands.push(new CommandWrapper(inCommandClass, state, inExactMatch, inOneShot));
		}

		public function unmapCommand(inStateOrPath : *, inCommandClass : Class) : void {
			var state : NavigationState = NavigationState.make(inStateOrPath);
			var commands : Array = _commandsByState[state.path] ||= [];

			for (var i : int = commands.length; --i >= 0; ) {
				var wrapper : CommandWrapper = CommandWrapper(commands[i]);
				if (wrapper.CommandClass == inCommandClass) {
					commands.splice(i, 1);
					return;
				}
			}
		}

		public function updateState(inTruncated : NavigationState, inFull : NavigationState) : void {
			for (var path : String in _commandsByState) {
				var mappedState : NavigationState = NavigationState.make(path);
				if (inFull.contains(mappedState)) {
					var commands : Array = _commandsByState[path];
					var exact : Boolean = inFull.equals(mappedState);

					// reverse loop to accomodate for oneshot removal
					for (var i : int = commands.length; --i >= 0; ) {
						var wrapper : CommandWrapper = CommandWrapper(commands[i]);
						if (!exact && wrapper.exactMatch) continue;

						_injector.mapValue(NavigationState, inFull);
						_injector.mapValue(NavigationState, inFull.subtract(wrapper.state), "truncated");
						
						var command : Command = Command(_injector.instantiate(wrapper.CommandClass));
						command.execute();

						if (wrapper.oneShot) {
							unmapCommand(wrapper.state, wrapper.CommandClass);
						}
					}
				}
			}
		}

		protected function hasCommand(inWrappedCommandsList : Array, inTestForCommandClass : Class) : Boolean {
			for each (var cw : CommandWrapper in inWrappedCommandsList) {
				if (cw.CommandClass == inTestForCommandClass) return true;
			}
			return false;
		}

		protected function verifyCommandClass(commandClass : Class) : void {
			if ( _verifiedCommandClasses[commandClass] ) return;
			if (describeType(commandClass).factory.method.(@name == "execute").length() != 1) {
				throw new ContextError(ContextError.E_COMMANDMAP_NOIMPL + ' - ' + commandClass);
			}
			_verifiedCommandClasses[commandClass] = true;
		}
	}
}
import com.epologee.navigator.NavigationState;

class CommandWrapper {
	public var CommandClass : Class;
	public var oneShot : Boolean;
	public var state : NavigationState;
	public var exactMatch : Boolean;

	public function CommandWrapper(inCommandClass : Class, inState : NavigationState, inExactMatch : Boolean, inOneShot : Boolean) {
		oneShot = inOneShot;
		state = inState;
		exactMatch = inExactMatch;
		CommandClass = inCommandClass;
	}
}