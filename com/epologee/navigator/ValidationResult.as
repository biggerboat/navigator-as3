package com.epologee.navigator {
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ValidationResult {
		private static const NAME : String = getQualifiedClassName(ValidationResult);
		//
		public static const PASS : String = NAME + ":PASS";
		public static const IGNORE : String = NAME + ":IGNORE";
		public static const FAIL : String = NAME + ":FAIL";
	}
}
