package suites.navigator.states {
	import com.epologee.navigator.NavigationState;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	/**
	 * @author epologee
	 */
	public class TestNavigationState {
		[Before]
		public function setup() : void {
			notice("setup");
		}

		[Test]
		public function pathStringEquality() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("/anyState/");
			assertThat(a.path, equalTo(b.path));
			
			a.segments = ["a", "b", "c"];
			b = new NavigationState("a", "b", "c");
			assertThat(a.path, equalTo(b.path));	
			
			a.segments = [];
			b = new NavigationState("/");
			assertThat(a.path, equalTo(b.path));
		}

		[Test]
		public function advancedEquality() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("/anyState/");
			assertThat("the equals method works on single segmented paths", a.equals(b), equalTo(true));

			a = new NavigationState("a", "b", "c");
			b = new NavigationState("a/b/c");
			assertThat("the equals method works on multi segmented paths", a.equals(b), equalTo(true));

			a = new NavigationState("a", "b", "c");
			b = new NavigationState("a/*/c");
			assertThat("the equals method works on multi segmented paths with wildcards", a.equals(b), equalTo(true));

			a = new NavigationState("a", "*", "c");
			b = new NavigationState("a/b/c");
			assertThat("the equals method works on multi segmented paths with wildcards (inverted)", a.equals(b), equalTo(true));
		}

		[Test]
		public function containment() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("/anyState/subState");
			assertThat("a contains b", a.contains(b), equalTo(false));
			assertThat("b does not contain a", b.contains(a), equalTo(true));
		}
	}
}
