package prfm.view.motion
{
	import __AS3__.vec.Vector;
	
	
	public class TrailLine
	{
		private var lines:Vector.<Number>;
		private var vels:Vector.<Number>;
		private var segs:Array;
		private var col:uint;
		public function TrailLine(_col:uint = 0xFFFFFF)
		{
			col = _col;
			lines = new Vector.<Number>();
			vels = new Vector.<Number>();
			segs = [];
		}
		
		public function get _lines():Vector.<Number>{
			return lines;
		}
		
		public function add(_x:Number, _y:Number, _z:Number):void{
			var _px:Number = 0;
			var _py:Number = 0;
			var _pz:Number = 0;
			if ( lines.length > 3 ) {	
				_px = lines[0];
				_py = lines[1];
				_pz = lines[2];
			}else{
				vels.unshift(0, 0, 0);
				lines.unshift(_x, _y, _z);
			}
			vels.unshift(_x - _px, _y - _py, _z - _pz);
			lines.unshift(_x, _y, _z);
			
		}
		
		public function update():void{
			var i:int = 0;
			var l:int = lines.length;
			var _vx:Number = vels[0];
			var _vy:Number = vels[1];
			var _vz:Number = vels[2];
			
			if ( lines.length > 60 ) {
				vels.pop();
				vels.pop();
				vels.pop();
				lines.pop();
				lines.pop();
				lines.pop();
			}
			
			l = lines.length;
			for ( i=0; i<l; i+=3 ) {
				if ( i > 0 ) {
					_vx *= 0.7;
					_vy *= 0.7;
					_vz *= 0.7;
					vels[i] *= 0.6;
					vels[i+1] *= 0.6;
					vels[i+2] *= 0.6;
					vels[i] += _vx;
					vels[i+1] += _vy;
					vels[i+2] += _vz;
					vels[i] += vels[i-3+0]*0.3;
					vels[i+1] += vels[i-3+1]*0.3;
					vels[i+2] += vels[i-3+2]*0.3;
					lines[i] -= vels[i];
					lines[i+1] -= vels[i+1];
					lines[i+2] -= vels[i+2];
				}
			}
		}

	}
}