package  com.epologee.development.guides {
	import com.epologee.animation.bitmap.TiledImage;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * @author Eric-Paul Lecluse <e@epologee.com>
	 */
	public class DesignGuide extends Sprite {
		private var _map : Bitmap;
		private var _alpha : Number;
		private var _cross : Sprite;
		private var _dragging : Sprite;

		public function DesignGuide(inGuideMap : BitmapData, inOffsetX : int = 0, inOffsetY : int = 0, inStripeAlpha : Number = 0.3, inGuideAlpha : Number = 0.5) {
			super();
			
			if (inGuideMap != null) {
				alpha = _alpha = inGuideAlpha;
			
				_map = new Bitmap(inGuideMap);
				_map.x = -inOffsetX;
				_map.y = -inOffsetY;
				addChild(_map);

				if (inStripeAlpha > 0) {			
					var stripes : TiledImage = new TiledImage(new GuidePattern(), inGuideMap.width, inGuideMap.height);
					var alphaMap : BitmapData = new BitmapData(inGuideMap.width, inGuideMap.height, true, (inStripeAlpha * 0xFF) << 24);
					_map.bitmapData.copyPixels(stripes.bitmapData, stripes.bitmapData.rect, new Point(), alphaMap, new Point(), true);
					stripes.bitmapData.dispose();
					alphaMap.dispose();
				}
			}
			
			_cross = new Sprite();
			var g : Graphics = graphics;
			g.clear();
			g.beginFill(0xFF0000, 1);
			g.drawRect(-1, -1, 2, 2);
			g.endFill();		
			addChild(_cross);
			
			addEventListener(MouseEvent.CLICK, handleDebugClick);
//			handleDebugClick();
		}

		public function position(...inElements : Array) : void {
			var leni : int = inElements.length;
			for (var i : int = 0;i < leni;i++) {
				var dobj : DisplayObject = inElements[i] as DisplayObject;
				if (dobj is TextField) {
					positionTextField(dobj as TextField);
				} else if (dobj is Sprite) {
					positionSprite(dobj as Sprite);
				}
			}
		}

		public function positionSprite(inDesignElement : Sprite) : void {
			inDesignElement.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			inDesignElement.mouseChildren = false;
			
			new ResizeCorner(inDesignElement, inDesignElement.parent, inDesignElement.parent);
		}

		public function positionTextField(inElement : TextField) : void {
			var s : Sprite = new Sprite();
			inElement.parent.addChildAt(s, inElement.parent.getChildIndex(inElement));
			s.x = inElement.x;
			s.y = inElement.y;
			s.mouseChildren = false;
			
			inElement.x = 0;
			inElement.y = 0;
			s.addChild(inElement);
			
			s.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			
			new ResizeCorner(inElement, s.parent, s);
		}

		private function handleMouseDown(event : MouseEvent) : void {
			_dragging = event.target as Sprite;
			_dragging.startDrag();
			_dragging.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}

		private function handleMouseUp(event : MouseEvent) : void {
			_dragging.stopDrag();
			_dragging.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
			Logee.info("new position: .x = " + [_dragging.x + _dragging.parent.x, _dragging.y + _dragging.parent.y].join("; .y = ") + ";");
		}

		private function handleDebugClick(event : MouseEvent = null) : void {
			//			Logee.debug("handleDebugClick: "+[mouseX, mouseY]);
			alpha = alpha > 0 ? 0 : _alpha;
		}
	}
}

import com.epologee.logging.Logee;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class ResizeCorner extends Sprite {
	private var _target : DisplayObject;
	private var _container : DisplayObjectContainer;
	private var _relative : DisplayObject;

	public function ResizeCorner(inResizeTarget : DisplayObject, inContainer : DisplayObjectContainer, inRelativeTo : DisplayObject) {
		_target = inResizeTarget;
		_container = inContainer;
		_relative = inRelativeTo;
		
		draw();
		_container.addChild(this);
		
		_target.addEventListener(Event.ENTER_FRAME, realign);
		addEventListener(MouseEvent.MOUSE_DOWN, startResize);
	}

	private function realign(e : Event = null) : void {
		x = _target.x + _target.width + _relative.x;
		y = _target.y + _target.height + _relative.y;
	}

	private function startResize(event : MouseEvent) : void {
		removeEventListener(Event.ENTER_FRAME, realign);
		stage.addEventListener(MouseEvent.MOUSE_UP, stopResize);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, performResize);
		startDrag();
	}

	private function performResize(event : MouseEvent) : void {
		_target.width = x - _target.x - _relative.x;
		_target.height = y - _target.y - _relative.y;
	}

	private function stopResize(event : MouseEvent) : void {
		addEventListener(Event.ENTER_FRAME, realign);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stopResize);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, performResize);
		
		Logee.info("new dimensions: .width = " + [_target.width, _target.height].join("; .height = ") + ";");
	}

	private function draw() : void {
		var g : Graphics = graphics;
		g.clear();
		g.lineStyle(1, 0xFFFFFF, 0.3, false);
		g.moveTo(-_target.width, 0);
		g.lineTo(-2, 0);
		g.moveTo(0, -2);
		g.lineTo(0, -_target.height);
		g.beginFill(0x000000, 0.5);
		g.drawRect(-2, -2, 8, 8);
		g.endFill();
	}
}
