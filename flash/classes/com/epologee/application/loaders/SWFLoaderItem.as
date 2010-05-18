package com.epologee.application.loaders {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class SWFLoaderItem extends LoaderItem {
		private var _swf : Sprite;

		public function SWFLoaderItem(inURL : String, inCompleteHandler : Function = null, inProgressHandler : Function = null, inAutoExecute:Boolean = false) {
			super(inURL, LoaderItem.VISUAL, inCompleteHandler, inProgressHandler, inAutoExecute);
		}

		public function get responseAsSWF() : Sprite {
			return _swf;
		}

		override protected function handleComplete(event : Event) : void {
			try {
				_swf = Sprite(_visualLoader.content);
			} catch (ei : Error) {
				_status = STATUS_FAILED;
				cleanupListeners();
				var le : LoaderEvent = new LoaderEvent(LoaderEvent.ERROR, this);
				le.errorMessage = ei.message + " (file is not a SWF)";
				dispatchEvent(le);
				return;
			}
			
			super.handleComplete(event);
		}
	}
}
