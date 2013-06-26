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
		
		static public const L_LEFT:Array = [new Point(0, 0), new Point(0, -2), new Point(0, -1), new Point(-1, 0), new Point(-2, 0)];
		static public const L_RIGHT:Array = [new Point(0, 0), new Point(0, -2), new Point(0, -1), new Point(1, 0), new Point(2, 0)];
		static public const L_FLIPPED_RIGHT:Array = [new Point(0, 0), new Point(0, 2), new Point(0, 1), new Point(1, 0), new Point(2, 0)];
		static public const L_FLIPPED_LEFT:Array = [new Point(0, 0), new Point(0, 2), new Point(0, 1), new Point(-1, 0), new Point(-2, 0)];
		
		static public const T_STRAIGHT_BIG:Array = [new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(1, 0), new Point(2, 0), new Point(0, 1), new Point(0, 2)];
		static public const T_FLIPPED_BIG:Array = [new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(1, 0), new Point(2, 0), new Point(0, -1), new Point(0, -2)];
		static public const T_RIGHT_BIG:Array = [new Point(0, 0),new Point(1, 0), new Point(2, 0), new Point(0, -1), new Point(0, -2), new Point(0, 1), new Point(0, 2)];
		static public const T_LEFT_BIG:Array = [new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(0, -1), new Point(0, -2), new Point(0, 1), new Point(0, 2)];
		
		static public const T_STRAIGHT:Array = 	[new Point(0, 0), new Point(-1, 0), new Point(1, 0), new Point(0, 1), new Point(0, 2)];
		static public const T_FLIPPED:Array = 	[new Point(0, 0), new Point(-1, 0), new Point(1, 0), new Point(2, 0), new Point(0, -1)];
		static public const T_RIGHT:Array = 	[new Point(0, 0),new Point(1, 0), new Point(2, 0), new Point(0, -1), new Point(0, 1)];
		static public const T_LEFT:Array = 		[new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(0, -1), new Point(0, 1)];
		
		static public const GUN_RIGHT:Array = [new Point(0, 0), new Point(-1, 0), new Point(1, 0), new Point(2, 0), new Point(0, 1), new Point(0, 2)];
		static public const GUN_LEFT:Array = [new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(1, 0), new Point(0, 1), new Point(0, 2)];
		static public const GUN_RIGHT_FLIPPED:Array = [new Point(0, 0), new Point(-1, 0), new Point(1, 0), new Point(2, 0), new Point(0, -1), new Point(0, -2)];
		static public const GUN_LEFT_FLIPPED:Array = [new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(1, 0), new Point(0, -1), new Point(0, -2)];
		
		static public const GUN_RIGHT_DOWN:Array = [new Point(0, 0), new Point(1, 0), new Point(2, 0), new Point(0, -1), new Point(0, 1), new Point(0, 2)];
		static public const GUN_RIGHT_UP:Array = [new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(0, -2), new Point(0, -1), new Point(0, 1)];
		static public const GUN_LEFT_DOWN:Array = [new Point(0, 0), new Point(-2, 0), new Point(-1, 0), new Point(0, -1), new Point(0, 1), new Point(0, 2)];
		static public const GUN_LEFT_UP:Array = [new Point(0, 0), new Point(1, 0), new Point(2, 0), new Point(0, -2), new Point(0, -1), new Point(0, 1)];
		
		
		static public const BOMB:Array = [new Point( -1, 0), new Point(0, -1), new Point(0, 0), new Point(1, 0), new Point(0, 1)];
		
		static public const ALL_PATTERNS:Array = [
			H_FIVELET, V_FIVELET, 
			H_QUADRUPLET, V_QUADRUPLET, 
			H_TRIPLET, V_TRIPLET, 
			L_LEFT, L_RIGHT, L_FLIPPED_LEFT, L_FLIPPED_RIGHT,
			T_STRAIGHT_BIG, T_FLIPPED_BIG, T_LEFT_BIG, T_RIGHT_BIG,
			T_STRAIGHT, T_FLIPPED, T_LEFT, T_RIGHT,
			GUN_RIGHT, GUN_LEFT, GUN_LEFT_FLIPPED, GUN_RIGHT_FLIPPED,
			GUN_RIGHT_DOWN, GUN_RIGHT_UP, GUN_LEFT_DOWN, GUN_LEFT_UP
			];
	}

}