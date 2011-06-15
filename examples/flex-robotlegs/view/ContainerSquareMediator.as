package view {
	import spark.components.Group;
	import mx.core.UIComponent;
	import model.constants.Positions;

	import view.components.ContainerSquare;

	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;

	import org.robotlegs.mvcs.Mediator;

	import flash.display.BlendMode;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ContainerSquareMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		[Inject]
		public var square : ContainerSquare;
		//
		private var _animation : TimelineMax;

		/**
		 * @inheritDoc
		 */
		public function initialize() : void {
			square.x = Positions.MARGIN_LEFT;
			square.y = Positions.MARGIN_TOP * 2 + Positions.TEXT_BOX_HEIGHT;
			square.alpha = 0;
			square.visible = false;
			square.blendMode = BlendMode.LAYER;

			_animation = new TimelineMax();
			_animation.paused = true;
			_animation.repeat = 999;

			_animation.append(TweenMax.to(square, 3, {x:square.x + 100, ease:Strong.easeInOut}));
			_animation.append(TweenMax.to(square, 3, {x:square.x, ease:Strong.easeInOut}));
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			_animation.play();
			TweenMax.to(square, 0.5, {autoAlpha:1, onComplete:inCallOnComplete});
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			TweenMax.to(square, 0.5, {autoAlpha:0, onComplete:finishTransitionOut, onCompleteParams:[inCallOnComplete]});
		}

		private function finishTransitionOut(inCallOnComplete : Function) : void {
			// Remove the child from the contextView, just because we can:
			Group(square.parent).removeElement(square);
			_animation.stop();

			// And call the completion callback. Always make sure this callback is called, or the transition system will break.
			inCallOnComplete();
		}
	}
}
