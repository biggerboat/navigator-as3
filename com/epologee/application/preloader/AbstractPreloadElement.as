package com.epologee.application.preloader {
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**	 * @author Eric-Paul Lecluse | epologee.com (c) 2009	 */	public	class AbstractPreloadElement extends EventDispatcher {		public static const APP : String = "app";		public static const SWF : String = "swf";		public static const DATA_XML : String = "data_xml";		public static const URLS_XML : String = "urls_xml";
		public static const CUSTOM_CLASS : String = "custom_class";
		//		public var weight : Number;		public var progress : Number;
		//
		protected var initialized : Boolean = false;

		public function AbstractPreloadElement(inWeight : Number = 1) {
			weight = inWeight;			progress = 0;
		}

		public function start() : void {
			// nothing to see here
			// please move along
			// (or try overriding this method)
		}
		public function isInitialized() : Boolean {
			return initialized;
		}

		protected function dispatchProgress() : void {
			dispatchEvent(new PreloadElementEvent(PreloadElementEvent.PROGRESS));
		}	

		protected function dispatchReady() : void {
			initialized = true;
			dispatchEvent(new PreloadElementEvent(PreloadElementEvent.INITIALIZED));
		}

		override public function toString() : String {
			var s : String = "";
			s = "[ " + progress + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}