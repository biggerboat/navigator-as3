package com.epologee.application.dvo {
	

	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class XMLErrorsVO implements IParsable {
		//
		private var _errors : Array;
		private var _errorsById : Dictionary;

		public function XMLErrorsVO() {
			_errors = [];
			_errorsById = new Dictionary();
		}
		
		public function isPlayerNotFoundError() : Boolean {
			var leni:int = _errors.length;
			for (var i : int = 0; i < leni; i++) {
				if (_errors[i] == "Player Not Found") return true;
			}
			
			return false;
		}

		public function get errors() : Array {
			return _errors;
		}

		public function hasErrorId(inId : String) : Boolean {
			return _errorsById[inId] != null;
		}

		public function parseXML(inXML : XML) : Boolean {
			if (inXML.error.length() == 0) return true;
			
			var errorNodes : XMLList = inXML.error; 
			var leni : int = errorNodes.length();
			for (var i : int = 0;i < leni;i++) {
				var errorNode : XML = errorNodes[i] as XML;
				_errors.push(errorNode.toString());
				
				if (errorNode.@id.length()) {
					_errorsById[parseInt(errorNode.@id)] = errorNode.toString();
				}
			}
			
			return true;
		}
	}
}
