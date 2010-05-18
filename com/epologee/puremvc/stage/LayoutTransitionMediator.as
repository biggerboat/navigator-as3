package com.epologee.puremvc.stage {
	import com.epologee.puremvc.navigation.NavigationProxy;
	import com.epologee.puremvc.navigation.TransitionMediator;
	import com.epologee.puremvc.navigation.TransitionStatus;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * The layout transition mediator requires a setup where both the NavigationProxy and the StageProxy are set up.
	 * Override the layout() method to have automated layout response when the stage resizes.
	 */
	public class LayoutTransitionMediator extends TransitionMediator {
		public function LayoutTransitionMediator(inName : String, inTimeline : Sprite) {
			super(inName, inTimeline);
		}

		override public function listNotificationInterests() : Array {
			return super.listNotificationInterests().concat(StageProxy.RESIZE);
		}

		override public function initialize() : void {
			super.initialize();

			layout(stage.stageWidth, stage.stageHeight);
		}

		override public function handleNotification(notification : INotification) : void {
			if (notification.getName() != StageProxy.RESIZE) return;
			
			// call layout when the stage is resized and the responder is showing.
			if (status > TransitionStatus.HIDDEN) {
				var size : Point = Point(notification.getBody());
				layout(size.x, size.y);
			}
		}

		/**
		 * This is the method you override for your own custom layout.
		 */
		protected function layout(inStageWidth : Number, inStageHeight : Number) : void {
		}

		protected function get stage() : Stage {
			return StageProxy(facade.retrieveProxy(StageProxy.NAME)).stage;
		}

		protected function get status() : int {
			return NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME)).getStatus(this);
		}
	}
}
