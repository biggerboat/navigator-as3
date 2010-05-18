package com.epologee.ui.buttons {
	import com.epologee.logging.Logee;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * COPYRIGHT NOTICE: Yes, you may use this class, but I'd be really pleased if you 
	 * leave this copyright notice where it is and if you use the epologee package as
	 * supplied. If you're happy with the class, let me know!
	 * 
	 * @author Eric-Paul Lecluse | epologee.com (c) 2009
	 * @see http://epologee.com
	 * 
	 * The Multi State Button
	 * 
	 * This class is an attempt to create the one-stop-button class for 
	 * pretty much all animation uses. It provides the designer with a
	 * scalable complexity of the button's timeline. The animation is 
	 * driven by labeled keyframes in the timeline.
	 *  
	 * The button may start out without any keyframes and later be enhanced
	 * with up to nine labeled keyframes. There should be NO scripts that affect the
	 * position of the playhead (stops, gotoAnd...) in the button's timeline.
	 * After that, the designer may decide what other states need to be 
	 * visualized in the animation chain:
	 * 
	 * 		[intro]      [in]        [press]
	 * 			   \    •    \      •       \
	 * 			    •  /      •    /         •
	 * 		        [up]      [over]         [down]
	 * 		       /   •     /      •       /
	 * 		      •     \   •        \     • 
	 * 		[outtro]    [out]       [release]
	 * 		
	 * 	If any of these keyframes are missing, the flow will skip over them
	 * 	to the next possible keyframe. So it would be possible to have just
	 * 	a simple setup like this:
	 * 	
	 * 		        [up] ---• [over] ---• [down]
	 *
	 *	Or one with a hard down state, but with an animated in and out sequence. 
	 * 
	 * 		             [in]        
	 * 			        •    \   
	 * 			       /      •  
	 * 		        [up]      [over] ---• [down]
	 * 		           •     /   
	 * 		            \   •     
	 * 		            [out]    
	 *	 
	 * Mouse activity is stacked, in order to maintain a fluid experience of 
	 * the button's animation flow. In lengthy animated buttons this may very
	 * soon become irritating. 
	 * 
	 */
	public class MultiStateBehavior extends EventDispatcher implements IEnableDisable {
		protected static const LABEL_INTRO : String = "intro";
		protected static const LABEL_UP : String = "up";
		protected static const LABEL_IN : String = "in";
		protected static const LABEL_OVER : String = "over";
		protected static const LABEL_PRESS : String = "press";
		protected static const LABEL_DOWN : String = "down";
		protected static const LABEL_RELEASE : String = "release";
		protected static const LABEL_OUT : String = "out";
		protected static const LABEL_OUTRO : String = "outro";
		//
		public static const MOUSE_INACTIVE : int = -1;
		public static const MOUSE_OUT : int = 0;
		public static const MOUSE_OVER : int = 1;
		public static const MOUSE_DOWN : int = 2;
		//
		// member instances
		private var _mouseState : int;
		private var _mouseStack : Array = [];
		private var _isEnabled : Boolean;
		private var _playingLabel : String;
		private var _lastFrame : int;
		private var _timeline : MovieClip;
		private var _hitArea : Sprite;
		private var _alternativeState : Sprite;

		public function get timeline() : MovieClip {
			return _timeline;
		}

		/**
		 * @param inShowInstantly can be used if you extend this class and you want to be able to delay the button's start behavior. Call the show() method for that. 
		 * @param inDefaultClickHandler will have the provided method listen to the MultiStateEvent.CLICK method.
		 */
		public function MultiStateBehavior(inButton : MovieClip, inShowInstantly : Boolean = true, inDefaultClickHandler:Function = null) {
			_timeline = inButton;
			
			if (!_timeline) {
				Logee.error("MultiStateBehavior: param inButton can't be null!");
				//debug stacktrace
				var linesi:uint = 3;
				Logee.debug("MultiStateBehavior [stacktrace]:\n" + Error(new Error()).getStackTrace().split("\n").slice(1,linesi+1).join("\n"), toString());
				return;
			}
			
			// don't handle mouse events on children
			_timeline.mouseChildren = false;
			
			// set and hide hit area
			try {
				_hitArea = _timeline.tHitArea;
				_timeline.hitArea = _hitArea;
				_hitArea.visible = false;
			} catch (e : Error) {
				_hitArea = new Sprite();
			}
			
			try {
				_alternativeState = _timeline.tAlternativeState;
			} catch (e : Error) {
			}
			if (_alternativeState == null) {
				_alternativeState = new Sprite();
			}
			_alternativeState.visible = false;
			
			_timeline.stop();
						
			_timeline.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			_timeline.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			_timeline.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			_timeline.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			_timeline.addEventListener(MouseEvent.CLICK, handleClick);
			
			// If the instance name of the button ends with "Paused", the button
			// will not start instantly, even if the boolean inStartInstantly is passed as true.
			if (inShowInstantly && _timeline.name.substr(-6) != "Paused") {
				if (_timeline.stage) {
					handleAddedToStage();
				} else {
					_timeline.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
				}			
			}
			
			if (inDefaultClickHandler != null) {
				addEventListener(MultiStateEvent.CLICK, inDefaultClickHandler);
			}
		}

		/**
		 *	This method serves as a way to enable a button to have a special state. Like an active button, a current tab or a lit light.
		 *	Draw your alternative state in a movieclip on the button's timeline and call it "tAlternativeState".
		 *	The state needs to be set publicly from outside this class.
		 *	
		 *	If there is a tRegularState on the timeline, it will be set to the opposite visibility. Great for toggling views.
		 *	@param inShow decides whether to show (true) or hide (false) the alternative state 
		 */
		public function showAlternativeState(inShow : Boolean) : void {
			if (inShow && _alternativeState) {
				_alternativeState.visible = true;
			} else if (_alternativeState) {
				_alternativeState.visible = false;
			}
			
			if (_alternativeState && _timeline.tRegularState) {
				_timeline.tRegularState.visible = !_alternativeState.visible;
			}
		}

		public function show() : void {
			enable();
			jumpToLabel(LABEL_INTRO);
		}

		public function hide() : void {
			disable();
			jumpToLabel(LABEL_OUTRO);
		}

		public function enable() : void {
			_isEnabled = true;
			_timeline.buttonMode = true;
			_timeline.mouseEnabled = true;
		}

		public function disable() : void {
			_isEnabled = false;
			_timeline.buttonMode = false;
			_timeline.mouseEnabled = false;
		}

		protected function handleAddedToStage(event : Event = null) : void {
			show();
		}

		/**
		 *	used to be onRollOver
		 */
		protected function handleRollOver(event : MouseEvent) : void {
			if (_isEnabled) {
				stackMouse(MOUSE_OVER);
				dispatchEvent(new MultiStateEvent(MultiStateEvent.MOUSE_OVER));
			} else {
				event.stopImmediatePropagation();
			}		
		}

		/**
		 *	used to be onRollOut 
		 */
		protected function handleRollOut(event : MouseEvent) : void {
			if (_isEnabled) {
				stackMouse(MOUSE_OUT);
				dispatchEvent(new MultiStateEvent(MultiStateEvent.MOUSE_OUT));
			} else {
				event.stopImmediatePropagation();
			}		
		}

		/**
		 *	used to be onPress
		 */
		protected function handleMouseDown(event : MouseEvent) : void {
			if (_isEnabled) {
				stackMouse(MOUSE_DOWN);
				dispatchEvent(new MultiStateEvent(MultiStateEvent.MOUSE_DOWN));
			} else {
				event.stopImmediatePropagation();
			}		
		}

		/**
		 *	used to be onRelease
		 */
		protected function handleMouseUp(event : MouseEvent) : void {
			if (_isEnabled) {
				stackMouse(MOUSE_OVER);
				dispatchEvent(new MultiStateEvent(MultiStateEvent.MOUSE_UP));
			} else {
				event.stopImmediatePropagation();
			}
		}

		private function handleClick(event : MouseEvent) : void {
			if (!_isEnabled) {
				event.stopImmediatePropagation();
			}
			
			dispatchEvent(new MultiStateEvent(MultiStateEvent.CLICK));
		}

		/**
		 *	Stacks all mouse states in chronological order, so 
		 *	the states are always animated through correctly.
		 *	After stacking, the first state may be processed.
		 *	@param inState: The numeric mouse state.
		 */
		protected function stackMouse(inState : int) : void {
			_mouseState = inState;
			_mouseStack.push(_mouseState);
			processStack();
		}

		/**
		 *	Shifts the next element off the stack and processes its value
		 *	for label jumps. This method ensures that there are no funny skips
		 *	in an animated uberstatebutton when the user is in a mouse-rage. ;)
		 */
		protected function processStack() : void {
			if (_playingLabel == null && _mouseStack.length) {
				var processedState : int = int(_mouseStack.shift());
			
				if (processedState == _mouseState && _mouseStack[0] != processedState) {
					// clear the rest of the stack if the current processed state 
					// is where we need to end up anyway.
					_mouseStack = []; 
				}
			
				switch(processedState) {
					case MOUSE_OVER:
						if (_timeline.currentLabel == LABEL_UP) {
							jumpToLabel(LABEL_IN);
						} else if (_timeline.currentLabel == LABEL_DOWN) {
							jumpToLabel(LABEL_RELEASE);
						}
						break;
					case MOUSE_OUT:
						if (_timeline.currentLabel == LABEL_OVER) {
							jumpToLabel(LABEL_OUT);
						} else if (_timeline.currentLabel == LABEL_DOWN) {
							jumpToLabel(LABEL_RELEASE);
						}
						break;
					case MOUSE_DOWN:
						jumpToLabel(LABEL_PRESS);
						break;
				}
			}
		}

		/**
		 *	Checks for changes in the labels onEnterFrame.
		 *	If there is a change, the jump is initiated before the frame state is redrawn to the stage.
		 */
		protected function checkTimelineLabel(e : Event) : void {
			if (_playingLabel != _timeline.currentLabel || (_lastFrame == _timeline.totalFrames && _timeline.currentFrame == 1)) {
				jump();
			}
			_lastFrame = _timeline.currentFrame;
		}

		/**
		 *	Decides where to jump the playhead to, based on the label of the previous frame.
		 */
		protected function jump() : void {
			// label of the previous frame.
			var l : String = getPreviousLabel();
			switch (l) {
				case LABEL_INTRO:
				case LABEL_OUT:
					jumpToLabel(LABEL_UP);
					break;
				case LABEL_IN:
				case LABEL_RELEASE:
					jumpToLabel(LABEL_OVER);
					break;
				case LABEL_PRESS:
					jumpToLabel(LABEL_DOWN);
					break;
				case LABEL_OUTRO:
					_timeline.stop();//gotoAndStop(mLastFrame);
					notifyOuttroDone();
					break;
			}
		}

		/**
		 *	this method decides which other method will be called to visualize the jump.
		 *	if the preferredLabel exists in the timeline, it may be used for the visual,
		 *	otherwise the next possible label is sought for.
		 */
		protected function jumpToLabel(preferredLabel : String, originalLabel : String = null) : void {
			if (originalLabel == null) {
				originalLabel = preferredLabel;
			}
		
			if (labelExists(preferredLabel)) {
				jumpToExistingLabel(preferredLabel);
			} else {
				jumpToNextPossibleLabel(preferredLabel, originalLabel); 
			}
		}	

		/** 
		 * logic when the preferredLabel doesn't exist in the timeline.
		 * needs not check LABEL_UP, because that one always exists.
		 */
		protected function jumpToNextPossibleLabel(preferredLabel : String, originalLabel : String) : void {
			switch(preferredLabel) {
				case LABEL_INTRO:
					jumpToLabel(LABEL_UP, originalLabel);
					break;
				case LABEL_IN:
					jumpToLabel(LABEL_OVER, originalLabel);
					break;
				case LABEL_OVER:
					jumpToLabel(LABEL_OUT, originalLabel);
					break;
				case LABEL_PRESS:
					jumpToLabel(LABEL_DOWN, originalLabel);
					break;
				case LABEL_DOWN:
					jumpToLabel(LABEL_RELEASE, originalLabel);
					break;
				case LABEL_RELEASE:
					jumpToLabel(LABEL_OVER, originalLabel);
					break;
				case LABEL_OUT:
					jumpToLabel(LABEL_UP, originalLabel);
					break;
				case LABEL_OUTRO:
					notifyOuttroDone();
					break;
			}
		}

		protected function notifyOuttroDone() : void {
			_timeline.removeEventListener(Event.ENTER_FRAME, checkTimelineLabel);
		}

		/**
		 *	expects the label to be present in the timeline and jumps to it either by stopping or not.
		 */
		protected function jumpToExistingLabel(existingLabel : String) : void {
			switch(existingLabel) {
				case LABEL_UP:
				case LABEL_OVER:
				case LABEL_DOWN:
					stopAt(existingLabel);
					break;
				case LABEL_INTRO:
				case LABEL_IN:
				case LABEL_PRESS:
				case LABEL_RELEASE:
				case LABEL_OUT:
				case LABEL_OUTRO:
					continueTo(existingLabel);
					break;
			}
		}

		/**
		 *	
		 */
		protected function stopAt(label : String) : void {
			_playingLabel = null;
			_timeline.removeEventListener(Event.ENTER_FRAME, checkTimelineLabel);
			// waarom niet delete onEnterFrame?
			_timeline.gotoAndStop(label);
		
			processStack();
		}

		/**
		 *	
		 */
		protected function continueTo(label : String) : void {
			_playingLabel = label;
			_timeline.addEventListener(Event.ENTER_FRAME, checkTimelineLabel);
		
			// the combination of gotoAndStop() and play() ensures that the 
			// first frame of the preferred jump is actually drawn to the stage.
			if (_timeline.currentLabel != label) {
				_timeline.gotoAndStop(label);
			}
			_timeline.play();
		}

		protected function labelExists(inCheckLabel : String) : Boolean {
			var i : uint;
			var leni : uint = _timeline.currentLabels.length;
			for (i = 0;i < leni;i++) {
				var fl : FrameLabel = FrameLabel(_timeline.currentLabels[i]);
				if (inCheckLabel == fl.name) return true;
			}
			return false;
		}

		protected function getPreviousLabel() : String {
			var i : uint;
			var leni : uint = _timeline.currentLabels.length;
			
			// set lastLabel to the right most label in the timeline.
			var lastLabel : String = FrameLabel(_timeline.currentLabels[leni - 1]).name;
			
			for (i = 0;i < leni;i++) {
				var fl : FrameLabel = FrameLabel(_timeline.currentLabels[i]);
				if (fl.frame >= _timeline.currentFrame) return lastLabel;
				lastLabel = fl.name;
			}
			
			return "";
		}

		override public function toString() : String {
			// com.epologee.ui.buttons.MultiStateButton
			var s : String = "";
//			s = "[ " + _timeline.name + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}