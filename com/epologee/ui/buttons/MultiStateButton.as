package com.epologee.ui.buttons {
	import com.epologee.util.stage.IInitializable;
	import com.epologee.util.stage.StageDetector;

	import flash.display.MovieClip;
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
	public class MultiStateButton extends MovieClip implements IInitializable {
		//
		// timeline instances
		public var tAlternativeState : MovieClip;
		public var tRegularState : MovieClip;
		public var tHitArea : MovieClip;
		//
		private var _isInitialized : Boolean;
		private var _behavior : MultiStateBehavior;
		private var _instantly : Boolean;

		/**
		 * @param inStartInstantly can be used if you extend this class and you want to be able to delay the button's start behavior. Call the start() method for that. 
		 */
		public function MultiStateButton(inStartInstantly : Boolean = true) {
			super();
			
			_instantly = inStartInstantly;
			StageDetector.initializeOnce(this);
		}
		
		public function isInitialized() : Boolean {
			return _isInitialized;
		}
		
		public function initialize() : void {
			_isInitialized = true;
			_behavior = new MultiStateBehavior(this, _instantly, dispatchEvent);
		}

		public function destroy() : void {
			_isInitialized = false;
		}

		public function showAlternativeState(inShow : Boolean) : void {
			_behavior.showAlternativeState(inShow);
		}

		public function show() : void {
			_behavior.show();
		}
		public function hide() : void {
			_behavior.hide();
		}
		public function enable() : void {
			_behavior.enable();
		}
		public function disable(inDisabledMouseState : int = -1) : void {
			_behavior.disable(inDisabledMouseState);
		}
		override public function toString() : String {
			// com.epologee.ui.buttons.MultiStateButton
			var s : String = "";
			s = "[ " + name + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}