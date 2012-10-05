package dungeon.map.construct
{
	import dungeon.map.GameObject;
	import dungeon.system.GameSystem;
	import dungeon.utils.ShadowKicker;

	public class Platform extends GameObject implements IResizable
	{
		override public function get z():uint {
			return 0xA0000;
		}
		
		public function Platform($width: int = 0, $height: int = 0) {
			super();
			resize($width, $height);
		}
		
		override public function appear():void {
			if (_appeared) {
				return;
			}
			super.appear();
			GameSystem.addShadowKicker(new ShadowKicker(this));
		}
		
		public function resize($width: int = 0, $height: int = 0):void {
		}
		
		override protected function addToGameSystem():void {
			super.addToGameSystem();
			GameSystem.registerPlatform(this);
		}
		
		override protected function removeFromGameSystem():void {
			super.removeFromGameSystem();
			GameSystem.clearPlatform(this);
		}
	}
}