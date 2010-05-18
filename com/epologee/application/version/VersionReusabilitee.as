package com.epologee.application.version {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class VersionReusabilitee {
		/**
		 * Values are changed on commit
		 * Precommit hook (SVN)
		 * 
		 * Thank you jankees @ base42.nl!
		 */
		public static const REVISION : String = "$Rev: 58 $";
		public static const DATE : String = "$Date: 2009-09-23 18:17:53 +0200 (Wed, 23 Sep 2009) $";
		public static const AUTHOR : String = "$Author: epologee@gmail.com $";	

		/**
		 * Get the version info
		 * @return String
		 */
		public static function toString() : String {
			return "Reusabilitee "+["version: r" + getRevision().toString(),"author: " + getLastAuthor()].join(", ");
		}

		/**
		 * Get the revision number.
		 * @return uint
		 */
		public static function getRevision() : uint {
			return REVISION.match(/\D*(\d*)\D*/)[1];
		}

		/**
		 * Get the date out of revision date.
		 * @return String
		 */
		public static function getDate() : String {
			return DATE.match(/\$Date:\s(.*?)\s\$/)[1];
		}

		/**
		 * Get the last author
		 * @return String
		 */
		public static function getLastAuthor() : String {
			return AUTHOR.match(/\$Author:\s(.*?)\s\$/)[1];
		}	
	}
}
