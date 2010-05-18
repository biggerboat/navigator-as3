package com.epologee.ui.text {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *	@author Jankees van Woezik - base42.nl
	 *	@author Eric-Paul Lecluse - epologee.com
	 *	
	 *	Originally, this was part of a TextField extension by Jankees.
	 *	Eric-Paul refactored it into this behavior class, with some minor additions.
	 *	Jankees for president!
	 */
	public class AutoTextBehavior {
		private var _textField : TextField;
		private var _maxFontSize : Number;
		private var _currentSize : Number;
		private var _prevText : String;
		private var _maxHeight : Number;
		private var _minFontSize : uint;

		public function set maxHeight(maxHeight : Number) : void {
			_maxHeight = maxHeight;
		}

		public function get maxFontSize() : Number {
			return _maxFontSize;
		}

		public function set maxFontSize(maxFontSize : Number) : void {
			_maxFontSize = maxFontSize;
		}

		public function set text(inText : String) : void {
			_prevText = inText;
			_textField.text = inText;
			update();
		}

		public function AutoTextBehavior(inTextField : TextField, inMaxFontSize : Number, inMinFontSize : uint = 32) {
			_minFontSize = inMinFontSize;
			_maxFontSize = inMaxFontSize;
			_currentSize = inMaxFontSize;
			_textField = inTextField;
 
			_maxHeight = _textField.height;
 
			_textField.addEventListener(KeyboardEvent.KEY_UP, update);
			_textField.addEventListener(Event.CHANGE, update);
			_textField.addEventListener(TextEvent.TEXT_INPUT, update);
			_textField.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
 
			setFontSize(_maxFontSize);
 
			update();
		}

		public function update(event : Event = null) : void {
			_textField.scrollV = 0;
			setFontSize(_maxFontSize);
 
			while (_maxHeight < _textField.textHeight + (4 * _textField.numLines)) { 
				if(_currentSize <= _minFontSize) break;
				setFontSize(_currentSize - 0.5);
			}
 
			if(_currentSize <= _minFontSize) {
				_textField.text = _prevText;
			} else {
				_prevText = _textField.text;
			}
		}

		private function setFontSize(inSize : Number) : void {
			_currentSize = inSize;
 
			var currentTextFormat : TextFormat = _textField.getTextFormat();
			currentTextFormat.size = _currentSize;
 
			_textField.setTextFormat(currentTextFormat);
			_textField.defaultTextFormat = currentTextFormat;
		}

		/**
		 * Dispose everything
		 */
		private function dispose(event : Event) : void {
			_textField.removeEventListener(KeyboardEvent.KEY_UP, update);
			_textField.removeEventListener(Event.CHANGE, update);
			_textField.removeEventListener(TextEvent.TEXT_INPUT, update);
			_textField.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
 
			_textField = null;
		}
	}
}
