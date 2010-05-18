package com.epologee.puremvc.analytics {
	import com.epologee.development.logging.notice;
	import com.epologee.development.logging.warn;
	import com.epologee.puremvc.navigation.NavigationState;
	import com.google.analytics.GATracker;
	import com.google.analytics.core.TrackerMode;
	import com.google.analytics.v4.GoogleAnalyticsAPI;

	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class GoogleAnalyticsProxy extends Proxy {
		public static const NAME : String = getQualifiedClassName(GoogleAnalyticsProxy);
		//
		private static const FIRST_PAGE_VIEW : String = "app/flash";
		//
		private var _timeline : DisplayObjectContainer;
		private var _tracker : GoogleAnalyticsAPI;
		private var _pathPrefix : String;
		private var _account : String;

		public function GoogleAnalyticsProxy(inTimeline : DisplayObjectContainer, inAccount : String, inPathPrefix : String = "/") {
			super(NAME);
			_timeline = inTimeline;
			_account = inAccount;
			_pathPrefix = inPathPrefix;
		}

		override public function onRegister() : void {
			if (_account != null) {
				_tracker = new GATracker(_timeline, _account, TrackerMode.AS3, false);
			}
			
			trackPageview(FIRST_PAGE_VIEW);
		}

		public function trackPageview(inPath : String) : void {
			var path : String = new NavigationState(_pathPrefix + "/" + inPath).path;
			if (!_tracker) {
				warn("trackPageview: BLOCKED: " + path);
				return;
			}
			
			notice("trackPageview: " + path);
			_tracker.trackPageview(path);
		}

		public function trackEvent(inCategory : String, inAction : String, inLabel : String = "", inValue : Number = NaN) : void {
			var path : String = new NavigationState(_pathPrefix + "/" + inCategory).path;
			if (!_tracker) {
				warn("trackEvent: BLOCKED: " + [path, inAction, inLabel, inValue]);
				return;
			}
			
			notice("trackEvent: " + [path, inAction, inLabel, inValue]);
			_tracker.trackEvent(path, inAction, inLabel, inValue);
		}		
	}
}