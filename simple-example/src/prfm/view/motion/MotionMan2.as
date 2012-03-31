package prfm.view.motion
{
	
	import com.perfume.utils.bvh.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.*;
	
	public class MotionMan2 extends EventDispatcher{
		private var frame_count:Number = 0;
		public var offset_x:Number;
		public var offset_y:Number;
		public var offset_z:Number;
		
		private var bvh:Bvh;
		
		private var cueNum:int = 0;
		private var points:Array = [];
		private var lines:Array = [];
		
		private var p_time:Number = 0;
		
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		
		public function MotionMan2(_path:String = null){
			super();
			
			offset_x = 0;
			offset_y = 0;
			offset_z = 0;
			if ( _path ) reload(_path);
		}
		
		
		public function destroy():void{
			bvh = null;
			points = null;
			lines = null;
		}
		
		
		public function reload(_path:String, _fn:Function = null):void{
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, function(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, arguments.callee);
				bvh = new Bvh(String(ld.data));
				bvh.isLoop = true;
				frame_count = 0;
				rePoints();
				if ( _fn != null ) _fn();
			});
			ld.load(new URLRequest(_path));
		}

		public function addPoint():void{
			cueNum++;
		}
		
		public function removePoint():void{
			points.pop();
		}
	
		public function get _points():Array{
			return points;
		}
		
		public function get _lines():Array{
			return lines;
		}
		
		public function update(_time:Number, _cam_z:Number):void{
			if ( !bvh ) return;
			makePoint();
			var col:uint;
			var sp:Sprite;
			bvh.gotoFrame( (_time)/(bvh.frameTime*1000) ) ;
			var a:Array = [];
			
			for each (var bone : BvhBone in bvh.bones){
				var matrix:Matrix3D = new Matrix3D();
				var _p0:BvhBone = bone;
				while ( bone ) {
					matrix.appendRotation(bone.Zrotation, Vector3D.Z_AXIS);
					matrix.appendRotation(-bone.Xrotation, Vector3D.X_AXIS);
					matrix.appendRotation(-bone.Yrotation, Vector3D.Y_AXIS);
					matrix.appendTranslation(bone.Xposition+bone.offsetX, bone.Yposition+bone.offsetY, -(bone.Zposition+bone.offsetZ));
					bone = bone.parent;
				}
				a.push(_p0.name, matrix.position.x, (matrix.position.y - 70), matrix.position.z);
				
				if ( _p0.isEnd ){
					bone = _p0;
					matrix.identity();
					matrix.appendTranslation(bone.endOffsetX, bone.endOffsetY, -(bone.endOffsetZ));
					while ( bone ) {
						matrix.appendRotation(bone.Zrotation, Vector3D.Z_AXIS);
						matrix.appendRotation(-bone.Xrotation, Vector3D.X_AXIS);
						matrix.appendRotation(-bone.Yrotation, Vector3D.Y_AXIS);
						matrix.appendTranslation(bone.Xposition+bone.offsetX, bone.Yposition+bone.offsetY, -(bone.Zposition+bone.offsetZ));
						bone = bone.parent;
					}
					a.push(_p0.name+"_end", matrix.position.x, (matrix.position.y - 70), matrix.position.z);
				}
			}
			
			x = a[1];
			y = a[2];
			z = a[3];
			
			var i:int = 0;
			var l:int = points.length;
			for ( i = 0; i<l; i++ ) {
				var point:InterpPoint = points[i];
				var _index0:int = a.indexOf(point.b0);
				var _index1:int = a.indexOf(point.b1);
				var p:Number = point.ratio;
				point.x = a[_index0+1]*(1-p) + a[_index1+1]*p + offset_x;
				point.y = -(a[_index0+2]*(1-p) + a[_index1+2]*p) + offset_y;
				point.z = -(a[_index0+3]*(1-p) + a[_index1+3]*p) + _cam_z + offset_z;
				var line:TrailLine = lines[i];
				line.add(point.x, point.y, point.z);
				line.update();
			}
			return;
		}
		
		
		
		private function rePoints():void{
			for ( var i:int = points.length - 1; i>=0; i-- ) {
				points[i] = makePointCalc();
			}
		}
		
		private function makePoint():void{
			if ( cueNum == 0 ) return;
			while ( cueNum > 0 ) {
				points.push(makePointCalc());
				lines.push( new TrailLine() );
				cueNum--;
			}
		}
		
		private function makePointCalc():InterpPoint{
			var bone:BvhBone = bvh.bones[int(Math.random()*bvh.bones.length)];
			if ( bone.isEnd ) {
				return new InterpPoint(bone.name, bone.name+"_end", Math.random());
			} else {
				var _index:int = Math.random()*bone.children.length;
				return new InterpPoint(bone.name, bone.children[_index].name, Math.random());
			}
		}
	}
}