package editor {
	import starling.display.Sprite;
	
	/**
	 * @author agnithegreat
	 */
	public class LevelEditor extends Sprite {
		
		private var _levelView: LevelView;
		
		public function LevelEditor() {
			_levelView = new LevelView();
			addChild(_levelView);
		}
	}
}
