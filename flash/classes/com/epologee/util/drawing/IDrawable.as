package com.epologee.util.drawing {
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IDrawable extends IEventDispatcher {
		function draw():void;
		function get parent():DisplayObjectContainer;
	}
}
