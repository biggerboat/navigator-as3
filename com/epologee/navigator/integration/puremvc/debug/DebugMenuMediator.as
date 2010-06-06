package com.epologee.navigator.debug {
	import com.epologee.navigator.integration.puremvc.NavigationProxy;
	import com.epologee.navigator.integration.puremvc.development;
	import com.epologee.puremvc.view.TimelineMediator;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugMenuMediator extends TimelineMediator {
		public static const NAME : String = getQualifiedClassName(DebugMenuMediator);
		//
		private var _buttons : Array;

		public function DebugMenuMediator(inTimeline : Sprite) {
			super(NAME, inTimeline);
			_buttons = [];
		}

		override public function listNotificationInterests() : Array {
			return [NavigationProxy.RESPONDER_ADDED, NavigationProxy.RESPONDER_REMOVED];
		}

		override public function handleNotification(notification : INotification) : void {
			var np : NavigationProxy = NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME));

			while(_buttons.length) {
				removeChild(_buttons.pop());			
			}
			
			var x : int = 0;
			var paths : Array = np.development::navigator.getKnownPaths();
			for each (var path : String in paths) {
				var button : DebugMenuButton = new DebugMenuButton(path);
				button.x = x;
				x += button.width + 10;
				
				addChild(button);
				_buttons.push(button);
			}
			
			timeline.addEventListener(MouseEvent.CLICK, handleClick);
			timeline.x = 10;
			timeline.y = 10;
		}

		private function handleClick(event : MouseEvent) : void {
			var button : DebugMenuButton = event.target as DebugMenuButton;
			if (!button) return;
			
			var np : NavigationProxy = NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME));
			np.requestNewState(button.state);
		}
	}
}
