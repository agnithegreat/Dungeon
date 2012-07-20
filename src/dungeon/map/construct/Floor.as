package dungeon.map.construct
{
	import assets.FloorSegmentUI;
	
	public class Floor extends Platform
	{
		public function Floor($width: int)
		{
			super();
			
			for (var i: int = 0; i < $width;)
			{
				var segment: FloorSegmentUI = new FloorSegmentUI();
				_container.addChild(segment);
				segment.x = i;
				i += segment.width;
			}
			
			_container.x = $width-width;
		}
	}
}