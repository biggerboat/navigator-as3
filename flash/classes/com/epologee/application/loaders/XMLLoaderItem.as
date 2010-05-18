package com.epologee.application.loaders {
	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class XMLLoaderItem extends LoaderItem {
		private var _xml : XML;

		public function XMLLoaderItem(inURL : String, inCompleteHandler : Function = null, inProgressHandler : Function = null, inAutoExecute:Boolean = false) {
			super(inURL, LoaderItem.TEXTUAL, inCompleteHandler, inProgressHandler, inAutoExecute);
		}

		public function get responseAsXML() : XML {
			return _xml;		
		}

		override protected function handleComplete(event : Event) : void {
			try {
				_xml = new XML(_textLoader.data);
			} catch (ei : Error) {
				_status = STATUS_FAILED;
				cleanupListeners();
				var le : LoaderEvent = new LoaderEvent(LoaderEvent.ERROR, this);
				le.errorMessage = ei.message + " (probably malformed XML)";
				dispatchEvent(le);
				return;
			}
			
			super.handleComplete(event);
		}
	}
}
