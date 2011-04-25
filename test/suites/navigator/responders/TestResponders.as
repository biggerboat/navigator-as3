package suites.navigator.responders {
	import org.hamcrest.object.isFalse;
	import suites.navigator.validation.elements.ResponderAsyncIV;
	import suites.navigator.validation.elements.ResponderAsyncIVO;
	import suites.navigator.validation.elements.ResponderIT;
	import suites.navigator.validation.elements.ResponderIV;
	import suites.navigator.validation.elements.ResponderIVO;

	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.namespaces.hidden;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.isTrue;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TestResponders {
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

//			navigator.add(responderIT, "segment1a");
//			navigator.add(responderIT, "segment1b");
//			navigator.add(responderIV, "segment1c");
//			navigator.add(responderAsyncIV, "segment1d");
//			navigator.add(responderIVO1, "segment1e");
//			navigator.add(responderIVO2, "segment1e");
//			navigator.add(responderAsyncIVO1, "segment1f");
//			navigator.add(responderAsyncIVO2, "segment1f");
//			navigator.add(responderIT, "segment1h/*/*/*");

			navigator.start("");
		}

		[Test(order=10)]
		public function synchronousAddRemove() : void {
			navigator.add(responderIT, "segment1a");
			assertThat(navigator.hidden::hasResponder(responderIT), isTrue());

			navigator.remove(responderIT, "segment1a");
			assertThat(navigator.hidden::hasResponder(responderIT), isFalse());
		}
	}
}
