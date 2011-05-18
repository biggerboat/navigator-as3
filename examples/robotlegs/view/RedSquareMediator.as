package view {
	import model.constants.Positions;

	import view.components.RedSquare;

	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.epologee.navigator.integration.swfaddress.SWFAddressNavigator;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class RedSquareMediator extends Mediator implements IHasStateInitialization, IHasStateTransition {
		[Inject]
		public var square : RedSquare;
		/**
		 * You can inject the navigator in three ways. 
		 * The first is recommended, the second deprecated but possible and 
		 * the third is if you need to access custom methods of your custom
		 * Navigator subclass, like SWFAddressNavigator. 
		 */
		[Inject]
		public var navigatorRecommended : INavigator;
		[Inject]
		public var navigatorDeprecated : Navigator;
		[Inject]
		public var navigatorCustom : SWFAddressNavigator;

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
