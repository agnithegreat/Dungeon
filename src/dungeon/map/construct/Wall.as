package dungeon.map.construct
{
	import assets.WallSegmentUI;
	
	public class Wall extends Platform
	{
		public function Wall($height: int, $isLeftSided: Boolean)
		{
			super();
			
			for (var i: int = 0; i < $height;)
			{
				var segment: WallSegmentUI = new WallSegmentUI();
				_container.addChild(segment);
				segment.scaleX = $isLeftSided ? 1 : -1;
				segment.y = i;
				i += segment.height;
			}
			
			_container.y = $height-height;
		}
	}
}