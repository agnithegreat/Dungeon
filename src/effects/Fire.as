package effects {
	import starling.core.Starling;
	import assets.Assets;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	/**
	 * @author desktop
	 */
	public class Fire extends Sprite {
		
		private var _fire: MovieClip;
		
		public function Fire() {
			_fire = new MovieClip(Assets.getAtlas().getTextures());
			addChild(_fire);
		}
		
		public function activate():void {
			Starling.juggler.add(_fire);
		}
		
		public function deactivate():void {
			Starling.juggler.remove(_fire);
		}
	}
}
