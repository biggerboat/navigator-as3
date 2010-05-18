package com.epologee.frameworks.papervision3d {
	import Singularity.Geom.P3D.PV3DSpline;		import com.epologee.logging.Logee;		import org.papervision3d.core.geom.renderables.Vertex3D;	
	/**
	 * @author eric-paul.lecluse
	 */
	public class SplineUtils {

		public static function createSplineFromCollada(inCollada : XML, inSplineID : String, inOffset3D:Vertex3D = null, inFlipYZ:Boolean = false) : PV3DSpline {
			try {
				// define data source
				default xml namespace = inCollada.namespace();
				var node : XML = XMLList(inCollada..geometry.(@id == inSplineID + "-spline"))[0];

				// create spline instance
				var spline : PV3DSpline = new PV3DSpline();

				// set closed flag
				spline.closed = (node.spline.@closed == "1");

				// retrieve the list of serial x y z coordinates. 
				var coords : Array = node.spline.source.float_array.toString().split(" ");

				if (inFlipYZ) {
					var j : uint;
					var lenj : uint = coords.length;
					for (j = 0; j < lenj; j+=3) {
						var hold:Number = coords[j+1];
						coords[j+1] = coords[j+2];
						coords[j+2] = hold;
					}
				}
				
				if (!spline.closed) {
					// if the spline is not closed, the array of coordinates start 
					// with the first knot and ends with the last knot, it's
					// respective in and out tangents are missing.
					// By adding a dummy value at the start and the end, the spline 
					// is drawn correctly again.
					coords = [0,0,0].concat(coords.concat([0,0,0]));
				}
			
				if (inOffset3D) {
					var k : uint;
					var lenk : uint = coords.length;
					for (k = 0; k < lenk; k+= 3) {
						coords[k] = parseFloat(coords[k]) + inOffset3D.x;
						coords[k+1] = parseFloat(coords[k+1]) + inOffset3D.y;
						coords[k+2] = parseFloat(coords[k+2]) + inOffset3D.z;
					}
				}
				
				// use this iterator to add the tangents to the control points.
				var i : int = 0;
				while (coords.length) {
					var inVec : Array = coords.splice(0, 3);
					var knot : Array = coords.splice(0, 3);
					var outVec : Array = coords.splice(0, 3);

					var myX : Number = Number(knot[0]);
					var myY : Number = Number(knot[1]);
					var myZ : Number = Number(knot[2]);
	            
					// add a knot to the list:
					spline.addControlPoint(myX, myY, myZ);
	            
					myX = Number(inVec[0]);
					myY = Number(inVec[1]);
					myZ = Number(inVec[2]);
	            	
					// add the in tangent
					spline.inTangent(i, myX, myY, myZ);
	            
					myX = Number(outVec[0]);
					myY = Number(outVec[1]);
					myZ = Number(outVec[2]);
	            
					// add the out tangent
					spline.outTangent(i, myX, myY, myZ);	
					
					i++;			
				}
				return spline;
			} catch (e : Error) {
				Logee.error("createSplineFromCollada: " + e.message, "com.epologee.papervision3d.utils.SplineUtils");
			}
			return null;
		}

		/**
		 * The code for this class was taken from a flex demo by Jim Armstrong and modified
		 * to fit regular AS3. 
		 */
		public static function createSplineLikeJim() : PV3DSpline {
			// define data source
			var xmlSpline : XML = MAX_SPLINE;
			
			// create spline instance
			var spline : PV3DSpline = new PV3DSpline();
			// set closed flag
			spline.closed = xmlSpline.@closed == "true";
          
			
			var numKnots : Number = xmlSpline.@knots;
			var knots : XMLList = xmlSpline.knot;
			var inVec : XMLList = xmlSpline.knot.invec;
			var outVec : XMLList = xmlSpline.knot.outvec;
          
			for( var i : uint = 0;i < numKnots; ++i ) {
				var k : XML = knots[i];
				var myX : Number = Number(k.@x);
				var myY : Number = Number(k.@y);
				var myZ : Number = Number(k.@z);
            
				// add a knot to the list:
				spline.addControlPoint(myX, myY, myZ);
            
				myX = Number(inVec[i].@x);
				myY = Number(inVec[i].@y);
				myZ = Number(inVec[i].@z);
            	
				// add the in tangent
				spline.inTangent(i, myX, myY, myZ);
            
				myX = Number(outVec[i].@x);
				myY = Number(outVec[i].@y);
				myZ = Number(outVec[i].@z);
            
				// add the out tangent
				spline.outTangent(i, myX, myY, myZ);
			}
			
			return spline;
		}

		private static var MAX_SPLINE : XML = <spline name='Line01' knots='7' closed='true'>
			<knot x='-123.018' y='53.5028' z='0.0'>
				<invec x='-154.627' y='16.1465' z='0.0' />
				<outvec x='-91.4084' y='90.8591' z='0.0' />
			</knot>
			<knot x='-7.033' y='88.4169' z='-91.3649'>
				<invec x='-77.1479' y='83.8192' z='-91.3649' />
				<outvec x='63.0819' y='93.0146' z='-91.3649' />
			</knot>
			<knot x='110.694' y='89.7132' z='0.0'>
				<invec x='80.1177' y='107.975' z='0.0' />
				<outvec x='141.27' y='71.4514' z='0.0' />
			</knot>
			<knot x='161.098' y='-13.6597' z='0.0'>
				<invec x='166.459' y='30.5072' z='0.0' />
				<outvec x='155.736' y='-57.8267' z='0.0' />
			</knot>
			<knot x='61.2687' y='-93.0454' z='-91.3649'>
				<invec x='100.924' y='-86.7235' z='-91.3649' />
				<outvec x='21.6135' y='-99.3672' z='-91.3649' />
			</knot>	
			<knot x='-49.5287' y='-89.2301' z='-91.3649'>
				<invec x='-2.977' y='-116.816' z='-91.3649' />
				<outvec x='-96.0804' y='-61.6439' z='-91.3649' />
			</knot>
			<knot x='-154.02' y='-41.2029' z='0.0'>
				<invec x='-145.71' y='-73.8184' z='0.0' />
				<outvec x='-162.33' y='-8.58747' z='0.0' />
			</knot>
		</spline>;
	}
}