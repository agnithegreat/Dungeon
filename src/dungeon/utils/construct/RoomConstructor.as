package dungeon.utils.construct {
	import dungeon.personage.Monster;
	import dungeon.map.interaction.Ladder;
	import dungeon.map.construct.Wall;
	import dungeon.map.construct.Floor;
	import dungeon.map.interaction.FrontTorch;
	import dungeon.map.interaction.WallTorch;
	import dungeon.map.interaction.Torch;
	import dungeon.map.Background;
	import dungeon.system.GameObjectSection;
	
	/**
	 * @author desktop
	 */
	public class RoomConstructor {
		
		private static var _room: GameObjectSection;
		public static function constructRoom($room: GameObjectSection):void {
			_room = $room;
			
			createBackground();
			createLadders();
			createTorches();
			createMonsters();
			createFloors();
			createWalls();
			
			_room = null;
		}
		
		private static function createBackground():void {
			var back: Background = new Background(_room.bounds.width, _room.bounds.height);
			back.x = _room.bounds.x;
			back.y = _room.bounds.y;
			_room.addObject(back);
		}
		
		private static function createLadders():void {
			var ladder: Ladder = new Ladder(_room.bounds.height*0.8);
			ladder.x = _room.bounds.x+_room.bounds.width/2;
			ladder.y = _room.bounds.y-_room.bounds.height*0.2;
			_room.addObject(ladder);
		}
		
		private static function createTorches():void {
			var torch: Torch = new WallTorch(true);
			torch.x = _room.bounds.x+16;
			torch.y = _room.bounds.y+_room.bounds.height-10;
			_room.addObject(torch);
			
			torch = new WallTorch(false);
			torch.x = _room.bounds.x+_room.bounds.width-16;
			torch.y = _room.bounds.y+_room.bounds.height-10;
			_room.addObject(torch);
			
			var amount: int = _room.bounds.width / 200;
			var range: int = _room.bounds.width/amount;
			
			for (var i : int = 1; i < amount-1; i++) {
				torch = new FrontTorch();
				torch.x = _room.bounds.x+i*range;
				torch.y = _room.bounds.y+_room.bounds.height-10;
				_room.addObject(torch);
			}
		}
		
		private static function createFloors():void {
			var floor: Floor = new Floor(_room.bounds.width);
			floor.x = _room.bounds.x;
			floor.y = _room.bounds.y+_room.bounds.height-16;
			_room.addObject(floor);
		}
		
		private static function createWalls():void {
			var wall: Wall = new Wall(_room.bounds.height-16,true);
			wall.x = _room.bounds.x;
			wall.y = _room.bounds.y;
			_room.addObject(wall);
		
			wall = new Wall(_room.bounds.height-16,false);
			wall.x = _room.bounds.x+_room.bounds.width;
			wall.y = _room.bounds.y;
			_room.addObject(wall);
		}
		
		private static function createMonsters():void {
			if (Math.random()>0.5) {
				var monster: Monster = new Monster();
				monster.x = _room.bounds.x+_room.bounds.width*(Math.random()*0.6+0.2);
				monster.y = _room.bounds.y+_room.bounds.height-30;
				_room.addObject(monster);
			}
		}
	}
}
