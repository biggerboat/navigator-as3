package com.epologee.ui.scrolling {
	import com.epologee.development.logging.debug;
	import com.epologee.ui.buttons.IEnableDisable;
	import com.epologee.ui.mouse.MouseFilter;
	import com.epologee.ui.mouse.MouseFilterEvent;
	import com.epologee.util.NumberUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * 1) Construct with two sprites and two (optional) arrow buttons.
	 * 2) Initialize with a window and content height, and an (optional) step size.
	 * 3) Update content and windowheight when needed.
	 * 
	 */
	public class ScrollBehavior extends EventDispatcher {
		public static const INCREASE : String = "INCREASE"; // "DOWN";
		public static const DECREASE : String = "DECREASE"; // "UP";
		//
		public static const LAYOUT_VERTICAL : String = "LAYOUT_VERTICAL";
		public static const LAYOUT_HORIZONTAL : String = "LAYOUT_HORIZONTAL";
		//
		// UI Elements
		private var _track : Sprite;
		private var _thumb : Sprite;
		private var _increase : IEnableDisable;
		private var _decrease : IEnableDisable;
		// Helper instances
		private var _bounds : Rectangle;
		private var _filter : MouseFilter;
		private var _enabled : Boolean;
		// Values
		/** the height of the scroll window, usually a mask. */
		private var _windowSize : Number;
		/** the height of the scrolling content, e.g. a large textfield's height. */
		private var _contentSize : Number;
		/** the height of a page relative to the content height */
		private var _pageSize : Number;
		/** the floating scroll value from 0 to 1. */
		private var _normalizedValue : Number;
		/** used to determine whether to dispatch an update event or not. */
		private var _lastNormalizedValue : Number;
		private var _layout : String;
		private var _isScrolling : Boolean;

		/**
		 * The scrollbehavior works by calculating the offset of a content pane based on the
		 * numerical height of the content and the window it is viewed through.
		 * The behavior does not modify the actual content's position, you need to use the
		 * getValueByContent or getValueByContentInverse. 
		 */
		public function ScrollBehavior(inTrack : Sprite, inThumb : Sprite, inDecrease : IEnableDisable = null, inIncrease : IEnableDisable = null) {
			_track = inTrack;
			_thumb = inThumb;
			_decrease = inDecrease;
			_increase = inIncrease;
		}

		public function reset() : void {
			normalizedValue = 0;
			updateFromNormalized();
		}

		/**
		 * The behavior needs initial dimensions of the window and content to be able to
		 * determine the height of the thumb within the track.
		 * @param inWindowHeight height of the window (usually same size as the mask)
		 * @param inContentHeight height of the content (usually some displayobject container)
		 * @param inPageSize amount of pixels per page-up/-down. FIXME: Not yet implemented
		 */
		public function initialize(inWindowSize : Number, inContentSize : Number, inPageSize : Number = 1, inLayout : String = LAYOUT_VERTICAL) : void {
			debug("inWindowSize: " + inWindowSize);
			debug("inContentSize: " + inContentSize);
			_layout = inLayout;
			setWindowSize(inWindowSize);
			setContentSize(inContentSize);
			setPageSize(inPageSize);
			
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, handleThumbDown);
		}

		public function isVertical() : Boolean {
			return _layout == LAYOUT_VERTICAL;
		}

		/** the height of the scroll window, usually a mask. */
		public function setWindowSize(inSize : Number) : void {
			_windowSize = inSize;
			
			updateThumbSize();
		}

		/** 
		 * the height of the scrolling content, e.g. a large textfield's height.
		 * @param inRovingValue if true, will correct the _normalizedValue and dispatch a SCROLL event.  
		 */
		public function setContentSize(inSize : Number) : void {
			if (inSize <= _windowSize) {
				normalizedValue = 0;
			} else {
				normalizedValue *= _contentSize / inSize;
			}

			_contentSize = inSize;
			updateThumbSize();
			updateFromNormalized();
			
			dispatchScroll(normalizedValue > 0);
		}

		/** the height of a page relative to the content height */		
		public function setPageSize(inSizeRelativeToContent : Number) : void {
			_pageSize = inSizeRelativeToContent;
		}

		public function page(inDirection : String) : void {
			var normalizedPageSize : Number;
			if (isVertical()) {
				normalizedPageSize = _pageSize / (_contentSize - _track.height);
			} else {
				normalizedPageSize = _pageSize / (_contentSize - _track.width);
			}
			
			if (inDirection == INCREASE) {
				normalizedValue += normalizedPageSize;
			} else {
				normalizedValue -= normalizedPageSize;
			}
			
			updateFromNormalized();
		}

		public function getValueByContent() : Number {
			return normalizedValue * (_contentSize - _windowSize);
		}

		public function getValueByContentInversed() : Number {
			return -getValueByContent();
		}

		public function setValueByContent(inValueByContent : Number) : void {
			// if this method is set from the outside while the user is scrolling,
			// it will produce scrolling errors.
			if (_isScrolling) return;
			
			normalizedValue = inValueByContent / (_contentSize - _windowSize);
			
			updateFromNormalized(false);
		}		

		public function disable() : void {
			if (_enabled === false) return;
			
			_enabled = false;

			if (_thumb is IEnableDisable) {
				IEnableDisable(_thumb).disable();
			}
			
			if (_track is IEnableDisable) {
				IEnableDisable(_track).disable();
			}

			if (_decrease is IEnableDisable) {
				_decrease.disable();
			}
			
			if (_increase is IEnableDisable) {
				_increase.disable();
			}
		}

		public function enable() : void {
			if (_enabled === true) return;
			
			_enabled = true;

			if (_thumb is IEnableDisable) {
				IEnableDisable(_thumb).enable();
			}
			
			if (_track is IEnableDisable) {
				IEnableDisable(_track).enable();
			}

			if (_decrease is IEnableDisable) {
				_decrease.enable();
			}
			
			if (_increase is IEnableDisable) {
				_increase.enable();
			}
		}

		private function handleThumbDown(event : MouseEvent) : void {
			_isScrolling = true;
			
			if (!_filter) {
				_filter = new MouseFilter(_thumb.stage);
			}
			
			_filter.addEventListener(MouseFilterEvent.INACTIVITY_TIMEOUT, handleThumbUp);
			_filter.addEventListener(MouseEvent.MOUSE_MOVE, handleThumbScroll);
			_filter.addEventListener(Event.MOUSE_LEAVE, handleThumbUp);
			_thumb.stage.addEventListener(MouseEvent.MOUSE_UP, handleThumbUp);
			_thumb.startDrag(false, _bounds);
		}

		private function handleThumbUp(event : Event = null) : void {
			_isScrolling = false;
			
			_filter.removeEventListener(MouseFilterEvent.INACTIVITY_TIMEOUT, handleThumbUp);
			_filter.removeEventListener(MouseEvent.MOUSE_MOVE, handleThumbScroll);
			_filter.removeEventListener(Event.MOUSE_LEAVE, handleThumbUp);
			_thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, handleThumbUp);
			_thumb.stopDrag();
		}

		private function handleThumbScroll(event : MouseEvent = null) : void {
			var ds : Number;
			if (isVertical()) {
				ds = _thumb.y - _track.y;
				normalizedValue = ds / _bounds.height;
			} else {
				ds = _thumb.x - _track.x;
				normalizedValue = ds / _bounds.width;
			}
			
			dispatchScroll();
		}

		private function updateFromNormalized(inDispatch : Boolean = true) : void {
			if (!_thumb || !_track || !_bounds) return;
			
			if (isVertical()) {
				_thumb.y = _track.y + normalizedValue * _bounds.height;
			} else {
				_thumb.x = _track.x + normalizedValue * _bounds.width;
			}

			if (inDispatch) {
				dispatchScroll();
			}
		}

		private function updateThumbSize() : void {
			if (isVertical()) {
				_thumb.height = Math.min(_track.height * _windowSize / _contentSize, _track.height);
				_bounds = new Rectangle(_thumb.x, _track.y, 0, Math.ceil(_track.height - _thumb.height));
			} else {
				_thumb.width = Math.min(_track.width * _windowSize / _contentSize, _track.width);
				_bounds = new Rectangle(_track.x, _thumb.y, Math.ceil(_track.width - _thumb.width), 0);
			}
			
			if (_windowSize >= _contentSize || !_contentSize) {
				disable();
			} else {
				enable();
			}
		}

		private function dispatchScroll(inForceDispatch : Boolean = false) : void {
			if (inForceDispatch || _lastNormalizedValue != normalizedValue) {		
				dispatchEvent(new ScrollBehaviorEvent(ScrollBehaviorEvent.SCROLL));
			}

			_lastNormalizedValue = normalizedValue;
		}

		public function get normalizedValue() : Number {
			return _normalizedValue;
		}

		public function set normalizedValue(inValue : Number) : void {
			_normalizedValue = NumberUtils.limit(inValue ? inValue : 0, 0, 1);
		}
	}
}
