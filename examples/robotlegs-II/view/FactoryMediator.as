package view {
	import view.components.FactoryContainer;

	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateViewMap;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class FactoryMediator extends Mediator implements IHasStateTransition {
		[Inject]
		public var timeline : FactoryContainer;
		[Inject]
		public var viewMap : IStateViewMap;
		[Inject]
		public var navigator : INavigator;
		
		public function transitionIn(inCallOnComplete : Function) : void {
			inCallOnComplete();
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			//viewMap.mapViewMediator("/factory/", FactoryContainer, FactoryMediator);
			navigator.remove(this, "factory");
			inCallOnComplete();
		}
	}
}
