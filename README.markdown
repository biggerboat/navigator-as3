# Navigator for ActionScript 3.0

All the ActionScript 3.0 code I consider to be reusable, I bundle in the "reusabilitee" project.
Currently, the bulk of the project's files are still over at Google Code: http://code.google.com/p/epologee
However, this one particular part that I brilliantly coined the "Navigator", is my most valuable component to date, which is why I brought it to GitHub as a standalone project. There should be no references to external libraries, except for the integration package. You can safely delete/ignore that package if you don't need it though.

# What does it do?

The Navigator strives to take away all your pains when it comes to navigating your application between different states. It provides ways to deal with (asynchronous) transitions between states without bugging you with the tedious parts. All transitions are 100% customizable, there's no tweening or anything like that in this library.

# The Navigation State Concept

## Wrapped paths

Everything you do with the Navigator uses the concept of navigation states. A navigation state (also the class NavigationState.as) is a wrapper around a slash delimited path, like `/home/about/` or `/gallery/birds/213/`. When setting up your application, you add your own class instances to the navigator by providing the navigation state or path it should respond to. 

For example, by calling `navigator.add(myInstance, "/contact/")` you have made sure that myInstance is shown when the navigator is at the `/contact/` state.

## Clean paths

Internally, the Navigator will convert all paths to NavigationState instances. This takes care of a couple of things you shouldn't worry about, like where to put the slashes. A NavigationState's path will always have a leading and trailing slash, and accidental double slashes will be removed.

For example, the compound string `"home/" + "/info"` will be converted to a `/home/info/` path once passed to a NavigationState instance.

## Inclusion

The way I envisioned the path of a navigation state is a little different from the way paths work on the web. The idea is that anything that is visible on a 'higher level' state, like `/home/`, will still be active on a 'lower level' state, like `/home/info/`. This provides an interesting way of nesting visual elements on your screen, without having to think twice about "should it stay? or should it get some kind of hide() call?"

What does that mean? Well, if you register an image class that shows your face on `/about/`, your face will stay visible when you then navigate to a state called `/about/my-girlfriend/`. If however you navigate to `/my-girlfriend/`, your face will be hidden.

Of course you can define exceptions to this rule, but we'll get to that.

# Requesting States

You navigate your application by calling the navigator.requestNewState() or requestNewStateByPath() methods. The second is a convenience method so you don't have to think of creating your own NavigationState instances every time you make a request. At every request, the Navigator will run through the transition flow, which will first validate the request, then transitionOut all instances that need to hide, then update all instances that want to know the exact new state, then transitionIn all instances that need to show and lastly swap the contents of visible instances if they should.

You code all the transitions yourself, and by executing a provided callback method you let the navigator know your transition is ready. So you have total control over the duration of a transition and whatever tweening or otherwise audiovisual stuff you want to happen.

The Navigator will make sure that no transitionIn or ~Out is called without it being neccessary (no more hide-calls when something is already hidden!), and it even provides you with a shortcut menu to quickly navigate your application while developing.

# Mind the Interface

## INavigationResponder

All your custom classes should implement the appropriate interfaces in order to behave the way you want, with respect to the Navigator. The base behavior interface for a class is the marker interface INavigationResponder. You do not implement this interface directly, but you implement any of the subinterfaces, which you can combine to your liking.

*	**IHasStateInitialization**<br />
	Adds just-in-time initialization to your class. Right before any other call, the initialize() method is called.
*	**IHasStateTransition**<br />
	This contains what you would consider 'default show/hide' features. Here, it's called transitionIn() and transitionOut(). Be sure to use the provided callback methods to indicate when you're done with your transition. You can also just callback instantly, if the transition is synchronous (like a simple visible true/false switch).
*	**IHasStateValidation**<br />
	If you want to add custom paths to the Navigator that aren't known at compile-time, or are too tedious to enter manually, you use the validation interface. Every single state path requested from the Navigator, has to pass validation, either because an instance is registered at that path, or because you validate it yourself. Return true or false to indicate the path is valid or invalid. The provided arguments may seem a bit weird, read through the source documentation to see how it works.
*	**IHasStateUpdate**<br />
	This is a usual companion of the validator interface. Consider the pages of a gallery `/gallery/1/`, `/gallery/2/` etc. If the state is requested, it gets run by validation first, and if granted, will trigger an updateState() call. After the update, it will proceed with transitioning.
*	**IHasStateSwap**<br />
	The swap is a more specific variant of the update interface. It deals with scenarios where you want to have an asynchronous transition between pages, without needing to transitionOut and transitionIn. For the previously given examples of gallery pages, you could also use the swap interface and have the page tween off the stage, right before a new page tweens in. Swap is your friend.
*	**IHasStateValidationOptional**<br />
	The final interface is a specific companion to the validator interface. It is only used when you want or need to register two validators at the same state. Right before validation, the Navigator will ask your optional validator if it will actually validate the requested state, or if it's not interested. This way you can prevent two validators eternally contradicting eachother and never passing validation

# Integration

The integration package is provided to help you on your way if you're a fan of standardized frameworks. Currently the only external framework that is used, is PureMVC. Others may follow. Feel free to send a pull request if you have a custom implementation!

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
		<state path={States.REGISTRATION_FORM}>
			<show>{PageRegistrationMediator.NAME}</show>
		</state>
		<state path={States.REGISTRATION_QUIZ}>
			<auto>{PageQuizzMediator.NAME}</auto>
		</state>
		<state path={States.REGISTRATION_DRESS_CODE}>
			<show>{PageDressCodeMediator.NAME}</show>
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

## SWFAddress 2.4

To wrap this monstrous README file up, the PureMVC integration package gives you the option of using SWFAddress 2.4 to propagate state changes back and forth to the user's browser address, so there's instant deeplinking, history back tracking and it's all 100% fool proof!

Enjoy the Navigator!