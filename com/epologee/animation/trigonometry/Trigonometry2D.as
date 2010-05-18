package com.epologee.animation.trigonometry {
	import flash.geom.Vector3D;
	import flash.geom.Point;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class Trigonometry2D {
		/**
		 * Returns the point on (infinite) line AB that is nearest to point C.
		 * If @param inLimitToSegment is set, the return point is constrained to the line segment AB.
		 */
		public static function nearestPointOnLine( A : Point, B : Point, C : Point , inLimitToSegment : Boolean = false) : Point {
			var D : Point = new Point();
			
			var dx : Number; 
			var dy : Number;
			var t : Number;
			
			dx = B.x - A.x;
			dy = B.y - A.y;
			
			if ((dx == 0) && (dy == 0)) {
				D.x = A.x;
				D.y = A.y;
			} else {
				t = ((C.x - A.x) * dx + (C.y - A.y) * dy) / (dx * dx + dy * dy);
				if (inLimitToSegment) t = Math.min(Math.max(0, t), 1);
				D.x = A.x + t * dx;
				D.y = A.y + t * dy;
			}
			
			return D;
		}
		
		/**
		 * @return the angle in radians between lines AB and PQ.
		 */
		public static function angleBetweenLines(A:Point, B:Point, P:Point, Q:Point):Number {
			var AB : Point = B.subtract(A);
			var PQ : Point = Q.subtract(P);
			return Math.atan2(PQ.y, PQ.x) - Math.atan2(AB.y, AB.x);
		}
		
		/**
		 * @return the intersection point of (infinite) lines AB and PQ.
		 * If the @param inLimitToSegment is set, will return null if the lines don't intersect on the given line segments AB and PQ. 
		 */
		public static function intersectLines(A:Point, B:Point, P:Point, Q:Point, inLimitToSegment : Boolean) : Point {
			var AB : Point = B.subtract(A);
			var PQ : Point = Q.subtract(P);
			
			var perP2 : Number = AB.x * PQ.y - AB.y * PQ.x;
			if (!perP2) return null;

			var AP : Point = P.subtract(A);
			var perP1 : Number = AP.x * PQ.y - AP.y * PQ.x;
			var t : Number = perP1 / perP2;
			
			if (inLimitToSegment && (t < 0 || t > 1)) return null;
			
			return new Point(A.x + AB.x * t, A.y + AB.y * t);
		}

		/**
		 * Returns the normal of line AB in the area spanned by triangle ABC.
		 */
		public static function lineNormal(A : Point, B : Point, C : Point, inNormalize : Boolean = true) : Point {
			var D : Point = nearestPointOnLine(A, B, C);
			
			var DC : Point = C.subtract(D);
			
			if (inNormalize) DC.normalize(1);
			
			return DC;
		}

		public static function reflectLine(A : Point, B : Point, P : Point, Q : Point ) : Point {
			// VectReflect = VectOriginal - 2 * WallNormal * (WallNormal DOT VectOriginal)
			var wallNormal : Point = lineNormal(P, Q, A);
			var AB : Point = B.subtract(A);
			var dot : Number = dotProduct(wallNormal, AB);
			multiplyBy(wallNormal, 2 * dot);
			return AB.subtract(wallNormal);
		}

		public static function dotProduct(A : Point, B : Point) : Number {
			return A.x * B.x + A.y * B.y;
		}

		public static function multiplyBy(A : Point, inValue : Number) : void {
			A.x *= inValue;
			A.y *= inValue;
		}

		/**
		 * Check whether the point D is in triangle ABC by matching point D to all sides of the triangle.
		 */
		public static function pointIsInTriangle(D : Point, A : Point, B : Point, C : Point) : Array {	
			if (!matchSide(D, A, B, C)) return [A,B];
			if (!matchSide(D, B, C, A)) return [B,C];
			if (!matchSide(D, C, A, B)) return [C,A];
			
			return null;
		}

		/**
		 * Check whether the first point D is on the same side of line AB as C.
		 */
		public static function matchSide(D : Point, A : Point, B : Point, C : Point) : Boolean {
			var AD : Point = D.subtract(A);
			var AC : Point = C.subtract(A);
			
			var DxAB : Point = nearestPointOnLine(A, B, D);
			var perp : Point = D.subtract(DxAB);
			
			var dotD : Number = dotProduct(AD, perp);
			var dotC : Number = dotProduct(AC, perp);
			
			return dotD / dotC > 0;
		}

		public static function convertVector3DToPoint(inVector : Vector3D) : Point {
			return new Point(inVector.x, inVector.y);
		}

		public static function convertPointToVector3D(inPoint : Point) : Vector3D {
			return new Vector3D(inPoint.x, inPoint.y);
		}
	}
}
