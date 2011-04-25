package suites.navigator {
	import suites.navigator.responders.TestResponders;
	import suites.navigator.states.TestNavigationState;
	import suites.navigator.validation.TestValidation;

	/**
	 * @author epologee
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class NavigatorTestSuite {
		public var navigationState : TestNavigationState;
		public var validation : TestValidation;
		public var responders : TestResponders;
	}
}
