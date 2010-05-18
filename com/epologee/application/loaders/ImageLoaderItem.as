package com.epologee.application.loaders {
	import flash.display.Bitmap;
	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ImageLoaderItem extends LoaderItem {
		private var _image : Bitmap;

		public function ImageLoaderItem(inURL : String, inCompleteHandler : Function = null, inProgressHandler : Function = null, inAutoExecute:Boolean = false) {
			super(inURL, LoaderItem.VISUAL, inCompleteHandler, inProgressHandler, inAutoExecute);
		}

		public function get responseAsBitmap() : Bitmap {
			return _image;
		}

		override protected function handleComplete(event : Event) : void {
			try {
				_image = Bitmap(_visualLoader.content);
			} catch (ei : Error) {
				_status = STATUS_FAILED;
				cleanupListeners();
				var le : LoaderEvent = new LoaderEvent(LoaderEvent.ERROR, this);
				le.errorMessage = ei.message + " (file is not an image)";
				dispatchEvent(le);
				return;
			}
			
			super.handleComplete(event);
		}
	}
}
