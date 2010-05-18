package com.epologee.ui.forms.linkage {
	import com.epologee.logging.Logee;
	import com.epologee.ui.forms.components.IElementGroup;

	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class GroupBase extends MovieClip implements IElementGroup {
		public function GroupBase() {
			super();
		}

		public function show() : void {
			Logee.info("show: ");
			visible = true;
		}

		public function hide() : void {
			Logee.info("hide: ");
			visible = false;
		}

		override public function toString() : String {
			// Flash library linkage: com.epologee.ui.forms.linkage.GroupBase
			var s : String = "";
			// s = "[ " + name + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}
