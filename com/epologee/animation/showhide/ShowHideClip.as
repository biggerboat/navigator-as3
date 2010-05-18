package com.epologee.animation.showhide {
	import com.epologee.animation.timeline.FrameChecker;
	import com.epologee.animation.timeline.FrameEvent;
	import com.epologee.animation.timeline.FrameStatus;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ShowHideClip extends Sprite implements IShowHide {
		public static const SHOW : String = "show";
		public static const HIDE : String = "hide";
		//
		protected var _timeline : MovieClip;
		private var _checker : FrameChecker;
		private var _isHiding : Boolean;

		public function ShowHideClip(inTimeline : MovieClip) {
			visible = false;
			
			_timeline = inTimeline;
			_timeline.stop();
			
			addChild(_timeline);
			
			_checker = new FrameChecker(_timeline);
			_checker.addEventListener(FrameEvent.STATUS_CHANGE, handleFrameStatusChanged);
		}

		public function isShowing() : Boolean {
			return visible;
		}

		public function show() : void {
			visible = true;
			gotoAndPlay(SHOW);
		}

		public function hide() : void {
			if (!isShowing()) return;
			
			if (_checker.getFirstFrameOf(HIDE) >= 0) {
				_isHiding = true;
				gotoAndPlay(HIDE);
			} else {
				_isHiding = false;
				visible = false;
				stop();
			}
		}

		public function gotoAndPlay(inFrame : Object) : void {
			_timeline.gotoAndPlay(inFrame);
			_checker.start();
		}

		public function stop() : void {
			_timeline.stop();
			_checker.stop();
		}

		protected function handleFrameStatusChanged(event : FrameEvent) : void {
			if (event.status & FrameStatus.LAST_FRAME) {
				if (event.label == HIDE) {
					visible = false;
				}
				_isHiding = false;
				stop();
				return;
			}
			
			if (event.status & FrameStatus.LABEL_CHANGE) {
				if (_timeline.currentLabel == HIDE && !_isHiding) {
					stop();
				}
				
//				var tce : TimelineCueEvent = new TimelineCueEvent(TimelineCueEvent.CUE);
//				tce.status = event.status;
//				tce.frame = _timeline.currentFrame;
//				tce.label = _timeline.currentLabel;
//				dispatchEvent(tce);
			}
		}
	}
}
