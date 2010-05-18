package com.epologee.application.preloader.indicator {
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com (c) 2009
	 */
	public class SpinnerIcon extends Sprite {
		private static const PARTS : int = 12;
		private const SLOW : Number = 1;
		//		
		private var _wheel : Sprite;
		private var _radiusOutside : Number;
		private var _radiusInside : Number;
		private var _thickNess : Number;
		private var _color : uint;
		private var _block : Boolean;

		override public function set width(value : Number) : void {
			//
		}

		override public function get width() : Number {
			return _radiusOutside * 2;
		}

		override public function set height(value : Number) : void {
			//
		}

		override public function get height() : Number {
			return _radiusOutside * 2;
		}

		public function SpinnerIcon(inColor : uint = 0xFFFFFF, inRadiusOutside : Number = 20, inRadiusInside : Number = 10, inThickness : Number = 4, inShadowOffset : Number = 4) {
			_color = inColor;
			_radiusOutside = inRadiusOutside;
			_radiusInside = inRadiusInside;
			_thickNess = inThickness;
			
			_wheel = new Sprite();
			addChild(_wheel);

			var degrees : Number = 360 / PARTS;
			for (var i : int = 0;i < PARTS;i++) {
				addRay(-i * degrees, 1 - i / PARTS);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, startTurning);			
			addEventListener(Event.REMOVED_FROM_STAGE, stopTurning);
			
			blendMode = BlendMode.LAYER;	
			filters = [new DropShadowFilter(inShadowOffset, 45, 0, 1, inShadowOffset, inShadowOffset)];
		}

		public function startTurning(event : Event = null) : void {
			alpha = 0;
			addEventListener(Event.ENTER_FRAME, update);
		}

		public function stopTurning(event : Event = null) : void {
			removeEventListener(Event.ENTER_FRAME, update);
		}

		public function destroy() : void {
			while (numChildren) {
				removeChildAt(0);
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, startTurning);			
			removeEventListener(Event.REMOVED_FROM_STAGE, stopTurning);
			
			filters = [];
		}

		private function update(event : Event) : void {
			_block = !_block;
			alpha += 0.05;
			if (_block) return;
			
			_wheel.rotation += SLOW * 360 / PARTS ;
		}

		private function addRay(inAngle : Number, inAlpha : Number) : void {
			var ray : Sprite = new Sprite();
			ray.graphics.beginFill(_color, inAlpha);
			ray.graphics.drawRoundRect(-_thickNess / 2, -_radiusOutside, _thickNess, _radiusInside, _thickNess);
			ray.graphics.endFill();
			ray.rotation = inAngle;
			
			_wheel.addChild(ray);
		}

		override public function toString() : String {
			var s : String = "";
			// s = "[ " + name + " ]:";
			return s + getQualifiedClassName(this);
		}		
	}
}

