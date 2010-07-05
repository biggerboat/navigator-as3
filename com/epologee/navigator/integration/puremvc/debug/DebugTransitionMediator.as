package com.epologee.navigator.integration.puremvc.debug {
	import flash.text.StyleSheet;
	import flash.text.TextFormatAlign;

	import com.epologee.navigator.states.INavigationResponder;
	import com.epologee.development.stats.AlignStats;
	import com.epologee.navigator.integration.puremvc.NavigationProxy;
	import com.epologee.navigator.integration.puremvc.development;
	import com.epologee.navigator.states.IHasStateTransition;
	import com.epologee.navigator.transition.TransitionStatus;
	import com.epologee.puremvc.stage.StageProxy;
	import com.epologee.ui.text.FormattedTextBox;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugTransitionMediator extends Mediator {
		public static const NAME : String = getQualifiedClassName(DebugTransitionMediator);
		private var _boxLeft : FormattedTextBox;
		private var _alignMode : String;
		private var _boxRight : FormattedTextBox;

		/**
		 * @param inContainer pass in a Sprite, otherwise the container getter will fail.
		 */
		public function DebugTransitionMediator(inTimeline : DisplayObject, inAlignMode : String = "BL") {
			super(NAME, inTimeline);
			_alignMode = inAlignMode;
		}

		public function get timeline() : Sprite {
			return Sprite(viewComponent);
		}

		override public function onRegister() : void {
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
			
			timeline.addChild(_boxLeft);
			timeline.addChild(_boxRight);
			timeline.addChild(new AlignStats(AlignStats.BOTTOM_RIGHT));
		}

		override public function listNotificationInterests() : Array {
			return [NavigationProxy.TRANSITION_STATUS_UPDATED, StageProxy.RESIZE];
		}

		override public function handleNotification(notification : INotification) : void {
			switch (notification.getName()) {
				case NavigationProxy.TRANSITION_STATUS_UPDATED:
					var statusByResponder : Dictionary = notification.getBody() as Dictionary;
					var sLeft : String = "<font color=\"#AAAAAA\">Path: <font color=\"#00FF00\"><b>" + NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME)).development::navigator.getCurrentPath() + "</b></font></font>\n";
					var sRight : String = "\n";
					
					for (var key:* in statusByResponder) {
						var responder : INavigationResponder = key as INavigationResponder;
						sLeft += responder + " \t\n";
						var color : String = getColorByStatus(statusByResponder[responder]);
						sRight += "<font color=\"" + color + "\"><b>" + TransitionStatus.toString(statusByResponder[responder]) + "</b></font>\n";
					}
					_boxLeft.text = sLeft;
					_boxRight.text = sRight;
					_boxRight.height = _boxLeft.height;
					
					
				case StageProxy.RESIZE:
					layout(_boxLeft.stage.stageWidth, _boxLeft.stage.stageHeight);
					break;
			}
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
				case "BR":
					_boxRight.x = inWidth - _boxRight.width - 80;
					_boxRight.y = inHeight - _boxRight.height - 10;
					
					_boxLeft.x = _boxRight.x - _boxLeft.width;
					_boxLeft.y = _boxRight.y;
					break;
			}
		}
	}
}
