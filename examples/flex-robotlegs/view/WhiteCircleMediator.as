package view {
	import model.constants.Positions;

	import view.components.WhiteCircle;

	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class WhiteCircleMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		[Inject]
		public var circle : WhiteCircle;

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			circle.x = Positions.MARGIN_LEFT + Positions.SHAPE_SIZE * 3;
			circle.y = Positions.MARGIN_TOP * 2 + Positions.TEXT_BOX_HEIGHT;
			circle.alpha = 0;
			circle.visible = false;
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			inCallOnComplete();
			TweenMax.to(circle, 1, {autoAlpha:1});
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			inCallOnComplete();
			TweenMax.to(circle, 1, {autoAlpha:0});
		}
	}
}
