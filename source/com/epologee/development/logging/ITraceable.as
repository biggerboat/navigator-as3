package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface ITraceable {
		function critical(inMessage:* = ""):void;
		function debug(inMessage:* = ""):void;
		function error(inMessage:* = ""):void;
		function fatal(inMessage:* = ""):void;
		function info(inMessage:* = ""):void;
		function notice(inMessage:* = ""):void;
		function warn(inMessage:* = ""):void;
	}
}
