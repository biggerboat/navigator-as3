package com.epologee.puremvc.facade {
	import com.epologee.development.logging.debug;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class SimpleFacade extends Facade {
		private var _timeline : Sprite;

		public function SimpleFacade(inTimeline : Sprite, inKey : String = "") {
			_timeline = inTimeline;
			super(inKey ? inKey : getQualifiedClassName(this));
		}

		/**
		 * Creates a new Sprite as a layer for use with new TimelineMediators.
		 * If a @param inParentTimeline is supplied, it will be used to call addChild on
		 * Thus the newly created layer is a child of the parameter.
		 */
		protected function createLayer(inParentTimeline:DisplayObjectContainer = null) : Sprite {
			if (inParentTimeline) {
				return inParentTimeline.addChild(new Sprite()) as Sprite;
			}
			
			return _timeline.addChild(new Sprite()) as Sprite;
		}
		
		public function get timeline() : Sprite {
			return _timeline;
		}
	}
}
