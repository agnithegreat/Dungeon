package dungeon.map {
	import dungeon.map.interaction.FrontTorch;
	import dungeon.map.interaction.WallTorch;
	import dungeon.map.interaction.Torch;
	import dungeon.personage.Monster;
	import dungeon.personage.Player;
	import dungeon.map.construct.Wall;
	import dungeon.map.construct.Floor;
	import dungeon.map.interaction.Ladder;
	import starling.display.Sprite;

	/**
	 * @author desktop
	 */
	public class DefaultStarlingMap extends Sprite {
		
		public static var mapWidth: int = 768;
		public static var mapHeight: int = 512;
		public static var levelHeight: int = 128;
		
		private var _personage : Player;
		public function get personage():Player {
			return _personage;
		}
		
		private var _monsters : Vector.<Monster>;
		
		public function DefaultStarlingMap()
		{
			build();
		}
		
		public function init():void {
			_personage.init();
			for (var i: int = 0; i < _monsters.length; i++) {
				var monster: Monster = _monsters[i];
				monster.init();
			}
		}
		
		private function build():void {
			createBackground();
			createLadders();
			createTorches();
			createMonsters();
			createPersonage();
			createFloors();
			createWalls();
		}
		
		private function createBackground():void {
			var back: Background = new Background(mapWidth,mapHeight);
			addChild(back);
		}
		
		private function createLadders():void {
			var left: Boolean = false;
			for (var i: int = mapHeight; i > 0 ; i -= levelHeight) {
				var ladder: Ladder = new Ladder(levelHeight+20);
				ladder.x = left ? 160 : mapWidth-160;
				ladder.y = i-(levelHeight+40);
				addChild(ladder);
				left = !left;
			}
		}
		
		private function createTorches():void {
			for (var i: int = mapHeight; i >= 0 ; i -= levelHeight) {
				var torch: Torch = new WallTorch(true);
				torch.x = 16;
				torch.y = i-10;
				addChild(torch);
				torch.interact();
				
				torch = new FrontTorch();
				torch.x = mapWidth*0.35;
				torch.y = i-10;
				addChild(torch);
				
				torch = new FrontTorch();
				torch.x = mapWidth*0.65;
				torch.y = i-10;
				addChild(torch);
				
				torch = new WallTorch(false);
				torch.x = mapWidth-16;
				torch.y = i-10;
				addChild(torch);
				torch.interact();
			}
		}
		
		private function createFloors():void {
			for (var i: int = mapHeight; i > 0 ; i -= levelHeight) {
				var floor: Floor = new Floor(mapWidth);
				floor.y = i-20;
				addChild(floor);
			}
		}
		
		private function createWalls():void {
			for (var i: int = mapHeight; i > 0 ; i -= levelHeight) {
				var wall: Wall = new Wall(levelHeight-20,true);
				wall.y = i-levelHeight;
				addChild(wall);
			
				wall = new Wall(levelHeight-20,false);
				wall.x = mapWidth;
				wall.y = i-levelHeight;
				addChild(wall);
			}
		}
		
		private function createPersonage():void {
			_personage = new Player();
			_personage.x = mapWidth*0.5;
			_personage.y = mapHeight*0.6;
			addChild(_personage); 
		}
		
		private function createMonsters():void {
			_monsters = new Vector.<Monster>();
			for (var i: int = 0; i < 1; i++) {
				var monster: Monster = new Monster();
				_monsters.push(monster);
				monster.x = mapWidth*((i+1)/(_monsters.length+1));
				monster.y = mapHeight*0.3;
				addChild(monster);
			}
		}
	}
}
