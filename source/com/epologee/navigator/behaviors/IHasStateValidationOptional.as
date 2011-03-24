package com.epologee.navigator.behaviors {
	import com.epologee.navigator.NavigationState;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Consider this scenario. You have two validators listening to the same state.
	 * One validator cares for paths that start with "some" (like /some/path/1/ and /some/path/2/)
	 * Another validator cares for paths that start with "any" (like /any/path/5/ and /any/path/6/)
	 * 
	 * If both were simple IHasStateValidation, they could only give feedback about "pass" (true) or "fail" (false),
	 * and each of them would invalidate paths that belong to the other.
	 * 
	 * That's where this optional validation check comes in. If you have a case where two 
	 * validators are registered to the same path, have them implement this interface.
	 * 
	 * Right before the actual validation, they will be asked if they want to validate the requested
	 * path. If they then return false, the validate() method will not be called. 
	 */
	public interface IHasStateValidationOptional extends IHasStateValidation {
		function willValidate(truncated : NavigationState, full : NavigationState):Boolean;
	}
}
