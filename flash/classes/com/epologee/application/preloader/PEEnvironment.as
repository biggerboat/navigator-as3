package com.epologee.application.preloader {
	import flash.display.DisplayObject;
	import com.epologee.application.environment.IEnvironmentManager;
	import com.epologee.logging.Logee;

	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class PEEnvironment extends AbstractPreloadElement {
		private var _environment : IEnvironmentManager;
		private var _timeline : DisplayObject;

		public function PEEnvironment(inTimeline:DisplayObject, inEnvironment : IEnvironmentManager) {
			_timeline = inTimeline;
			_environment = inEnvironment;
			super(1024);
		}

		override public function start() : void {
			_environment.initialize(_timeline, handleEnvironmentInitialized);
		}

		private function handleEnvironmentInitialized(e:Event) : void {
			progress = 1;
			dispatchReady();
		}	
	}
}
