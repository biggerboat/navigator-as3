package view {
	import model.constants.Positions;

	import view.components.NestedSquare;

	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NestedSquareMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		[Inject]
		public var square : NestedSquare;

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			square.x = Positions.MARGIN_LEFT;
			square.y = Positions.MARGIN_TOP;
			square.alpha = 0;
			square.visible = false;
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			TweenMax.to(square, 1, {autoAlpha:1, onComplete:inCallOnComplete});
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			TweenMax.to(square, 1, {autoAlpha:0, onComplete:finishTransitionOut, onCompleteParams:[inCallOnComplete]});
		}

		private function finishTransitionOut(inCallOnComplete : Function) : void {
			// Remove the child from the contextView, just because we can:
			square.parent.removeChild(square);

			// And call the completion callback. Always make sure this callback is called, or the transition system will break.
			inCallOnComplete();
		}
	}
}
