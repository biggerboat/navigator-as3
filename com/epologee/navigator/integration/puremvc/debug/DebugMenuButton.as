package com.epologee.navigator.debug {
	import com.epologee.navigator.NavigationState;
	import com.epologee.ui.buttons.DrawnStateButtonBehavior;
	import com.epologee.ui.buttons.IHasDrawnStates;
	import com.epologee.ui.text.FormattedTextField;

	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugMenuButton extends Sprite implements IHasDrawnStates {
		private var _path : String;
		private var _label : FormattedTextField;

		public function DebugMenuButton(inPath : String) {
			_path = inPath;
			
			_label = new FormattedTextField("Arial", 12, 0, true, false);
			_label.embedFonts = false;
			_label.background = true;
			_label.backgroundColor = 0xCCCCCC;
			_label.border = true;
			_label.borderColor = 0x333333;
			_label.text = path;
			
			addChild(_label);
			
			new DrawnStateButtonBehavior(this);
		}

		public function get path() : String {
			return _path;
		}
		
		public function drawUpState() : void {
			_label.backgroundColor = 0xCCCCCC;
		}
		
		public function drawOverState() : void {
			_label.backgroundColor = 0xFFFFFF;
		}
		
		public function get state() : NavigationState {
			return new NavigationState(path);
		}
	}
}
