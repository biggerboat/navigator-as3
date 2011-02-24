package view {
	import model.constants.Positions;

	import view.components.RedSquare;

	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class RedSquareMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		[Inject]
		public var square : RedSquare;

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			square.x = Positions.MARGIN_LEFT;
			square.y = Positions.MARGIN_TOP * 2 + Positions.TEXT_BOX_HEIGHT;
			square.alpha = 0;
			square.visible = false;
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			TweenMax.to(square, 1, {autoAlpha:1, onComplete:inCallOnComplete});
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			TweenMax.to(square, 1, {autoAlpha:0, onComplete:inCallOnComplete});
		}
	}
}
