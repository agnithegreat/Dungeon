package dungeon.personage {
	import dungeon.utils.FlickeringLight;
	import assets.PersonageUI;
	
	import dungeon.events.GameObjectEvent;
	import dungeon.system.GameSystem;
	
	import flash.ui.Keyboard;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Player extends Personage {
		
		private static var speed: Number = 4;
		private static var climbSpeed: Number = 3;
		private static var jumpSpeed: Number = 12;
		private static var lockOnJump: Boolean = false;
		
		private var _controls: Object = {};
		
		private var _light: FlickeringLight;
		
		public function Player() {
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
			
			_light = new FlickeringLight(x, y, 100, 0xFFFF99);
			GameSystem.addLight(_light.light);
			_light.start();
		}

		private function handleAddedToStage(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		
		override protected function handleTick(e: GameObjectEvent):void {
			super.handleTick(e);
			
			if (locked) {
				return;
			}
			
			var vSpeedChanged: Boolean = false;
			var hSpeedChanged: Boolean = false;
			
			for (var i: String in _controls) {
				switch (int(i)) {
					case Keyboard.LEFT:
						if (!lockOnJump || onTheFloor || _climb) {
							turn(true);
							_body.velocity.x = -speed;
							vSpeedChanged = true;
						}
						break;
					case Keyboard.RIGHT:
						if (!lockOnJump || onTheFloor || _climb) {
							turn(false);
							_body.velocity.x = speed;
							vSpeedChanged = true;
						}
						break;
					case Keyboard.UP:
						if (_canClimb) {
							_climb = true;
							_body.velocity.y = -climbSpeed;
							hSpeedChanged = true;
						}
						break;
					case Keyboard.DOWN:
						if (_canClimb) {
							_climb = true;
							_body.velocity.y = climbSpeed;
							hSpeedChanged = true;
						}
						break;
				}
			}
			
			if ((!lockOnJump || onTheFloor) && !vSpeedChanged) {
				_body.velocity.x = 0;
			}
			if (_climb && !hSpeedChanged) {
				_body.velocity.y = 0;
			}
			move();
		}
		
		override public function move():void {
			super.move();
			
			_light.x = _side ? x-5 : x+5;
			_light.y = y;
		}
		
		private function interact():void {
			if (_interaction) {
				_interaction.interact();
			}
		}
		
		private function handleKeyDown(e: KeyboardEvent):void {
			var i: int = e.keyCode;
			if (!_controls.hasOwnProperty(i)) {
				_controls[e.keyCode] = i;
			}
			switch (i) {
				case Keyboard.UP:
					if (_allowJump && !_canClimb && onTheFloor) {
						_body.velocity.y = -jumpSpeed;
					}
					_allowJump = false;
					break;
				case Keyboard.ENTER:
					_controls[i] = false;
					interact();
					break;
			}
		}
		
		private function handleKeyUp(e: KeyboardEvent):void {
			var i: int = e.keyCode;
			switch (i) {
				case Keyboard.UP:
					_allowJump = true;
					break;
			}
			delete _controls[e.keyCode];
		}
	}
}