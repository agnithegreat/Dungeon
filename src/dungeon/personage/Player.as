package dungeon.personage
{
	import starling.extensions.lighting.lights.PointLight;
	import assets.PersonageUI;
	
	import dungeon.events.GameObjectEvent;
	import dungeon.system.GameSystem;
	
	import flash.ui.Keyboard;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Player extends Personage
	{
		private static var speed: Number = 3;
		private static var climbSpeed: Number = 5;
		private static var jumpSpeed: Number = 5;
		private static var maxJumpSpeed: Number = 40;
		private static var lockOnJump: Boolean = false;
		
		private var _controls: Object = {};
		
		private var _light: PointLight;
		
		public function Player()
		{
			super(PersonageUI, true);
		}
		
		override public function init():void {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			super.init();
		}
		
		override public function appear():void {
			if (_appeared) {
				return;
			}
			super.appear();
			
			_light = new PointLight(x, y, 100, 0xFF6699);
			GameSystem.addShadowKicker(_light);
		}

		private function handleAddedToStage(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		
		public function doFireball():void {
/*			var fireball: Fireball = new Fireball(this);
			var pos: Point = _castPlace.localToGlobal(new Point());
			fireball.x = pos.x;
			fireball.y = pos.y;
			fireball.scaleX = _side ? 1 : -1;
			parent.addChild(fireball);
			fireball.init();*/
		}
		
		override protected function handleTick(e: GameObjectEvent):void {
			var vSpeedChanged: Boolean = false;
			var hSpeedChanged: Boolean = false;
			
			for (var i: String in _controls) {
				switch (int(i)) {
					case Keyboard.LEFT:
						if (!lockOnJump || _onTheFloor) {
							turn(true);
							_speedX = -speed;
							vSpeedChanged = true;
						}
						break;
					case Keyboard.RIGHT:
						if (!lockOnJump || _onTheFloor) {
							turn(false);
							_speedX = speed;
							vSpeedChanged = true;
						}
						break;
					case Keyboard.UP:
						if (_canClimb) {
							_climb = true;
							_onTheFloor = true;
							_speedY = -climbSpeed;
							hSpeedChanged = true;
						} else if (_jumpHeight<maxJumpSpeed) {
							_onTheFloor = false;
							var jumpDelta: int = Math.min(jumpSpeed, maxJumpSpeed-_jumpHeight);
							_speedY = -jumpDelta;
							_jumpHeight += jumpDelta;
						}
						break;
					case Keyboard.DOWN:
						if (_canClimb) {
							_climb = true;
							_speedY = climbSpeed;
							hSpeedChanged = true;
						}
						break;
					case Keyboard.SPACE:
						_controls[i] = false;
						if (_interaction) {
							interact();
						} else {
							doFireball();
						}
						break;
				}
			}
			
			if ((!lockOnJump || _onTheFloor) && !vSpeedChanged) {
				_speedX = 0;
			}
			if (_climb && !hSpeedChanged) {
				_speedY = 0;
			}
			move();
		}
		
		override protected function checkFall():Boolean {
			if (y>GameSystem.map.mapHeight) {
				y = -50;
			}
			
			return super.checkFall();
		}
		
		override public function move():void {
			super.move();
			
			_light.x = x;
			_light.y = y;
			
			var rooms: Array = GameSystem.checkRooms(this);
			if (rooms.length>0) {
				rooms[0].appear();
			}
		}
		
		private function interact():void {
			if (_interaction) {
				_interaction.interact();
			}
		}
		
		private function handleKeyDown(e: KeyboardEvent):void {
			if (!_controls.hasOwnProperty(e.keyCode)) {
				_controls[e.keyCode] = e.keyCode;
			}
		}
		
		private function handleKeyUp(e: KeyboardEvent):void {
			var i: int = e.keyCode;
			switch (i) {
				case Keyboard.UP:
					_jumpHeight = int.MAX_VALUE;
					break;
			}
			delete _controls[e.keyCode];
		}
	}
}