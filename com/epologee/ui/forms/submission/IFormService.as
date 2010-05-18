package com.epologee.ui.forms.submission {
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IFormService extends IEventDispatcher {
		function submit(data : Dictionary) : void;
	}
}
