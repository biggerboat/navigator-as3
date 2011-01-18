package components {
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TweenMax;

	import flash.display.Graphics;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class Circle extends BaseShape implements IHasStateTransition {
		public function Circle(color : uint = 0xFF9900) {
			super(color);

			// Because this class does not implement the IHasStateInitialization, we'll take care of that part here.
			// Be sure to end your initialization with a non-visible component.
			draw();
			alpha = 0;
			visible = false;
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			TweenMax.to(this, 1, {autoAlpha:1});

			// Here we execute the complete callback immediately, which is also possible, and has
			// an added side effect of simultaneous transitions.
			inCallOnComplete();
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			TweenMax.to(this, 1, {autoAlpha:0});

			// Same as transitionIn, instant complete call.
			inCallOnComplete();
		}

		override protected function draw() : void {
			var g : Graphics = graphics;
			g.beginFill(_color, _alpha);
			g.drawCircle(_size / 2, _size / 2, _size / 2);
			g.endFill();
		}
	}
}
