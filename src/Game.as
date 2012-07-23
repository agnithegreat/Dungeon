package {
	import dungeon.system.GameSystem;
	import starling.display.Sprite;

	/**
	 * @author desktop
	 */
	public class Game extends Sprite {
		
		public function Game() {
			var view: Sprite = new Sprite();
			addChild(view);
			GameSystem.init(view);
		}
	}
}
