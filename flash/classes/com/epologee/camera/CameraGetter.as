package com.epologee.camera {
	import com.epologee.development.logging.debug;
	import com.epologee.time.Stopwatch;

	import flash.events.ActivityEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.utils.Timer;

	/**	 * @author Eric-Paul Lecluse | epocom (c) 2009	 */	public class CameraGetter extends EventDispatcher {
		private var _favorArea:Boolean;
		private var _fps:int;
		private var _width:int;
		private var _height:int;
		//
		private var _camera:Camera;
		private var _status:String;
		private var _working:Boolean;
		private var _stopwatch:Stopwatch;
		private var _tried:Array;

		public function get camera():Camera {
			return _camera;
		}

		public function CameraGetter(inWidth:int = 640, inHeight:int = 480, inFPS:int = 30, inFavorArea:Boolean = true) {
			super();
			_width = inWidth;
			_height = inHeight;
			_fps = inFPS;
			_favorArea = inFavorArea;
			_tried = [];
			
			cycleCameras();
		}

		private function cycleCameras():void {
			_camera = Camera.getCamera();
			debug("cycleCameras: "+_camera.name);
			
			if (_camera) {
				_camera.setMode(_width, _height, _fps, _favorArea);
				_camera.addEventListener(StatusEvent.STATUS, handleCameraStatus);
				_camera.addEventListener(ActivityEvent.ACTIVITY, handleCameraActivity);
			}
		}

		private function handleCameraActivity(event:ActivityEvent):void {
			debug("handleCameraActivity: " + event.activating);
		}

		private function handleTimerEvent(event:TimerEvent):void {
			debug("handleTimerEvent: " + _camera.currentFPS);
			if (_camera.currentFPS > 0) {
				_working = true;
				event.target.removeEventListener(event.type, handleTimerEvent);
			}
		}

		private function handleCameraStatus(event:StatusEvent):void {
			_status = event.code;
			debug("handleCameraStatus: " + event.code);
			
			var ti:Timer = new Timer(100);
			ti.addEventListener(TimerEvent.TIMER, handleTimerEvent);
			ti.start();
			
			_stopwatch = new Stopwatch();
			_stopwatch.start();
		}
	}}