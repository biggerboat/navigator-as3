package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface ITraceable {
		function critical(message:* = ""):void;
		function debug(message:* = ""):void;
		function error(message:* = ""):void;
		function fatal(message:* = ""):void;
		function info(message:* = ""):void;
		function notice(message:* = ""):void;
		function warn(message:* = ""):void;
	}
}
