package view {
	import spark.components.Group;
	import model.constants.Positions;

	import view.components.NestedSquare;

	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NestedSquareMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		[Inject]
		public var square : NestedSquare;
		private var _animation : TimelineMax;

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			square.x = Positions.MARGIN_LEFT;
			square.y = Positions.MARGIN_TOP / 2;
			square.alpha = 0;
			square.visible = false;

			_animation = new TimelineMax();
			_animation.paused = true;
			_animation.repeat = 999;

			_animation.append(TweenMax.to(square, 1.5, {y:square.y + Positions.MARGIN_TOP, ease:Strong.easeInOut}));
			_animation.append(TweenMax.to(square, 1.5, {y:square.y, ease:Strong.easeInOut}));
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			_animation.play();
			
			TweenMax.to(square, 1, {autoAlpha:1, onComplete:inCallOnComplete});
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			TweenMax.to(square, 1, {autoAlpha:0, onComplete:finishTransitionOut, onCompleteParams:[inCallOnComplete]});
		}

		private function finishTransitionOut(inCallOnComplete : Function) : void {
			_animation.stop();
			
			// Remove the child from the contextView, just because we can:
			Group(square.parent).removeElement(square);

			// And call the completion callback. Always make sure this callback is called, or the transition system will break.
			inCallOnComplete();
		}
	}
}
