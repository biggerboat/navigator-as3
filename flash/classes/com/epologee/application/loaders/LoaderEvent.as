package com.epologee.application.loaders {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class LoaderEvent extends Event {
		public static const COMPLETE : String = "COMPLETE";
		public static const ERROR : String = "ERROR";
		public static const PROGRESS : String = "PROGRESS";
		public static const STATUS_CHANGE : String = "STATUS_CHANGE";
		//
		// public properties:
		public var errorMessage : String;
		public var status : uint;
		private var _item : LoaderItem;

		public function get item() : LoaderItem {
			return _item;
		}

		public function LoaderEvent(inType : String, inItem : LoaderItem) {
			super(inType, true);
			_item = inItem;
		}

		override public function clone() : Event {
			var c : LoaderEvent = new LoaderEvent(type, _item);
			c.errorMessage = errorMessage;
			return c;
		}

		override public function toString():String {
			// com.epologee.data.loaders.LoaderEvent
			var s:String = "";
			// s = "[ " + name + " ]:";
			return s+getQualifiedClassName(this);
		}
	}
}
