package com.epologee.navigator.integration.puremvc.debug {
	import com.epologee.development.stats.AlignStats;
	import com.epologee.navigator.integration.debug.DebugStatusDisplay;
	import com.epologee.navigator.integration.puremvc.NavigationProxy;
	import com.epologee.navigator.integration.puremvc.development;
	import com.epologee.puremvc.view.TimelineMediator;

	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugTransitionMediator extends TimelineMediator {
		public static const NAME : String = getQualifiedClassName(DebugTransitionMediator);
		private var _alignMode : String;
		private var _display : DebugStatusDisplay;

		/**
		 * @param inContainer pass in a Sprite, otherwise the container getter will fail.
		 */
		public function DebugTransitionMediator(inTimeline : Sprite, inAlignMode : String = "BR") {
			super(NAME, inTimeline);
			_alignMode = inAlignMode;
		}

		override public function onRegister() : void {
			var np : NavigationProxy = NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME));
			_display = new DebugStatusDisplay(np.development::navigator, _alignMode);

			timeline.addChild(new AlignStats(AlignStats.BOTTOM_LEFT));
			timeline.addChild(_display);
		}
	}
}
