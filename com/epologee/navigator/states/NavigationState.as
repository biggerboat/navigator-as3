package com.epologee.navigator.states {
	import com.epologee.development.logging.debug;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * The NavigationState is the most important part of the Navigator system.
	 * It is essentially a wrapper to substitute passing around a string for path comparisons.
	 * Instead, you use this class and it will handle all the issues with slashes, letter case,
	 * wildcards, path segments and comparison/manipulation of two states.
	 * 
	 *
	 */
	public class NavigationState {
		public static const WILDCARD : String = "*";
		public static const DELIMITER : String = "/";
		//
		private var _path : String;

		/**
		 * @param ...inSegements: Pass the desired path segments as a list of arguments, or pass it all at once, as a ready-made path, it's up to you.
		 * 
		 * Examples:
		 * 
		 * 		new NavigationState("beginning/end");
		 * 		new NavigationState("beginning", "end");
		 */
		public function NavigationState(...inSegments : Array) {
			path = inSegments.join("/");
		}

		public function set path(inPath : String) : void {
			_path = "/" + inPath.toLowerCase() + "/";
			_path = _path.replace(new RegExp("\/+", "g"), "/");
			_path = _path.replace(/\s+/g, "-");
		}

		public function get path() : String {
			return _path;
		}

		public function set segments(inSegments : Array) : void {
			path = inSegments.join(DELIMITER);
		}

		public function get segments() : Array {
			var s : Array = _path.split(DELIMITER);
			
			// pop emtpy string off the back.
			if (!s[s.length - 1]) s.pop();
			
			// shift empty string off the start.
			if (!s[0]) s.shift();
			
			return s;
		}

		/**
		 * @return whether the path of the foreign state is contained by this state's path, wildcards may be used.
		 * @example:
		 * 
		 * 	a = new State("/bubble/gum/");
		 * 	b = new State("/bubble/");
		 * 	
		 * 	a.containsState(b) will return true.
		 * 	b.containsState(a) will return false.
		 * 	
		 */
		public function containsState(inForeignState : NavigationState) : Boolean {
			var foreignSegments : Array = inForeignState.segments;
			var nativeSegments : Array = segments;
			
			if (foreignSegments.length > nativeSegments.length) {
				// foreign segment length too big
				return false;
			}
			
			// check to see if the overlapping segments match.
			// since the foreign segment count has to be smaller than the native,
			// the foreign count is used to limit the loop:
			var leni : int = foreignSegments.length;
			for (var i : int = 0;i < leni;i++) {
				var foreignSegment : String = foreignSegments[i];
				var nativeSegment : String = nativeSegments[i];

				if (foreignSegment == WILDCARD || nativeSegment == WILDCARD) {
					// mathes because of the wildcard.
				} else if (foreignSegment != nativeSegment) {
					// native [" + nativeSegment + "] does not match foreign [" + foreignSegment + "]
					return false;
				} else {
					// native  [" + nativeSegment + "] matches foreign [" + foreignSegment + "]
				}
			}
			
			return true;
		}

		public function equals(inState : NavigationState) : Boolean {
			var sub : NavigationState = subtract(inState);
			if (!sub) return false;
			
			return sub.segments.length == 0;
		}

		/**
		 * Subtracts the path of the operand from the current state and returns it as a new state instance.
		 * @example "/portfolio/editorial/84/3" - "/portfolio/" = "/editorial/84/3"
		 */
		public function subtract(inOperand : NavigationState) : NavigationState {
			if (!containsState(inOperand)) return null;
			var ns : NavigationState = new NavigationState();
			var subtract : Array = segments;
			subtract.splice(0, inOperand.segments.length);
			ns.segments = subtract;
			return ns;
		}

		public function add(inTrailingState : NavigationState) : NavigationState {
			return new NavigationState(path + DELIMITER + inTrailingState.path);
		}

		public function hasWildcard() : Boolean {
			return path.indexOf(WILDCARD) >= 0;
		}

		public function clone() : NavigationState {
			return new NavigationState(path);
		}

		/**
		 * Will mask wildcards with values from the provided state.
		 */
		public function mask(inSource : NavigationState) : NavigationState {
			if (!inSource) return clone();
			
			debug("inSource: " + inSource + " onto: " + toString());
			var unmasked : Array = segments;
			var source : Array = inSource.segments;
			var leni : int = Math.min(source.length, unmasked.length);
			for (var i : int = 0;i < leni ;i++) {
				if (unmasked[i] == NavigationState.WILDCARD && source[i]) {
					unmasked[i] = source[i];
				}
			}
			
			var masked : NavigationState = new NavigationState();
			masked.segments = unmasked;
			return masked;
		}

		public function toString() : String {
			return "path: " + path;
		}
	}
}
