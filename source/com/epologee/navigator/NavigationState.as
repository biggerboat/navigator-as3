package com.epologee.navigator {
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
		
		public static function make(stateOrPath : *) : NavigationState {
			return stateOrPath is NavigationState ? stateOrPath : new NavigationState(stateOrPath);
		}

		/**
		 * @param ...inSegements: Pass the desired path segments as a list of arguments, or pass it all at once, as a ready-made path, it's up to you.
		 * 
		 * Examples:
		 * 
		 * 		new NavigationState("beginning/end");
		 * 		new NavigationState("beginning", "end");
		 */
		public function NavigationState(...segments : Array) {
			path = segments.join(DELIMITER);
		}

		/**
		 * A path will always start and end with a slash /
		 * All double slashes // will be removed and white spaces are 
		 * replaced by dashes -.
		 */
		public function set path(path : String) : void {
			_path = DELIMITER + path.toLowerCase() + DELIMITER;
			_path = _path.replace(new RegExp("\/+", "g"), "/");
			_path = _path.replace(/\s+/g, "-");
		}

		public function get path() : String {
			return _path;
		}

		/**
		 * Set the path as a list of segments (or path components).
		 * Example: ["a", "b", "c"] will result in a path /a/b/c/
		 */
		public function set segments(segments : Array) : void {
			path = segments.join(DELIMITER);
		}

		/**
		 * Returns the path cut up in segments (or path components).
		 */
		public function get segments() : Array {
			var s : Array = _path.split(DELIMITER);

			// pop emtpy string off the back.
			if (!s[s.length - 1])
				s.pop();

			// shift empty string off the start.
			if (!s[0])
				s.shift();

			return s;
		}

		/**
		 * Convenience method for not having to call segments[0] all the time.
		 */
		public function get firstSegment():String {
			return segments[0];
		}

		/**
		 * Convenience method for not having to call segments[segments.length-1] all the time.
		 */
		public function lastSegment() : String {
			var s : Array = segments;
			return s[s.length - 1];
		}

		/**
		 * @return whether the path of the foreign state is contained by this state's path, wildcards may be used.
		 * @example:
		 * 
		 * 	a = new State("/bubble/gum/");
		 * 	b = new State("/bubble/");
		 * 	
		 * 	a.contains(b) will return true.
		 * 	b.contains(a) will return false.
		 * 	
		 */
		public function contains(foreignState : NavigationState) : Boolean {
			var foreignSegments : Array = foreignState.segments;
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

		/**
		 * Will test for equality between states. This comparison is wildcard safe!
		 * @example: 
		 * 		a/b/c equals a/b/*
		 */
		public function equals(state : NavigationState) : Boolean {
			var sub : NavigationState = subtract(state);
			if (!sub)
				return false;

			return sub.segments.length == 0;
		}

		/**
		 * Subtracts the path of the operand from the current state and returns it as a new state instance.
		 * Subtraction uses containment as the main method of comparison, therefore wildcard safe!
		 * @example
		 * 		/portfolio/editorial/84/3 - /portfolio/ = /editorial/84/3
		 * 		/portfolio/editorial/84/3 - * = /editorial/84/3
		 */
		public function subtract(operand : NavigationState) : NavigationState {
			if (!contains(operand))
				return null;

			var ns : NavigationState = new NavigationState();
			var subtract : Array = segments;
			subtract.splice(0, operand.segments.length);
			ns.segments = subtract;
			return ns;
		}

		public function add(trailingStateOrPath : *) : NavigationState {
			return new NavigationState(path, make(trailingStateOrPath).path);
		}

		public function addSegments(...trailingSegments : Array) : NavigationState {
			var trailingState : NavigationState = new NavigationState();
			trailingState.segments = trailingSegments;
			return add(trailingState);
		}

		public function prefix(leadingStateOrPath : *) : NavigationState {
			return new NavigationState(make(leadingStateOrPath), path);
		}

		public function hasWildcard() : Boolean {
			return path.indexOf(WILDCARD) >= 0;
		}

		/**
		 * Will mask wildcards with values from the provided state.
		 */
		public function mask(source : NavigationState) : NavigationState {
			if (!source)
				return clone();

			var unmaskedSegments : Array = segments;
			var sourceSegments : Array = source.segments;
			var leni : int = Math.min(sourceSegments.length, unmaskedSegments.length);
			for (var i : int = 0;i < leni ;i++) {
				if (unmaskedSegments[i] == NavigationState.WILDCARD && sourceSegments[i]) {
					unmaskedSegments[i] = sourceSegments[i];
				}
			}

			var masked : NavigationState = new NavigationState();
			masked.segments = unmaskedSegments;
			return masked;
		}

		public function clone() : NavigationState {
			return new NavigationState(path);
		}

		public function toString() : String {
			return path;
		}
	}
}
