package com.epologee.security {
	import com.adobe.crypto.MD5;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class ChecksumGenerator {
		private var _key : String;

		public function ChecksumGenerator(inSecretKey : String) {
			_key = inSecretKey;
		}

		public function getChecksum(...inParams:Array) : String {
			return MD5.hash(inParams.join("")+_key);
		}
		
		public function toString():String {
			// com.epologee.security.ChecksumGenerator
			var s:String = "";
			// s = "[ " + name + " ]:";
			return s+getQualifiedClassName(this);
		}
	}
}