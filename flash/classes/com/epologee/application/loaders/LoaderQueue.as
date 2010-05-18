package com.epologee.application.loaders {
	import flash.events.EventDispatcher;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class LoaderQueue extends EventDispatcher {
		private static const STATUS_READY : uint = 0;
		private static const STATUS_IN_PROGRESS : uint = 1;
		//
		private var _queue : Array;
		private var _status : uint;

		public function LoaderQueue() {
			_queue = [];
			_status = STATUS_READY;
		}

		/**
		 * @param inName: is used to distinguish what request completes/fails/progresses etc.
		 * @param inURL: is the complete URL (may contain GET-parameters)
		 * @param inRequestData (optional): may contain several types of data. XML will be sent as raw request data. URLVariables will be passed as POST data. 
		 */
		public function addXMLRequest(inURL : String, inPostData : * = null) : void {
			var item : XMLLoaderItem = new XMLLoaderItem(inURL);

			if (inPostData is XML || inPostData is URLVariables) {
				item.method = URLRequestMethod.POST;
				item.request = inPostData;
			}
			
			_queue.push(item);
			loadNext();
		}
		
		public function addSWFRequest(inURL:String) : void {
			var item : SWFLoaderItem = new SWFLoaderItem(inURL);
			
			_queue.push(item);
			loadNext();
		}

		private function loadNext() : void {
			if (_queue.length == 0) return;
			if (_status != STATUS_READY) return;
			
			_status = STATUS_IN_PROGRESS;
			var item : LoaderItem = _queue.shift() as LoaderItem;
			item.addEventListener(LoaderEvent.COMPLETE, handleComplete);
			item.addEventListener(LoaderEvent.ERROR, handleError);
			item.execute();
		}

		private function handleError(event : LoaderEvent) : void {
			dispatchEvent(event);
			_status = STATUS_READY;
			loadNext();
		}

		private function handleComplete(event : LoaderEvent) : void {
			dispatchEvent(event);
			_status = STATUS_READY;
			loadNext();
		}
	}
}