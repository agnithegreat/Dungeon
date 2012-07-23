package {
	import starling.display.Quad;
	import dungeon.system.GameSystem;
	import starling.display.Sprite;

	/**
	 * @author desktop
	 */
	public class Game extends Sprite {
		
		public function Game() {
			addChild(new Quad(Dungeon.gameWidth, Dungeon.gameHeight, 0));
			
			var view: Sprite = new Sprite();
			addChild(view);
			GameSystem.init(view);
		}
	}
}
