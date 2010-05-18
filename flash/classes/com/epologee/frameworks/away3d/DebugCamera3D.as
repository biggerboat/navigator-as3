package nl.ing.view.away3dtest.cameras {
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;

	import com.epologee.development.logging.notice;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	/**
	 * <p>
	 * DebugCamera3D serves as a tool to allow you control
	 * the camera with your mouse and keyboard while displaying information
	 * about the camera when testing your swf. Due to its nature,
	 * the Keyboard and Mouse Events may interfere with your custom Keyboard and Mouse Events.
	 * This camera is in no way intended for production use.
	 * </p>
	 * 
	 * <p>
	 * Click and drag for mouse movement. The keys
	 * are setup as follows:
	 * </p>
	 * <pre><code>
	 * w = forward
	 * s = backward
	 * a = left
	 * d = right
	 * q = rotationZ--
	 * e = rotationZ++
	 * r = fov++
	 * f = fov--
	 * t = near++
	 * g = near--
	 * y = far++
	 * h = far--
	 * </code></pre>
	 * 
	 * @author John Lindquist
	 */
	public class DebugCamera3D extends Camera3D {
		private static const MOVE_FACTOR : Number = 30;
		/** @private */
		protected var _inertia : Number = 3;
		/** @private */
		protected var _stage : Stage;
		/** @private */
		protected var startPoint : Point;
		/** @private */
		protected var startRotationY : Number;
		/** @private */
		protected var startRotationX : Number;
		/** @private */
		protected var targetRotationY : Number = 0;
		/** @private */
		protected var targetRotationX : Number = 0;
		/** @private */
		protected var keyRight : Boolean = false;
		/** @private */
		protected var keyLeft : Boolean = false;
		/** @private */
		protected var keyForward : Boolean = false;
		/** @private */
		protected var keyBackward : Boolean = false;
		/** @private */
		protected var forwardFactor : Number = 0;
		/** @private */
		protected var sideFactor : Number = 0;
		//                /** @private */
		//                protected var xText:TextField;
		//                /** @private */
		//                protected var yText:TextField;
		//                /** @private */
		//                protected var zText:TextField;
		//                /** @private */
		//                protected var rotationXText:TextField;
		//                /** @private */
		//                protected var rotationYText:TextField;
		//                /** @private */
		//                protected var rotationZText:TextField;
		//                /** @private */
		//                protected var fovText:TextField;
		//                /** @private */
		//                protected var nearText:TextField;
		//                /** @private */
		//                protected var farText:TextField;
		/** @private */
		protected var _view3D : View3D;

		/**
		 * DebugCamera3D
		 *
		 * @param viewport      Viewport to render to. @see org.papervision3d.view.Viewport3D 
		 * @param fovY          Field of view (vertical) in degrees.
		 * @param near          Distance to near plane.
		 * @param far           Distance to far plane.
		 */
		public function DebugCamera3D(inView3D : View3D) {
			super();
                        
			_view3D = inView3D;
//			x = 1000;
//			y = -1000;
			z = -1000;
                        
			if(_view3D.stage == null) {
				_view3D.addEventListener(Event.ADDED_TO_STAGE, setupEvents);
			} else {
				setupEvents();
			}
		}

		/**
		 * Sets up the Mouse and Keyboard Events required for adjusting the camera properties
		 */
		protected function setupEvents(event:Event = null) : void {
			notice();
			
			_stage = _view3D.stage;
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			_stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		/**
		 *  The default handler for the <code>MouseEvent.MOUSE_DOWN</code> event.
		 *
		 *  @param The event object.
		 */
		protected function handleMouseDown(event : MouseEvent) : void {
			startPoint = new Point(_view3D.mouseX, _view3D.mouseY);
			notice(startPoint);
			startRotationY = this.rotationY;
			startRotationX = this.rotationX;
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}

		/**
		 *  The default handler for the <code>MouseEvent.MOUSE_MOVE</code> event.
		 *
		 *  @param The event object.
		 */
		protected function handleMouseMove(event : MouseEvent) : void {
			
			var dx : Number = (startPoint.x - _view3D.mouseX) / 3;
			var dy : Number = (startPoint.y - _view3D.mouseY) / 3;
			
			targetRotationY = startRotationY - dx;
			targetRotationX = startRotationX + dy;

			notice([targetRotationX, targetRotationY]);
		}

		/**
		 *  Removes the mouseMoveHandler on the <code>MouseEvent.MOUSE_UP</code> event.
		 *
		 *  @param The event object.
		 */
		protected function handleMouseUp(event : MouseEvent) : void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}

		/**
		 *  Adjusts the camera based on the keyCode from the <code>KeyboardEvent.KEY_DOWN</code> event.
		 *
		 *  @param The event object.
		 */
		protected function handleKeyDown(event : KeyboardEvent) : void {
			notice();
			switch( event.keyCode ) {
				case "W".charCodeAt():
				case Keyboard.UP:
					keyForward = true;
					keyBackward = false;
					break;
        
				case "S".charCodeAt():
				case Keyboard.DOWN:
					keyBackward = true;
					keyForward = false;
					break;
        
				case "A".charCodeAt():
				case Keyboard.LEFT:
					keyLeft = true;
					keyRight = false;
					break;
        
				case "D".charCodeAt():
				case Keyboard.RIGHT:
					keyRight = true;
					keyLeft = false;
					break;
                                        
				case "Q".charCodeAt():
					rotationZ--;
					break;
                                
				case "E".charCodeAt():
					rotationZ++;
					break;
                                
//				case "F".charCodeAt():
//					fov--;
//					break;
//                                        
//				case "R".charCodeAt():
//					fov++;
//					break;
//                                        
//				case "G".charCodeAt():
//					near -= 10;
//					break;
//                                        
//				case "T".charCodeAt():
//					near += 10;
//					break;
//                                        
//				case "H".charCodeAt():
//					far -= 10;
//					break;
//                                        
//				case "Y".charCodeAt():
//					far += 10;
//					break;
			}
		}

		/**
		 *  Checks which Key is released on the <code>KeyboardEvent.KEY_UP</code> event
		 *  and toggles that key's movement off.
		 *
		 *  @param The event object.
		 */
		protected function handleKeyUp(event : KeyboardEvent) : void {
			switch( event.keyCode ) {
				case "W".charCodeAt():
				case Keyboard.UP:
					keyForward = false;
					break;
        
				case "S".charCodeAt():
				case Keyboard.DOWN:
					keyBackward = false;
					break;
        
				case "A".charCodeAt():
				case Keyboard.LEFT:
					keyLeft = false;
					break;
        
				case "D".charCodeAt():
				case Keyboard.RIGHT:
					keyRight = false;
					break;
			}
		}

		/**
		 *  Checks which keys are down and adjusts the camera accorindingly on the <code>Event.ENTER_FRAME</code> event.
		 *  Also updates the display of properties.
		 *
		 *  @param The event object.
		 */
		protected function handleEnterFrame(event : Event) : void {
			if(keyForward) {
				forwardFactor += MOVE_FACTOR;
			}
			if(keyBackward) {
				forwardFactor += -MOVE_FACTOR;
			}
			if(keyLeft) {
				sideFactor += -MOVE_FACTOR;
			}
			if(keyRight) {
				sideFactor += MOVE_FACTOR;
			}
                        
			// rotation
			rotationX = (rotationX + ( targetRotationX - this.rotationX ) / _inertia);
			rotationY = (rotationY + ( targetRotationY - this.rotationY ) / _inertia);
			
			if (forwardFactor) {
				moveForward(forwardFactor);
			}
			if (sideFactor) {
				moveRight(sideFactor);
//				this.transform.matrix3D.prependTranslation(sideFactor, 0, forwardFactor);
			}
			
			// position
			forwardFactor += ( 0 - forwardFactor ) / _inertia;
			sideFactor += ( 0 - sideFactor ) / _inertia;
		}

		/**
		 * The amount of resistance to the change in velocity when updating the camera rotation with the mouse
		 */
		public function get inertia() : Number {
			return _inertia;
		}

		public function set inertia(inertia : Number) : void {
			_inertia = inertia;
		}
	}
}
