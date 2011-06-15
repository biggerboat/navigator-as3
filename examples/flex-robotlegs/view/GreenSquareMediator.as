package view {
	import spark.components.Application;
	import model.constants.Positions;

	import view.components.GreenSquare;

	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class GreenSquareMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		public static var COUNTER : int = 0;
		[Inject]
		public var square : GreenSquare;
		private var index : int = ++COUNTER;

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			square.x = Positions.MARGIN_LEFT + Positions.SHAPE_SIZE;
			square.y = Positions.MARGIN_TOP * 2 + Positions.TEXT_BOX_HEIGHT;
			square.alpha = 0;
			square.visible = false;
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			// If you want to, or if you applications needs you to, you can
			// re-add your view component to the context view whenever you need to.
			Application(contextView).addElement(square);

			TweenMax.to(square, 1, {autoAlpha:1, onComplete:inCallOnComplete});
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			square.visible = false;
			
			TweenMax.to(square, 1, {autoAlpha:0, onComplete:finishTransitionOut, onCompleteParams:[inCallOnComplete]});
		}

		private function finishTransitionOut(inCallOnComplete : Function) : void {
			// Remove the child from the contextView, just because we can:
			Application(contextView).removeElement(square);

			// And call the completion callback. Always make sure this callback is called, or the transition system will break.
			inCallOnComplete();
		}

		public function toString() : String {
			return "[GreenSquareMediator " + index + "]";
		}
	}
}
