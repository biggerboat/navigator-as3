package com.epologee.util {
	import com.epologee.logging.Logee;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class DefaultHandlers {
		public static var verbose : Boolean = true;

		public static function addNetStreamListeners(inNetStreamInstance : IEventDispatcher) : void {
			inNetStreamInstance.addEventListener(Event.ACTIVATE, handleNetstreamEvent);
			inNetStreamInstance.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleNetstreamEvent);
			inNetStreamInstance.addEventListener(Event.DEACTIVATE, handleNetstreamEvent);
			inNetStreamInstance.addEventListener(IOErrorEvent.IO_ERROR, handleNetstreamEvent);
			inNetStreamInstance.addEventListener(NetStatusEvent.NET_STATUS, handleNetstreamEvent);
		}

		private static function handleNetstreamEvent(event : Event) : void {
			if (verbose) {
				Logee.debug("handleNetstreamEvent: " + event.type, "com.epologee.util.DefaultHandlers");
			}
		}
	}
}
