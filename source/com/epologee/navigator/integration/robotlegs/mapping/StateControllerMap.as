package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.NavigationState;
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
		private var _navigator : INavigator;
		private var _injector : IInjector;
		private var _commandsByState : Dictionary;
		private var _verifiedCommandClasses : Dictionary;

		public function StateControllerMap(navigator : INavigator, injector : IInjector) {
			_navigator = navigator;
			_injector = injector;

			_commandsByState = new Dictionary();
			_verifiedCommandClasses = new Dictionary();

			_navigator.add(this, "");
		}

		public function mapCommand(stateOrPath : *, commandClass : Class, exactMatch : Boolean = false, oneShot : Boolean = false) : void {
			var state : NavigationState = NavigationState.make(stateOrPath);
			var commands : Array = _commandsByState[state.path] ||= [];

			if (hasCommand(commands, commandClass)) {
				logger.warn("Already mapped " + commandClass + " to state " + state);
				return;
			}

			verifyCommandClass(commandClass);

			commands.push(new CommandWrapper(commandClass, state, exactMatch, oneShot));
		}

		public function unmapCommand(stateOrPath : *, commandClass : Class) : void {
			var state : NavigationState = NavigationState.make(stateOrPath);
			var commands : Array = _commandsByState[state.path] ||= [];

			for (var i : int = commands.length; --i >= 0; ) {
				var wrapper : CommandWrapper = CommandWrapper(commands[i]);
				if (wrapper.CommandClass == commandClass) {
					commands.splice(i, 1);
					return;
				}
			}
		}

		public function updateState(truncated : NavigationState, full : NavigationState) : void {
			for (var path : String in _commandsByState) {
				var mappedState : NavigationState = NavigationState.make(path);
				if (full.contains(mappedState)) {
					var commands : Array = _commandsByState[path];
					var exact : Boolean = full.equals(mappedState);

					// reverse loop to accomodate for oneshot removal
					for (var i : int = commands.length; --i >= 0; ) {
						var wrapper : CommandWrapper = CommandWrapper(commands[i]);
						if (!exact && wrapper.exactMatch) continue;

						_injector.mapValue(NavigationState, full);
						_injector.mapValue(NavigationState, full.subtract(wrapper.state), "truncated");
						
						var command : Command = Command(_injector.instantiate(wrapper.CommandClass));
						command.execute();

						if (wrapper.oneShot) {
							unmapCommand(wrapper.state, wrapper.CommandClass);
						}
					}
				}
			}
		}

		protected function hasCommand(wrappedCommandsList : Array, testForCommandClass : Class) : Boolean {
			for each (var cw : CommandWrapper in wrappedCommandsList) {
				if (cw.CommandClass == testForCommandClass) return true;
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

	public function CommandWrapper(CommandClass : Class, state : NavigationState, exactMatch : Boolean, oneShot : Boolean) {
		this.oneShot = oneShot;
		this.state = state;
		this.exactMatch = exactMatch;
		this.CommandClass = CommandClass;
	}
}