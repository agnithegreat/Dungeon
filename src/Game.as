package {
	import dungeon.system.GameScreen;
	import starling.display.Quad;
	import dungeon.system.GameSystem;
	import starling.display.Sprite;

	/**
	 * @author desktop
	 */
	public class Game extends Sprite {
		
		public function Game() {
			
			addChild(new Quad(GameScreen.screenWidth, GameScreen.screenHeight, 0));
			
			var view: Sprite = new Sprite();
			addChild(view);
			GameSystem.init(view);
		}
	}
}
