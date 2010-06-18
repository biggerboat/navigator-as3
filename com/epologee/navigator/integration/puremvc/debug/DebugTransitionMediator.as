package com.epologee.navigator.integration.puremvc.debug {
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
		private var _box : FormattedTextBox;
		private var _alignMode : String;

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
			_box = new FormattedTextBox("Arial", 12, 0xFF9900);
			_box.background = true;
			_box.backgroundColor = 0x222222;
			_box.wordWrap = false;
			_box.autoSize = TextFieldAutoSize.LEFT;
			_box.embedFonts = false;
			
			timeline.addChild(_box);
			timeline.addChild(new AlignStats(AlignStats.BOTTOM_RIGHT));
		}

		override public function listNotificationInterests() : Array {
			return [NavigationProxy.TRANSITION_STATUS_UPDATED, StageProxy.RESIZE];
		}

		override public function handleNotification(notification : INotification) : void {
			switch (notification.getName()) {
				case NavigationProxy.TRANSITION_STATUS_UPDATED:
					var statusByResponder : Dictionary = notification.getBody() as Dictionary;
					var s : String = "Current path: " + NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME)).development::navigator.getCurrentPath() + "\n";
					for (var key:* in statusByResponder) {
						var responder : INavigationResponder = key as INavigationResponder;
						s += TransitionStatus.toString(statusByResponder[responder]) + " " + responder + "\n";
					}
					_box.text = s;
					
				case StageProxy.RESIZE:
					layout(_box.stage.stageWidth, _box.stage.stageHeight);
					break;
			}
		}

		private function layout(inWidth : Number, inHeight : Number) : void {
			switch (_alignMode) {
				case "BL":
					_box.x = 10;
					_box.y = inHeight - _box.height - 10;
					break;
				case "TR":
					_box.x = inWidth - _box.width - 10;
					_box.y = 10;
					break;
			}
		}
	}
}
