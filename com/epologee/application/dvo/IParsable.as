package com.epologee.application.dvo {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IParsable extends IDataValueObject {
		function parseXML(inXML:XML) : void;
	}
}
