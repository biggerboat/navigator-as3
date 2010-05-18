package com.epologee.util {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ArrayUtils {
		/**
		 * Matches the elements of two arrays.
		 * For simple cases you could do a string based match though: (listA.join("") == listB.join("")).
		 * @return true if there's a match, false if there's no match or any of the supplied arrays is null. 
		 */
		public static function match(inListA : Array, inListB : Array) : Boolean {
			// if either one is not an array, will return false.
			// it will also return false if both parameters are null!
			if (!(inListA is Array) || !(inListB is Array)) return false;
			
			// if the lengths don't match, there's no match
			if (inListA.length != inListB.length) return false;
			
			// iterate over the list
			var leni:int = inListA.length;
			for (var i : int = 0; i < leni; i++) {
				if (inListA[i] != inListB[i]) return false;
			}
			
			return true;
		}
		
		/**
		 * Shift an element off of a list, and return it after pushing it on again,
		 * effectively rotating through the list.
		 */
		public static function rotate(inList : Array, inReverse : Boolean = false) : * {
			var field : *;
			
			if (inReverse) {
				field = inList.pop();
				inList.unshift(field);
			} else {
				field = inList.shift();
				inList.push(field);
			}
			return field;
		}

		/**
		 * Shift as many elements off of the list, until the shifted element passed
		 */
		public static function rotatePast(inList : Array, inTargetElement : *, inInsertIfNotFound : Boolean = false) : void {
			var leni : int = inList.length;
			for (var i : int = 0;i < leni;i++) {
				if (rotate(inList) == inTargetElement) return;
			}
			
			if (inInsertIfNotFound) {
				inList.push(inTargetElement);
			}
			return;
		}

		public static function rotateBefore(inList : Array, inTargetElement : *, inInsertIfNotFound : Boolean = false) : void {
			rotatePast(inList, inTargetElement, inInsertIfNotFound);
			rotate(inList, true);
		}
		
		public static function remove(inList:Array, inDeleteElement:*) : void {
			var leni:int = inList.length;
			for (var i : int = 0; i < leni; i++) {
				if (inList[i] == inDeleteElement) {
					inList.splice(i, 1);
					return;
				}
			}
		}

		public static function randomize(inList : Array) : Array {
			var ordered : Array = inList.concat();
			var random : Array = [];
			
			while (ordered.length) {
				random.push(ordered.splice(Math.random() * ordered.length, 1)[0]);			
			}		
			
			return random;	
		}
		
		public static function introspect(inObject : *, inCurrentPadding : String = "") : String {
			var nextPadding : String = inCurrentPadding + "\t";
			var s : String;
			
			if (inObject is String) {
				s = "\""+inObject+"\"";
			} else if (inObject is Number && Math.floor(inObject) == inObject) {
				s = inObject;
			} else if (inObject is Boolean) {
				s = inObject;
			} else if (inObject is Number) {
				s = inObject;
			} else if (inObject is Date) {
				s = inObject;
			} else if (inObject is Array) {
				var list : Array = inObject as Array;
				var leni : int = list.length;
				s = "array [\n";
				for (var i : int = 0;i < leni;i++) {
					s += nextPadding + "[" + i + "] " + introspect(list[i], nextPadding);
				}
				s += inCurrentPadding + "]";
			} else if (inObject is Object) {
				
				s = "object {\n";
				for (var p : * in inObject) {
					s += nextPadding + p + ": " + introspect(inObject[p], nextPadding);
				}
				s += inCurrentPadding + "}";
			} else {
				s = inObject;
			}
			
			return s + "\n";		
		}
	}
}
