package org.flexunit.listeners {
	import org.flexunit.reporting.FailureFormatter;
	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.Result;
	import org.flexunit.runner.notification.Failure;
	import org.flexunit.runner.notification.RunListener;

	public class LogMeisterListener extends RunListener {
		public function LogMeisterListener() {
			super();
		}
		
		override public function testRunFinished( result:Result ):void {
			printHeader( result.runTime );
			printFailures( result );
			printFooter( result );
		}
	
		override public function testStarted( description:IDescription ):void {
			notice( description.displayName + " ." );
		}
	
		override public function testFailure( failure:Failure ):void {
			if ( FailureFormatter.isError( failure.exception ) ) {
				critical( failure.description.displayName + " E" );
			} else {
				critical( failure.description.displayName + " F" );
			}
		}
	
		override public function testIgnored( description:IDescription ):void {
			notice( description.displayName + " I" );
		}
	
		/*
		 * Internal methods
		 */
		protected function printHeader( runTime:Number ):void {
			notice( "Time: " + elapsedTimeAsString(runTime) );
			//trace( elapsedTimeAsString(runTime) );
		}
	
		protected function printFailures( result:Result ):void {
			var failures:Array = result.failures;
			if (failures.length == 0)
				return;
			if (failures.length == 1)
				notice( "There was " + failures.length + " failure:" );
			else
				notice("There were " + failures.length + " failures:" );
			
			for ( var i:int=0; i<failures.length; i++ ) {
				printFailure( failures[ i ], String( i+1 ) );
			}
		}
	
		protected function printFailure( failure:Failure, prefix:String ):void {
			notice( prefix + " " + failure.testHeader + " " + failure.stackTrace );
		}
	
		protected function printFooter( result:Result ):void {
			if (result.successful ) {
				debug( "OK (" + result.runCount + " test " + (result.runCount == 1 ? "" : "s") + ")" );
			} else {
				critical( "FAILURES!!! Tests run: " + result.runCount + ", " + result.failureCount + " Failures:" );
			}
		}
	
		/**
		 * Returns the formatted string of the elapsed time. Duplicated from
		 * BaseTestRunner. Fix it.
		 */
		protected function elapsedTimeAsString( runTime:Number ):String {
			return String( runTime / 1000 );
		}
	}
}