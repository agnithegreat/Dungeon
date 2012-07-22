package dungeon.utils.construct {
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
			
//			createLadders();
			
			createTorches();
			createMonsters();
			createFloors();
			createWalls();
			
			_room = null;
		}
		
		private static function createBackground():void {
			var back: Background = new Background(_room.width, _room.height);
			_room.addObject(back);
		}
		
		private static function createLadders():void {
/*			var left: Boolean = false;
			for (var i: int = _room.height; i > 0 ; i -= levelHeight) {
				var ladder: Ladder = new Ladder(levelHeight+20);
				ladder.x = left ? 160 : mapWidth-160;
				ladder.y = i-(levelHeight+40);
				addChild(ladder);
				left = !left;
			}*/
		}
		
		private static function createTorches():void {
			var torch: Torch = new WallTorch(true);
			torch.x = 16;
			torch.y = _room.height-10;
			_room.addObject(torch);
			torch.interact();
			
			torch = new WallTorch(false);
			torch.x = _room.width-16;
			torch.y = _room.height-10;
			_room.addObject(torch);
			torch.interact();
			
			var amount: int = _room.width / 200;
			var range: int = _room.width/amount;
			
			for (var i : int = 1; i < amount-1; i++) {
				torch = new FrontTorch();
				torch.x = i*range;
				torch.y = _room.height-10;
				_room.addObject(torch);
			}
		}
		
		private static function createFloors():void {
			var floor: Floor = new Floor(_room.width);
			floor.y = _room.height-20;
			_room.addObject(floor);
		}
		
		private static function createWalls():void {
			var wall: Wall = new Wall(_room.height-20,true);
			_room.addObject(wall);
		
			wall = new Wall(_room.height-20,false);
			wall.x = _room.width;
			_room.addObject(wall);
		}
		
		private static function createMonsters():void {
/*			_monsters = new Vector.<Monster>();
			for (var i: int = 0; i < 1; i++) {
				var monster: Monster = new Monster();
				_monsters.push(monster);
				monster.x = mapWidth*((i+1)/(_monsters.length+1));
				monster.y = mapHeight*0.3;
				addChild(monster);
			}*/
		}
	}
}
