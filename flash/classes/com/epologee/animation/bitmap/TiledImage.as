package com.epologee.animation.bitmap {
	import com.epologee.development.logging.notice;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TiledImage extends Bitmap {
		private var _tile : BitmapData;
		private var _tileRect : Rectangle;
		private var _width : int;
		private var _height : int;

		public function TiledImage(inTilePattern : BitmapData, inWidth : int, inHeight : int) {
			_width = inWidth;
			_height = inHeight;
			
			tile = inTilePattern;
		}

		public function set tile(inTilePattern : BitmapData) : void {
			_tile = inTilePattern;
			_tileRect = _tile.rect;
			
			update();
		}

		override public function set width(width : Number) : void {
			_width = width;
		}

		override public function set height(height : Number) : void {
			_height = height;
		}

		public function update(e : Event = null) : void {
			var raster : BitmapData = new BitmapData(_width, _height);
			raster.lock();

			var lenh : int = _width;
			var lenv : int = _height;
			var dest : Point = new Point(0, 0);
			for (var h : int = 0;h < lenh;h += _tileRect.width) {
				dest.x = h;
				for (var v : int = 0;v < lenv;v += _tileRect.height) {
					dest.y = v;
					raster.copyPixels(_tile, _tileRect, dest);
				}
			}			
			
			raster.unlock();
			if (bitmapData) {
				bitmapData.dispose();
			}
			bitmapData = raster;
		}
	}
}
