package dungeon.personage
{
	import dungeon.events.GameObjectEvent;
	import dungeon.map.GameObject;
	import dungeon.map.interaction.InteractiveObject;
	import dungeon.map.interaction.Ladder;
	import dungeon.map.construct.Platform;
	import dungeon.map.construct.Wall;
	import dungeon.system.GameSystem;
	import dungeon.utils.Bound;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class Personage extends GameObject
	{
		protected var _bounds: Array = [];
		protected function getBound($point: Point):Bound {
			for (var i: int = 0; i < _bounds.length; i++) {
				var bound: Bound = _bounds[i];
				if (bound.direction.x*$point.x>0 || bound.direction.y*$point.y>0) {
					return bound;
				}
			}
			return null;
		}
		
		protected var _personage: MovieClip;
		
		protected var _interactive: Boolean;
		protected var _interaction: InteractiveObject;
		
		protected var _speedX: Number;
		protected var _speedY: Number;
		protected var _onTheFloor: Boolean;
		protected var _canClimb: Boolean;
		protected var _climb: Boolean;
		protected var _jumped: Boolean;
		protected var _doubleJumped: Boolean;
		protected var _side: Boolean = true;
		
		protected var _timer: Timer;
		
		public function Personage($class: Class, $interactive: Boolean = false)
		{
			super();
			
			GameSystem.registerPersonage(this);
			
			_personage = new $class();
			_container.addChild(_personage);
			
			_interactive = $interactive;
			
			_bounds = [new Bound(_personage.bound_bottom, new Point(0,1)),
				new Bound(_personage.bound_left, new Point(-1,0)),
				new Bound(_personage.bound_right, new Point(1,0)),
				new Bound(_personage.bound_top, new Point(0,-1))];
			
			_speedX = 0;
			_speedY = 0;
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		protected function handleTimer(e: TimerEvent):void {
			move();
		}
		
		public function init():void {
			_timer.start();
		}
		
		public function doDamage():void {
			kill();
		}
		
		public function kill():void {
			dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_DESTROY));
			GameSystem.clearPersonage(this);
			parent.removeChild(this);
			destroy();
		}
		
		public function move():void {
			if (_speedX) {
				walkPhase();
			}
			
			y += _speedY;
			
			if (_interactive && _climb) {
				climbPhase();
			} else {
				fallPhase();
			}
			
			if (_interactive) {
				_interaction = null;
				
				var canClimb: Boolean = false;
				var interactives: Array = GameSystem.checkInteraction(_personage);
				for (var i: int = 0; i < interactives.length; i++) {
					var interaction: InteractiveObject = interactives[i];
					if (interaction is Ladder) {
						var rect: Rectangle = interaction.getBounds(parent);
						var bound: Rectangle = _personage.bound_bottom.getBounds(parent);
						if (rect.y+rect.height >= bound.y+bound.height) {
							canClimb = true;
						} else {
							fallPhase();
						}
					} else {
						_interaction = interaction;
					}
				}
				_canClimb = canClimb;
			}
		}
		
		protected function walkPhase():void {
			var sideCollisions: Array = GameSystem.checkCollisions(_side ? _personage.bound_left : _personage.bound_right);
			if (sideCollisions.length>0) {
				if (sideCollisions[0] is Wall) {
					fixPosition(sideCollisions[0], new Point(_speedX,0));
				}
				_speedX = 0;
			}
			x += _speedX;
			if (_speedX) {
				_climb = false;
			}
		}
		
		protected function fallPhase():void {
			if (_onTheFloor) {
				_speedY = 0;
			} else {
				_speedY -= GameSystem.GRAVITY;
			}
			
			var bottomCollisions: Array = GameSystem.checkCollisions(_personage.bound_bottom);
			if (bottomCollisions.length>0) {
				fixPosition(bottomCollisions[0], new Point(0, 1));
				_speedY = 0;
				_onTheFloor = true;
				_doubleJumped = false;
			} else {
				_onTheFloor = false;
			}
			
			var topCollisions: Array = GameSystem.checkCollisions(_personage.bound_top);
			if (topCollisions.length>0) {
				if (topCollisions[0] is Platform) {
					fixPosition(topCollisions[0], new Point(0, -1));
				}
				_speedY = 0;
			}
		}
		
		protected function climbPhase():void {
			var verticalInteractions: Array = GameSystem.checkInteraction(_personage);
			if (verticalInteractions.length>0) {
				var ladder: Ladder = verticalInteractions[0] as Ladder;
				if (ladder) {
					x = ladder.x;
					var rect: Rectangle = ladder.getBounds(parent);
					var bound: Rectangle = _personage.bound_bottom.getBounds(parent);
					if (rect.y+rect.height >= bound.y+bound.height) {
						return;
					}
				}
			}
			_speedY = 0;
			_climb = false;
			_onTheFloor = false;
		}
		
		protected function fixPosition($platform: Platform, $side: Point):void {
			var rect: Rectangle = $platform.getBounds(parent);
			var bnd: Bound = getBound($side);
			var bound: Rectangle = bnd.bound.getBounds(_personage);
			if ($side.x) {
				x = $side.x<0 ? rect.x+rect.width-bound.x : rect.x-(bound.x+bound.width);
			}
			if ($side.y) {
				y = $side.y<0 ? rect.y+rect.height-bound.y+1 : rect.y-(bound.y+bound.height);
			}
		}
		
		public function turn($left: Boolean):void {
			_side = $left;
		}
		
		public function destroy():void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, handleTimer);
			_timer = null;
		}
	}
}