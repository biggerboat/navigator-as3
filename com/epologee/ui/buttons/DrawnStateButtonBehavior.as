package com.epologee.ui.buttons {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * 		[intro]      [in]        [press]
	 * 			   \    •    \      •       \
	 * 			    •  /      •    /         •
	 * 		        [up]      [over]         [down]
	 * 		       /   •     /      •       /
	 * 		      •     \   •        \     • 
	 * 		[outtro]    [out]       [release]
	 * 			 
	 */
	public class DrawnStateButtonBehavior extends EventDispatcher implements IEnableDisable {
		//
		private var _target : IHasDrawnStates;
		private var _isEnabled : Boolean;
		private var _isOver : Boolean;
		private var _isDown : Boolean;
		private var _state : int;
		private var _selected : Boolean;

		public function get targetAsSprite() : Sprite {
			return Sprite(_target);
		}

		public function DrawnStateButtonBehavior(inTargetSprite : IHasDrawnStates) {
			_target = inTargetSprite;
			
			// the behavior needs the button to be on stage.
			if (_target.stage) {
				enable();
			} else {
				_target.addEventListener(Event.ADDED_TO_STAGE, handleTargetAddedToStage);
			}
		}

		private function handleTargetAddedToStage(event : Event) : void {
			_target.removeEventListener(Event.ADDED_TO_STAGE, handleTargetAddedToStage);
			
			enable();
		}

		public function enable() : void {
			if (!_isEnabled) {
			
				_isEnabled = true;
				targetAsSprite.mouseEnabled = true;
				targetAsSprite.mouseChildren = false;
				targetAsSprite.buttonMode = true;
			
				_target.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
				_target.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
				_target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			}

			if (_isDown) {
				if (_target is IHasDownState) {
					IHasDownState(_target).drawDownState();
				} else {
					_target.drawOverState(); 
				}
			} else if (_isOver) {
				_target.drawOverState(); 
			} else if (_selected && _target is IHasSelectedState) {
				IHasSelectedState(_target).drawSelected();
			} else {
				_target.drawUpState();
			}
		}

		public function disable() : void {
			if (!_isEnabled) return;
			  
			_isEnabled = false;
			_isOver = false;
			_isDown = false;
			
			targetAsSprite.mouseEnabled = false;
			targetAsSprite.buttonMode = false;
			

			_target.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			_target.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);

			if (targetAsSprite && targetAsSprite.stage) {
				targetAsSprite.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			}
		}

		/**
		 * A selected button will only draw a selected state if the target implements IHasSelectedState.
		 */
		public function select(inDisableToo : Boolean = true) : void {
			_selected = true;
			
			if (inDisableToo) {
				disable();
			}
			
			if (_target is IHasSelectedState) {
				IHasSelectedState(_target).drawSelected();
			}
		}

		/**
		 * Deselect will re-enable the behavior if it was disabled.
		 */
		public function deselect() : void {
			_selected = false;
			
			enable();
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function destroy() : void {
			disable();
			
			_target = null;
			
			delete(this);
		}

		private function handleMouseOver(event : MouseEvent) : void {
			_state = MouseState.MOUSE_OVER;
			_target.drawOverState();
			_isOver = true;
		}

		private function handleMouseOut(event : MouseEvent) : void {
			_state = MouseState.MOUSE_OUT;
			if (_selected && _target is IHasSelectedState) {
				IHasSelectedState(_target).drawSelected();
			} else {
				_target.drawUpState();
			}
			_isOver = false;
		}

		private function handleMouseDown(event : MouseEvent) : void {
			_state = MouseState.MOUSE_DOWN;
			_isDown = true;
			
			if (_target is IHasDownState) {
				IHasDownState(_target).drawDownState();
			}
			
			targetAsSprite.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}

		private function handleMouseUp(event : MouseEvent) : void {
			_isDown = false;
			
			if (_isOver) {
				_target.drawOverState();
			}
			
			targetAsSprite.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
	}
}
