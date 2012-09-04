package dungeon.map.construct {
	import dungeon.map.GameObject;

	/**
	 * @author agnithegreat
	 */
	public class Resizable extends GameObject {
		
		public function Resizable($width: int = 0, $height: int = 0) {
			super();
			resize($width, $height);
		}
		
		public function resize($width: int = 0, $height: int = 0):void {
			
		}
	}
}
