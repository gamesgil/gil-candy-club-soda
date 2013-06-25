package model.types 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author gil
	 */
	public class Pattern 
	{
		static public const H_FIVELET:Array = [new Point(0, 0), new Point(1, 0), new Point(2, 0), new Point(3, 0), new Point(4, 0)];
		static public const V_FIVELET:Array = [new Point(0, 0), new Point(0, 1), new Point(0, 2), new Point(0, 3), new Point(0, 4)];

		static public const H_QUADRUPLET:Array = [new Point(0, 0), new Point(1, 0), new Point(2, 0), new Point(3, 0)];
		static public const V_QUADRUPLET:Array = [new Point(0, 0), new Point(0, 1), new Point(0, 2), new Point(0, 3)];
		
		static public const H_TRIPLET:Array = [new Point(0, 0), new Point(1, 0), new Point(2, 0)];
		static public const V_TRIPLET:Array = [new Point(0, 0), new Point(0, 1), new Point(0, 2)];
		
		static public const BOMB:Array = [new Point( -1, 0), new Point(0, -1), new Point(0, 0), new Point(1, 0), new Point(0, 1)];
		
		static public const ALL_PATTERNS:Array = [H_FIVELET, V_FIVELET, H_QUADRUPLET, V_QUADRUPLET, H_TRIPLET, V_TRIPLET];
	}

}