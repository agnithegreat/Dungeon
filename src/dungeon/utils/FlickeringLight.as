package dungeon.utils {
	import starling.extensions.lighting.lights.PointLight;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author agnithegreat
	 */
	public class FlickeringLight {
		
		private var _light: PointLight;
		public function get light():PointLight {
			return _light;
		}
		
		private var _timer: Timer;
		
		private var _flickering: int = 3;
		
		private var _x: int;
		public function set x(x : int) : void {
			_x = x;
			handleTimer(null);
		}
		
		private var _y: int;
		public function set y(y : int) : void {
			_y = y;
			handleTimer(null);
		}
		
		private var _radius: int;
		
		public function FlickeringLight(x: int, y: int, radius: int, color: int) {
			_x = x;
			_y = y;
			_radius = radius;
			
			_light = new PointLight(x, y, radius, color);
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		public function start():void {
			_timer.start();
		}
		
		public function stop():void {
			_timer.stop();
		}

		private function handleTimer($e: TimerEvent) : void {
			var power: Number = Math.random()*0.05+0.95;
			
			_light.x += 2*(Math.random()-0.5);
			_light.x = Math.max(_x-_flickering, Math.min(_x, _x+_flickering));
			_light.y += 2*(Math.random()-0.5);
			_light.y = Math.max(_y-_flickering, Math.min(_y, _y+_flickering));
			_light.brightness = power;
			_light.radius = _radius*power;
		}

	}
}
