package dungeon.personage {
	import nape.dynamics.InteractionFilter;
	import nape.callbacks.CbType;
	import nape.shape.Polygon;
	import nape.phys.Material;
	import nape.phys.BodyType;
	
	import dungeon.map.interaction.Ladder;
	import flash.geom.Rectangle;
	import dungeon.events.GameObjectEvent;
	import dungeon.system.GameSystem;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import dungeon.map.interaction.InteractiveObject;
	import dungeon.map.GameObject;
	
	public class Personage extends GameObject {
		
		public static const PERSONAGE: CbType = new CbType();
		public static const PERSONAGE_FILTER: InteractionFilter = new InteractionFilter(0x0100, ~0x0100);		
		public static const CLIMB_FILTER: InteractionFilter = new InteractionFilter(0x0100, 0);		
		
		override public function get z():uint {
			return 0xA0000;
		}
		
		protected var _personage: Image;
		
		protected var _interactive: Boolean;
		protected var _interaction: InteractiveObject;
		
		protected var _allowJump: Boolean = true;
		protected var _canClimb: Boolean;
		protected var _climb: Boolean;
		protected var _side: Boolean = true;
		protected var _lockTime: int;
		
		public function get onTheFloor():Boolean {
			return _body ? _body.normalImpulse().y<0 : false;
		}
		
		public function get locked():Boolean {
			return _lockTime>0;
		}
		
		public function Personage($class: Class, $interactive: Boolean = false) {
			super(BodyType.DYNAMIC);
			
			var pers: MovieClip = new $class();
			var bmd: BitmapData = new BitmapData(pers.width, pers.height, true, 0x00000000);
			bmd.draw(pers);
			var texture: Texture = Texture.fromBitmapData(bmd);
			
			_personage = new Image(texture);
			_container.addChild(_personage);
			
			_interactive = $interactive;
		}
		
		override protected function initBody():void {
			super.initBody();
			_body.allowRotation = false;
			_body.cbType = PERSONAGE;
			
			_shape = new Polygon(Polygon.box(_container.width, _container.height), new Material(0, 0, 100000, 100, 100000), PERSONAGE_FILTER);
			_shape.body = _body;
			_body.align();
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
			x = _body.position.x;
			y = _body.position.y;
			
			if (_lockTime>0) {
				_lockTime -= e.data as int;
			}
		}
		
		override public function init():void {
			super.init();
			
			_personage.pivotX = _personage.width/2;
			_personage.pivotY = _personage.height/2;
			
			appear();
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
			walkPhase();
			
			if (_interactive && _climb) {
				_shape.filter = CLIMB_FILTER;
				climbPhase();
				_body.velocity.y -= _body.space.gravity.y*GameSystem.delay;
			}
			if (!_climb) {
				_shape.filter = PERSONAGE_FILTER;
			}
			
			if (_interactive) {
				_interaction = null;
				
				var canClimb: Boolean = false;
				var interactives: Array = GameSystem.checkInteraction(this);
				for (var i: int = 0; i < interactives.length; i++) {
					var interaction: InteractiveObject = interactives[i];
					if (interaction is Ladder) {
						var rect: Rectangle = interaction.getBounds(interaction);
						var bound: Rectangle = _personage.getBounds(interaction);
						var intersection: Rectangle = rect.intersection(bound);
						if (intersection.width>bound.width*0.5) {
							canClimb = true;
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
		
		protected function walkPhase():void {
			if (_body.velocity.x) {
				if (_climb) {
					_climb = false;
				}
			}
		}
		
		protected function climbPhase():void {
			var verticalInteractions: Array = GameSystem.checkInteraction(this);
			if (verticalInteractions.length>0) {
				var ladder: Ladder = verticalInteractions[0] as Ladder;
				if (ladder) {
					var rect: Rectangle = ladder.bounds;
					if (rect.y+rect.height < _shape.bounds.y+_shape.bounds.height && _body.velocity.y>0 ||
						rect.y >= _shape.bounds.y+_shape.bounds.height/2) {
							_body.velocity.y = 0;
							_climb = false;
							return;
					}
					_body.position.x = ladder.x;
				}
			}
		}
		
		public function turn($left: Boolean):void {
			_side = $left;
			_personage.scaleX = _side ? 1 : -1;
		}
	}
}