package dungeon.personage
{
	import dungeon.map.interaction.Ladder;
	import dungeon.map.construct.Wall;
	import dungeon.map.construct.Platform;
	import flash.geom.Rectangle;
	import dungeon.events.GameObjectEvent;
	import dungeon.system.GameSystem;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import dungeon.map.interaction.InteractiveObject;
	import flash.geom.Point;
	import dungeon.map.GameObject;
	
	public class Personage extends GameObject
	{
		override public function get z():uint {
			return 0xA000;
		}
		
		protected var _personage: Image;
		
		protected var _interactive: Boolean;
		protected var _interaction: InteractiveObject;
		
		protected var _speedX: Number;
		protected var _speedY: Number;
		protected var _onTheFloor: Boolean;
		protected var _canClimb: Boolean;
		protected var _climb: Boolean;
		protected var _jumpHeight: int;
		protected var _side: Boolean = true;
		
		public function Personage($class: Class, $interactive: Boolean = false)
		{
			super();
			
			var pers: MovieClip = new $class();
			var bmd: BitmapData = new BitmapData(pers.width, pers.height, true, 0x00000000);
			bmd.draw(pers);
			var texture: Texture = Texture.fromBitmapData(bmd);
			
			_personage = new Image(texture);
			_container.addChild(_personage);
			
			_interactive = $interactive;
			
			_speedX = 0;
			_speedY = 0;
		}
		
		override protected function addToGameSystem():void {
			super.addToGameSystem();
			GameSystem.registerPersonage(this);
		}
		
		override protected function removeFromGameSystem():void {
			super.removeFromGameSystem();
			GameSystem.clearPersonage(this);
		}
		
		override protected function handleTick(e: GameObjectEvent):void {
			move();
		}
		
		override public function init():void {
			super.init();
			
			_personage.pivotX = _personage.width/2;
			_personage.pivotY = _personage.height+1;
		}
		
		public function doDamage():void {
			if (false) {
				kill();
			} else {
				blink();
			}
		}
		
		private function blink():void {
			
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
			
			moveByY();
			
			if (_interactive && _climb) {
				climbPhase();
			}
			
			if (!_onTheFloor) {
				_speedY -= GameSystem.GRAVITY;
			}

			checkFall();
			
			if (_interactive) {
				_interaction = null;
				
				var canClimb: Boolean = false;
				var interactives: Array = GameSystem.checkInteraction(this);
				for (var i: int = 0; i < interactives.length; i++) {
					var interaction: InteractiveObject = interactives[i];
					if (interaction is Ladder) {
						var rect: Rectangle = interaction.bounds;
						var bound: Rectangle = _personage.bounds;
						if (rect.y+rect.height >= bound.y+bound.height) {
							canClimb = true;
						} else {
							checkFall();
						}
					} else {
						_interaction = interaction;
					}
				}
				_canClimb = canClimb;
			}
			
			checkHits();
		}
		
		private function checkHits():void {
			var hits: Array = GameSystem.checkPersonageHit(this);
			for (var i: int = 0; i < hits.length; i++) {
				var hit: Personage = hits[i];
				if (hit.y < y) {
					doDamage();
				}
			}
		}
		
		private function moveByY():void {
			var module: int = _speedY<0 ? -1 : 1;
			var yMoved: Number = 0;
			var yMove: Number = 0;
			while (_speedY-yMoved) {
				yMove = (_speedY-yMoved)*module>10 ? 10 : (_speedY-yMoved)*module;
				y += yMove*module;
				if (checkFall()) {
					yMoved += yMove*module;
				} else {
					return;
				}
			}
		}
		
		protected function walkPhase():void {
			x += _speedX;
			var sideCollisions: Array = GameSystem.checkCollisions(this);
			if (sideCollisions.length>0) {
				if (sideCollisions[0] is Wall) {
					fixPosition(sideCollisions[0], new Point(_speedX,0));
					return;
				}
				_speedX = 0;
			}
			if (_speedX) {
				if (_climb) {
					_onTheFloor = false;
					_climb = false;
				}
			}
		}
		
		protected function checkFall():Boolean {
			if (_climb) {
				return true;
			}
			
			if (_speedY < 0) {
				var topCollisions: Array = GameSystem.checkCollisions(this);
				if (topCollisions.length>0) {
					if (topCollisions[0] is Platform) {
						fixPosition(topCollisions[0], new Point(0, -1));
					}
					_speedY = 0;
					_jumpHeight = int.MAX_VALUE;
				}
			} else {
				var bottomCollisions: Array = GameSystem.checkCollisions(this);
				if (bottomCollisions.length>0) {
					fixPosition(bottomCollisions[0], new Point(0, 1));
					_speedY = 0;
					_onTheFloor = true;
					_jumpHeight = 0;
					return false;
				} else {
					_onTheFloor = false;
				}
			}
			return true;
		}
		
		protected function climbPhase():void {
			var verticalInteractions: Array = GameSystem.checkInteraction(this);
			if (verticalInteractions.length>0) {
				var ladder: Ladder = verticalInteractions[0] as Ladder;
				if (ladder) {
					x = ladder.x;
					var rect: Rectangle = ladder.bounds;
					if (rect.y+rect.height >= bounds.y+bounds.height) {
						return;
					}
				}
			}
			_climb = false;
			checkFall();
		}
		
		protected function fixPosition($platform: Platform, $side: Point):void {
			var rect : Rectangle = $platform.bounds;
			var collision: Rectangle = rect.intersection(bounds);
			if ($side.x && _speedX) {
				x += _speedX<0 ? collision.width : -collision.width;
				dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_STUCK_X));
			}
			if ($side.y && _speedY) {
				y += _speedY<0 ? collision.height+1 : -collision.height;
				dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_STUCK_Y));
			}
		}
		
		public function turn($left: Boolean):void {
			_side = $left;
			_personage.scaleX = _side ? 1 : -1;
		}
	}
}