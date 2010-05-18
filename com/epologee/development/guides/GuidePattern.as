package com.epologee.development.guides {
	import flash.geom.Rectangle;
	import flash.display.BitmapData;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class GuidePattern extends BitmapData {
		public function GuidePattern() {
			super(16, 16, true, 0xFF000000);
			
			fillRect(new Rectangle(0, 0, 8, 8), 0xFFFFFFFF);
			fillRect(new Rectangle(8, 8, 8, 8), 0xFFFFFFFF);
		}
	}
}
