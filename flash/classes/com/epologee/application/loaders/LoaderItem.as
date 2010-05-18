package com.epologee.application.loaders {
	import com.epologee.development.logging.error;
	import com.epologee.development.logging.info;
	import com.epologee.development.logging.warn;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epocom
	 */
	public class LoaderItem extends EventDispatcher {

		public static const VISUAL : String = "swf/jpg/png/gif";
		public static const TEXTUAL : String = "xml/txt/etc";
		//
		public static const STATUS_PREPARATION : uint = 0;
		public static const STATUS_IN_PROGRESS : uint = 1;
		public static const STATUS_FAILED : uint = 2;
		public static const STATUS_SUCCESS : uint = 3;
		//
		protected var _textLoader : URLLoader;
		protected var _visualLoader : Loader;
		protected var _status : uint;
		protected var _request : URLRequest;
		protected var _type : String;

		public function LoaderItem(inURL : String, inType : String, inCompleteHandler : Function = null, inProgressHandler : Function = null, inAutoExecute:Boolean = false) {
			
			_type = inType;
			_request = new URLRequest(inURL);
			_request.method = URLRequestMethod.GET;
			
			if (inType == TEXTUAL) {
				_textLoader = new URLLoader();
			} else {
				_visualLoader = new Loader();
			}
			
			setStatus(STATUS_PREPARATION);
			
			if (inCompleteHandler is Function) {
				addEventListener(LoaderEvent.COMPLETE, inCompleteHandler);
			}
			
			if (inProgressHandler is Function) {
				addEventListener(LoaderEvent.PROGRESS, inProgressHandler);
			}
			
			if (inAutoExecute) {
				execute();
			}
		}

		public function get status() : uint {
			return _status;
		}

		public function get url() : String {
			return _request.url;
		}

		public function set request(inRequestData : Object) : void {
			_request.data = inRequestData;
		}

		public function get response() : * {
			if (_status < STATUS_SUCCESS) return null;
			
			return (_type == TEXTUAL ? _textLoader.data : _visualLoader.content);
		}

		/**
		 * @param inMethod e.g. URLRequestMethod.POST
		 */
		public function set method(inURLRequestMethod : String) : void {
			_request.method = inURLRequestMethod;
		}

		public function get bytesLoaded() : uint {
			return (_type == TEXTUAL ? _textLoader.bytesLoaded : _visualLoader.contentLoaderInfo.bytesLoaded);
		}

		public function get bytesTotal() : uint {
			return (_type == TEXTUAL ? _textLoader.bytesTotal : _visualLoader.contentLoaderInfo.bytesTotal);
		}

		public function get progress() : Number {
			if (_status < STATUS_IN_PROGRESS) return 0;
			
			if (_type == TEXTUAL) {
				return _textLoader.bytesLoaded / _textLoader.bytesTotal;
			}
			
			return _visualLoader.contentLoaderInfo.bytesLoaded / _visualLoader.contentLoaderInfo.bytesTotal;
		}

		public function execute(inCheckPolicyFile : Boolean = false) : void {
			if (_status >= STATUS_FAILED) {
				warn("execute: reset the loader before calling a second time");
				return;
			}
			
			if (_status >= STATUS_IN_PROGRESS) {
				warn("execute: already in progress!");
				return;
			}
			
			if (_request.url == null) {
				setStatus(STATUS_FAILED);
				var le : LoaderEvent = new LoaderEvent(LoaderEvent.ERROR, this);
				le.errorMessage = "url not specified";
				dispatchEvent(le);
				return;
			}
			
			setStatus(STATUS_IN_PROGRESS);
			setListeners();
			
			if (_type == TEXTUAL) {
				_textLoader.load(_request);
			} else {
				_visualLoader.load(_request, new LoaderContext(inCheckPolicyFile, ApplicationDomain.currentDomain));
			}
		}

		public function abort() : void {
			try {
			
				if (_type == TEXTUAL) {
					_textLoader.close();
				} else {
					_visualLoader.close();
				}
			} catch (ei : Error) {
				// if we're not loading anything, we don't care about the message saying we're not loading anything.
			}
		}

		public function reset() : void {
			if (_status >= STATUS_FAILED) {
				setStatus(STATUS_PREPARATION);
			}
		}

		public function get readableStatus() : String {
			switch (_status) {
				case STATUS_FAILED: 
					return "STATUS_FAILED";
				case STATUS_IN_PROGRESS: 
					return "STATUS_IN_PROGRESS";
				case STATUS_PREPARATION: 
					return "STATUS_PREPARATION";
				case STATUS_SUCCESS: 
					return "STATUS_SUCCESS";
			}
			return "if this happens, you've reached the end of the universe. either that or there's something seriously screwed up in your application.";
		}

		protected function handleComplete(event : Event) : void {
			cleanupListeners();
			setStatus(STATUS_SUCCESS);
			var le : LoaderEvent = new LoaderEvent(LoaderEvent.COMPLETE, this);
			
			if (!hasEventListener(le.type)) {
				info("handleComplete: " + readableStatus);
			}
			dispatchEvent(le);
		}

		protected function handleIOError(event : IOErrorEvent) : void {
			cleanupListeners();
			setStatus(STATUS_FAILED);
			var le : LoaderEvent = new LoaderEvent(LoaderEvent.ERROR, this);
			le.errorMessage = event.text;
			
			if (!hasEventListener(le.type)) {
				error("handleIOError: " + le.errorMessage);
			}
			dispatchEvent(le);
		}

		protected function handleSecurityError(event : SecurityErrorEvent) : void {
			cleanupListeners();
			setStatus(STATUS_FAILED);
			var le : LoaderEvent = new LoaderEvent(LoaderEvent.ERROR, this);
			le.errorMessage = event.text;
			
			if (!hasEventListener(le.type)) {
				error("handleSecurityError: " + le.errorMessage);
			}
			dispatchEvent(le);
		}

		protected function handleProgress(event : ProgressEvent) : void {
			var le : LoaderEvent = new LoaderEvent(LoaderEvent.PROGRESS, this);
			dispatchEvent(le);
		}

		protected function setListeners() : void {
			if (_type == TEXTUAL) {
				_textLoader.addEventListener(Event.COMPLETE, handleComplete);
				_textLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				_textLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
				_textLoader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			} else {
				_visualLoader = new Loader();
				_visualLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
				_visualLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				_visualLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
				_visualLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			}
		}

		protected function cleanupListeners() : void {
			if (_type == TEXTUAL) {
				_textLoader.removeEventListener(Event.COMPLETE, handleComplete);
				_textLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				_textLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
				_textLoader.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			} else {
				_visualLoader = new Loader();
				_visualLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleComplete);
				_visualLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				_visualLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
				_visualLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			}
		}

		protected function setStatus(inNewStatus : uint) : void {
			_status = inNewStatus;
			var le : LoaderEvent = new LoaderEvent(LoaderEvent.STATUS_CHANGE, this);
			le.status = _status;
			dispatchEvent(le); 
		}

		override public function toString() : String {
			// com.epodata.loaders.LoaderItem
			var s : String = "";
			s = "[ " + _request.url + " ]:" + getQualifiedClassName(this);
			if (_request.data is XML) {
				s += "\n" + _request.data.toXMLString();
			}
			return s;
		}
	}	
}