package com.epologee.navigator.integration.debug {
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.NavigatorEvent;
	import com.epologee.navigator.integration.puremvc.development;
	import com.epologee.navigator.states.IHasStateInitialization;
	import com.epologee.navigator.states.IHasStateTransition;
	import com.epologee.navigator.states.INavigationResponder;
	import com.epologee.navigator.transition.TransitionStatus;
	import com.epologee.ui.text.FormattedTextBox;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugStatusDisplay extends Sprite {
		private var _boxLeft : FormattedTextBox;
		private var _boxRight : FormattedTextBox;
		private var _navigator : Navigator;
		private var _alignMode : String;

		public function DebugStatusDisplay(inNavigator : Navigator, inAlignMode : String = "BL") {
			_navigator = inNavigator;
			_alignMode = inAlignMode;

			_boxLeft = new FormattedTextBox("Arial", 12, 0xFF9900);
			_boxLeft.background = true;
			_boxLeft.backgroundColor = 0x222222;
			_boxLeft.wordWrap = false;
			_boxLeft.autoSize = TextFieldAutoSize.LEFT;
			_boxLeft.embedFonts = false;

			_boxRight = new FormattedTextBox("Arial", 12, 0xFF9900);
			_boxRight.background = true;
			_boxRight.backgroundColor = 0x222222;
			_boxRight.wordWrap = false;
			_boxRight.autoSize = TextFieldAutoSize.NONE;
			_boxRight.width = 110;
			_boxRight.embedFonts = false;

			addChild(_boxLeft);
			addChild(_boxRight);

			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}

		private function handleAddedToStage(event : Event) : void {
			_navigator.addEventListener(NavigatorEvent.TRANSITION_STATUS_UPDATED, handleStatusUpdated);
			stage.addEventListener(Event.RESIZE, handleStageResize);
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			updateDisplay(_navigator.development::statusByResponder);
			layout(stage.stageWidth, stage.stageHeight);
		}

		private function handleStageResize(event : Event) : void {
			layout(stage.stageWidth, stage.stageHeight);
		}

		private function handleStatusUpdated(event : NavigatorEvent) : void {
			updateDisplay(event.statusByResponder);
			layout(stage.stageWidth, stage.stageHeight);
		}

		private function updateDisplay(inStatusByResponder:Dictionary) : void {
			var sLeft : String = "<font color=\"#AAAAAA\">Path: <font color=\"#00FF00\"><b>" + _navigator.getCurrentPath() + "</b></font></font>\n";
			var sRight : String = "\n";

			for (var key:* in inStatusByResponder) {
				var responder : INavigationResponder = key as INavigationResponder;
				if (responder is IHasStateTransition || responder is IHasStateInitialization) {
					sLeft += responder + " \t\n";
					var color : String = getColorByStatus(inStatusByResponder[responder]);
					sRight += "<font color=\"" + color + "\"><b>" + TransitionStatus.toString(inStatusByResponder[responder]) + "</b></font>\n";
				}
			}
			_boxLeft.text = sLeft;
			_boxRight.text = sRight;
			_boxRight.height = _boxLeft.height;
		}


		private function getColorByStatus(inStatus : int) : String {
			var color : String = "";

			switch(inStatus) {
				case TransitionStatus.UNINITIALIZED:
					color = "#AAAAAA";
					break;
				case TransitionStatus.INITIALIZED:
					color = "#FFFFFF";
					break;
				case TransitionStatus.HIDDEN:
					color = "#FF0000";
					break;
				case TransitionStatus.APPEARING:
				case TransitionStatus.DISAPPEARING:
					color = "#FFFF00";
					break;
				case TransitionStatus.SHOWN:
					color = "#00FF00";
					break;
			}

			return color;
		}

		private function layout(inWidth : Number, inHeight : Number) : void {
			switch (_alignMode) {
				case "BR":
					_boxRight.x = inWidth - _boxRight.width - 10;
					_boxRight.y = inHeight - _boxRight.height - 10;
					_boxLeft.x = _boxRight.x - _boxLeft.width;
					_boxLeft.y = _boxRight.y;
					break;
				case "BL":
					_boxLeft.x = 10;
					_boxLeft.y = inHeight - _boxLeft.height - 10;
					_boxRight.x = _boxLeft.x + _boxLeft.width;
					_boxRight.y = _boxLeft.y;
					break;
				case "TR":
					_boxRight.x = inWidth - _boxRight.width - 10;
					_boxRight.y = 10;
					_boxLeft.x = _boxRight.x - _boxLeft.width;
					_boxLeft.y = _boxRight.y;
					break;
			}
		}
	}
}
