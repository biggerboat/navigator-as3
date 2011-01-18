package components {
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TweenMax;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class Square extends BaseShape implements IHasStateInitialization, IHasStateTransition {
		public function Square(color : uint = 0xFF9900) {
			super(color);
		}

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			draw();
			alpha = 0;
			visible = false;
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			TweenMax.to(this, 1, {autoAlpha:1, onComplete:inCallOnComplete});
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			TweenMax.to(this, 1, {autoAlpha:0, onComplete:inCallOnComplete});
		}
	}
}
