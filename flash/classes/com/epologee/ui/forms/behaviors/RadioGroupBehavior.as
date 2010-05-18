package com.epologee.ui.forms.behaviors {
	import com.epologee.logging.Logee;
	import com.epologee.ui.forms.components.FormElementEvent;
	import com.epologee.ui.forms.components.IRadioButtonElement;
	import com.epologee.ui.forms.components.IRadioGroupElement;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class RadioGroupBehavior {
		private var _elements : Array;
		private var _targetAsSprite : Sprite;
		private var _targetAsGroup : IRadioGroupElement;

		public function RadioGroupBehavior(inTarget : IRadioGroupElement) {
			_targetAsGroup = inTarget;
			_targetAsSprite = inTarget as Sprite;

			checkTimelineChildren();
			initialize();
		}

		private function checkTimelineChildren() : void {
			_elements = [];
			
			var leni : int = _targetAsSprite.numChildren;
			for (var i : int = 0;i < leni;i++) {
				var element : DisplayObject = _targetAsSprite.getChildAt(i);
				if (element is IRadioButtonElement) {
					_elements.push(element);
				}
			}
		}

		private function initialize() : void {
			_targetAsGroup.addEventListener(FormElementEvent.VALUE_CHANGED, handleGroupValueChanged);
			
			var leni : int = _elements.length;
			for (var i : int = 0;i < leni;i++) {
				var element : IRadioButtonElement = _elements[i] as IRadioButtonElement;
				element.value = element.defaultValue;
				element.addEventListener(FormElementEvent.ELEMENT_SELECTED, handleRadioSelected);
			}		
		}

		private function handleGroupValueChanged(event : FormElementEvent) : void {
			var leni : int = _elements.length;
			var element : IRadioButtonElement;
			for (var i : int = 0;i < leni;i++) {
				element = _elements[i] as IRadioButtonElement;
				if (_targetAsGroup.value == element.value) {
					element.turnOn();
					return;
				}
			}				

			for (i = 0;i < leni;i++) {
				element = _elements[i] as IRadioButtonElement;
				element.turnOff();
			}				
		}

		private function handleRadioSelected(event : FormElementEvent) : void {
			var currentElement : IRadioButtonElement = event.target as IRadioButtonElement;
			if (currentElement.isOn) {
				var leni : int = _elements.length;
				for (var i : int = 0;i < leni;i++) {
					var element : IRadioButtonElement = _elements[i] as IRadioButtonElement;
					if (element == currentElement) {
						_targetAsGroup.value = element.value;
					} else {
						element.turnOff();
					}
				}	
			}
		}
	}
}
