package suites.navigator.validation {
	import suites.navigator.validation.elements.ResponderAsyncIV;
	import suites.navigator.validation.elements.ResponderAsyncIVO;
	import suites.navigator.validation.elements.ResponderIT;
	import suites.navigator.validation.elements.ResponderIV;
	import suites.navigator.validation.elements.ResponderIVO;

	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;

	import org.flexunit.assertAfterDelay;
	import org.flexunit.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TestValidation {
		private var navigator : Navigator;
		private var responderIT : ResponderIT;
		private var responderIV : ResponderIV;
		private var responderAsyncIV : ResponderAsyncIV;
		private var responderIVO1 : ResponderIVO;
		private var responderIVO2 : ResponderIVO;
		private var responderAsyncIVO1 : ResponderAsyncIVO;
		private var responderAsyncIVO2 : ResponderAsyncIVO;

		[Before]
		public function setup() : void {
			navigator = new Navigator();
			responderIT = new ResponderIT();
			responderIV = new ResponderIV(NavigationState.make("segment2a"));
			responderAsyncIV = new ResponderAsyncIV(NavigationState.make("segment2d"));
			responderIVO1 = new ResponderIVO(NavigationState.make("segment2f"), NavigationState.make("segment2f/segment3a"));
			responderIVO2 = new ResponderIVO(NavigationState.make("segment2g"), NavigationState.make("segment2g/segment3a"));
			responderAsyncIVO1 = new ResponderAsyncIVO(NavigationState.make("segment2f"), NavigationState.make("segment2f/segment3a"));
			responderAsyncIVO2 = new ResponderAsyncIVO(NavigationState.make("segment2g"), NavigationState.make("segment2g/segment3a"));

			navigator.add(responderIT, "segment1a");
			navigator.add(responderIT, "segment1b");
			navigator.add(responderIV, "segment1c");
			navigator.add(responderAsyncIV, "segment1d");
			navigator.add(responderIVO1, "segment1e");
			navigator.add(responderIVO2, "segment1e");
			navigator.add(responderAsyncIVO1, "segment1f");
			navigator.add(responderAsyncIVO2, "segment1f");
			navigator.add(responderIT, "segment1h/*/*/*");

			navigator.start("");
		}

		[After]
		public function tearDown() : void {
			responderIT.removeAllSignalListeners();
			responderIV.removeAllSignalListeners();
		}

		[Test(order=10)]
		public function implicitValidation() : void {
			var request : NavigationState = NavigationState.make("segment1a");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(request.path));
		}

		[Test(order=20)]
		public function implicitInvalidation() : void {
			var request : NavigationState = NavigationState.make("segment1x");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, not(request.path));
		}

		[Test(order=21)]
		public function implicitWildcardValidation() : void {
			var request : NavigationState = new NavigationState("segment1h/segment2a/segment3a/segment4a");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(request.path));

			request = new NavigationState("*/*/*/segment4b");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(NavigationState.make("segment1h/segment2a/segment3a/segment4b").path));
		}

		[Test(order=30)]
		public function explicitValidation() : void {
			var request : NavigationState = new NavigationState("segment1c", "segment2a");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(request.path));
		}

		[Test(order=40)]
		public function explicitInvalidation() : void {
			var request : NavigationState = new NavigationState("segment1c", "segment2b");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, not(request.path));
		}

		[Test(async,order=50,timeout=5000)]
		public function asyncValidation() : void {
			var start : NavigationState = navigator.currentState;
			var request : NavigationState = new NavigationState("segment1d", "segment2d");
			assertAfterDelay(responderAsyncIV.durationMS + 100, thatAsyncValidationWorks, request);
			navigator.requestNewState(request);

			// Path should still be unchanged.
			assertThat(navigator.currentState.path, equalTo(start.path));
		}

		private function thatAsyncValidationWorks(inRequest : NavigationState) : void {
			assertThat(navigator.currentState.path, equalTo(inRequest.path));
		}

		[Test(async,order=60,timeout=5000)]
		public function asyncInvalidation() : void {
			var start : NavigationState = navigator.currentState;
			var request : NavigationState = new NavigationState("segment1d", "segment2e");
			assertAfterDelay(responderAsyncIV.durationMS + 100, thatAsyncInvalidationWorks, request);

			navigator.requestNewState(request);

			// Path should still be unchanged.
			assertThat(navigator.currentState.path, equalTo(start.path));
		}

		private function thatAsyncInvalidationWorks(request : NavigationState) : void {
			assertThat(navigator.currentState.path, not(request.path));
		}

		[Test(order=70)]
		public function instantAsyncValidation() : void {
			var request : NavigationState = new NavigationState("segment1d", "segment2d");
			responderAsyncIV.instantPreparation = true;
			navigator.requestNewState(request);

			assertThat(navigator.currentState.path, equalTo(request.path));
		}

		[Test(order=80)]
		public function instantAsyncInvalidation() : void {
			var start : NavigationState = navigator.currentState;
			var request : NavigationState = new NavigationState("segment1d", "segment2e");
			responderAsyncIV.instantPreparation = true;
			navigator.requestNewState(request);

			assertThat(navigator.currentState.path, equalTo(start.path));
		}

		[Test(order=90)]
		public function optionalValidation() : void {
			var request : NavigationState = new NavigationState("segment1e", "segment2f", "segment3a");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(request.path));

			request = new NavigationState("segment1e", "segment2g", "segment3a");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(request.path));
		}

		[Test(order=100)]
		public function optionalInstantAsyncValidation() : void {
			responderAsyncIVO1.instantPreparation = true;
			responderAsyncIVO2.instantPreparation = true;

			var request : NavigationState = new NavigationState("segment1f", "segment2f", "segment3a");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(request.path));

			request = new NavigationState("segment1f", "segment2g", "segment3a");
			navigator.requestNewState(request);
			assertThat(navigator.currentState.path, equalTo(request.path));
		}
	}
}

