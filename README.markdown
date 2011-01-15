# Navigator for ActionScript 3.0

This library was created to take away your pains when it comes to navigating your application between different views or application states. It provides ways to deal with (asynchronous) transitions between states without bugging you with the tedious parts. To sum up of the library's features:

*	Total control over synchronous and asynchronous visual transitions
*	Just-in-Time initalization of view components
*	Instant deeplinking with SWFAddress
*	Support for dynamic range elements and lists, like gallery items
*	Nested states, move complete parts of you application and they still work
*	Flow control through state validation, both synchronous and asynchronous
*	Integration of popular frameworks (PureMVC, RobotLegs), but it's optional
*	History management (courtesy of Laurent)
*	And many more...

## Navigation State Concept

The core concept of the navigator revolves around **navigation states**. These are essentially slash delimited paths, wrapped in convenience class instances called **NavigationState**. This class you'll use fairly frequently, for it not only takes care of putting the slashes in consistently, it also contains convenience methods to compare and modify states. You change the state of your application by requesting a new state, like: `navigator.request("gallery")`. The path will automatically be complemented to include the right beginning and trailing slashes, so if granted, your application will navigate to the state called **/gallery/**.

The idea of these navigation states is that they're built like a [cascade](http://www.google.nl/images?q=cascade). You add elements of your application to a certain state, and the navigator will make sure it responds to changes in that state or states further down stream. For example, you can add your gallery component to a state called **/gallery/**. If your application state then changes to **/gallery/fishes/** your component will be notified of the change. The same holds true for a state like **/gallery/fishes/1979/**. If however the application navigates to **/contact/** or **/contact/headquarters/**, it will not be notified of the change, and most likely be ordered to hide itself.

## Behaviors

The kind of notification an element gets from the navigator is based on the behavior it was added with. All notifications happen through direct method calls, which is why your element needs to implement the correct interfaces. These behavior interfaces contain methods for transitioning in and out, getting update calls, swapping content in ranged lists and, very important, validate states.

## Validation

To ensure that your application can never navigate to an 'invalid' state, part of the library deals with validating requests, though most of this happens automatically. For example, because the navigator knows if you have a component registered to **/about/**, the `navigator.request("about")` will be granted immediately. However, if you want to make sure that your gallery component does not navigate past the amount of pictures in your database, you can deny requests that exceed the boundaries of you application. The item at **/gallery/5/** may be completely fine, but **/gallery/42/** may not be. For the case that your application needs a little time to decide whether a state is valid or not, there's also support for asynchronous validation. This whole validation business makes the use of a deeplinking feature a breeze.

# Integration of other frameworks
## SWFAddress 2.4

Implementing deeplinks into your application has never been easier. Create your application with the Navigator, and at any time replace the constructor of new Navigator with new SWFAddressNavigator() and you're done. You application states will be put in the browser's address bar and you don't have to do anything special for it! Now there are always parts of an application's steps that you do not want to expose to the click-savvy end user, which is why you may hide certain states from them. Check out the SWFAddressNavigator class for more information.

## RobotLegs (still experimental!)

Although the framework started out as a companion to PureMVC, my personal preference has moved to RobotLegs as of late. By providing just a minimum of extra classes, the Navigator steps up and complements the framework to a large benefit. RobotLegs constructs mediators when view components are added to the stage, and provides the mediators with all the instances it needs through injection. Putting the view components on stage however, is still a task left up to you, and getting a nice setup for it can be pretty tedious. 

By extending the NavigatorContext, this is no longer the case. Register your view components and mediators to the right navigation state from within your application context' `startup` method. You can define the order at which your components appear on stage, yet they will only be constructed when the application navigates to the corresponding state:

<code>
	
	override public function startup() : void {
		// Map Actor subclasses (like models/proxies) to listen to particular states:
		stateActorMap.mapStateSingleton("/", ApplicationModel);
		
		// Map the /red/ state to the RedSquare view component with it's corresponding mediator RedMediator 
		stateMediatorMap.mapState("red", RedSquare, RedMediator);
		// Map the green and blue view components to multiple states at once, with the corresponding mediator
		stateMediatorMap.mapState(["green", "*/green", "*/*/green", "*/*/*/green"], GreenSquare, GreenMediator);
		stateMediatorMap.mapState(["blue", "*/blue", "*/*/blue", "*/*/*/blue"], BlueSquare, BlueMediator);
		// Map /any/ to a square with a custom color and the corresponding mediator  
		stateMediatorMap.mapState(new NavigationState("any"), AnySquare, AnyMediator, 0xFF9900);

		// Add extra mappings to the red and any square
		stateMediatorMap.mapAdditionalStates(["*/red", "*/*/red", "*/*/*/red"], RedSquare);
		stateMediatorMap.mapAdditionalStates(["*/any", "*/*/any", "*/*/*/any"], AnySquare);

		// Add the debug status display, mediatorless
		stateMediatorMap.mapState("/", DebugStatusDisplay, null, navigator);
	
		// Start the navigation with default state /red/
		navigator.start("red");
	}
</code>

***RobotLegs integration is still pretty fresh, so please be advised that details of the implementation may change in future updates.***

## PureMVC

By providing standard mediators and a proxy wrapper of the Navigator, getting up to speed is done in seconds. Have your mediators extend TransitionMediator, and use the XML based state map to easily add dozens of mediators to the NavigatorProxy. Especially by using the `<auto />` behavior, you can add an instance for all the interfaces it implements with just one line of XML. Here's an example of how to setup a fairly simple state machine in PureMVC:

<code>
	
	var np : NavigationProxy = NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME));
			 
	var map : XML = <map>
		<state path={States.OUTSIDE}>
			<auto>{OutsideMediator.NAME}</auto>
		</state>
		<state path={States.INSIDE}>
			<auto>{BackgroundMediator.NAME}</auto>
			<auto>{ForegroundMediator.NAME}</auto>
		</state>
		<state path={States.HOME}>
			<show>{PageHomeMediator.NAME}</show>
		</state>
		<state path={States.VODAFONE}>
			<show>{PageVodafoneMediator.NAME}</show>
		</state>
		<state path={States.LOCATION}>
			<show>{PageLocationMediator.NAME}</show>
		</state>
		<state path={States.PROGRAM}>
			<show>{PageProgramMediator.NAME}</show>
		</state>
		<state path={States.REGISTRATION_THANK_YOU}>
			<show>{PageThankYouMediator.NAME}</show>
		</state>
		<state path={States.CONTACT}>
			<show>{PageContactMediator.NAME}</show>
		</state>
		<state path={States.DISCLAIMER}>
			<show>{PageDisclaimerMediator.NAME}</show>
		</state>
	</map>;
	
	np.parseMediatorStateMap(map);
</code>

# Feedback

I'd love to hear your opinion on this library and the scenarios you're using it in. Drop me a line or file an issue here on GitHub if you need more information. Enjoy the Navigator!