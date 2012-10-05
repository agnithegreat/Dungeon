package dungeon.personage
{
	import assets.PersonageUI;
	
	import dungeon.events.GameObjectEvent;
	import dungeon.map.construct.Background;
	import dungeon.system.GameSystem;
	import dungeon.utils.RoundShadowKicker;
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Player extends Personage
	{
		private static var speed: Number = 3;
		private static var climbSpeed: Number = 5;
		private static var jumpSpeed: Number = 6;
		private static var lockOnJump: Boolean = false;
		private static var doubleJump: Boolean = true;
		
		private var _controls: Object = {};
		
		private var _castPlace: MovieClip;
		
		public function Player()
		{
			super(PersonageUI, true);
			
//			_castPlace = _personage.pers.castPlace;
		}
		
		override public function init():void {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			super.init();
			
			appear();
		}
		
		override public function appear():void {
			if (_appeared) {
				return;
			}
			super.appear();
			GameSystem.addShadowKicker(new RoundShadowKicker(this, 80, false));
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
			
			for each (var i: int in _controls) {
				switch (i) {
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
						} else if (_onTheFloor || (doubleJump && !_doubleJumped)) {
							// переделать на блокировку прыжка до Key.release {
								_controls[i] = false;
							// }
									
							if (_onTheFloor) { 
								_onTheFloor = false;
							} else {
								_doubleJumped = true;
							}
							_speedY = -jumpSpeed;
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
		
		override public function move():void {
			super.move();
			
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
			delete _controls[e.keyCode];
		}
	}
}