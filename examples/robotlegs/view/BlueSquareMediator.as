package view {
	import model.constants.Positions;

	import view.components.BlueSquare;

	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class BlueSquareMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		[Inject]
		public var square : BlueSquare;

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			square.x = Positions.MARGIN_LEFT + Positions.SHAPE_SIZE * 2;
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
