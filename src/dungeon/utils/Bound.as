package dungeon.utils
{
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Bound
	{
		public var bound: MovieClip;
		public var direction: Point;
		
		public function Bound($bound: MovieClip, $direction: Point) {
			bound = $bound;
			bound.visible = false;
			direction = $direction;
		}
	}
}