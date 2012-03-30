package com.perfume.utils.bvh{
	import __AS3__.vec.Vector;
	use namespace prfmbvh;
	public class Bvh{
		public var isLoop:Boolean;
		
		private var _rootBone:BvhBone;
		prfmbvh function set rootBone(__bone:BvhBone):void{ _rootBone = __bone; }
		
		private var _frames:Vector.<Vector.<Number>>;
		prfmbvh function set frames(__frames:Vector.<Vector.<Number>>):void{ _frames = __frames; }
		
		private var _numFrames:uint;
		public function get numFrames():Number { return _numFrames; }
		prfmbvh function set numFramesInternal(_num:Number):void { _numFrames = _num; }
		
		private var _frameTime:Number;
		public function get frameTime():Number { return _frameTime; }
		prfmbvh function set frameTimeInternal(_num:Number):void { _frameTime = _num; }
		
		private var _bones:Vector.<BvhBone>;
		public function get bones():Vector.<BvhBone> { return _bones; }
		
		public function Bvh(_str:String) {
			_bones = new Vector.<BvhBone>();
			new BvhParser(this, _str);
		}
		
		public function destroy():void {
			_bones = null;
			_frames = null;
			_rootBone = null;
		}
		
		public function gotoFrame(_frame:uint):void {
			if (!isLoop) {
				if (_frame >= _numFrames) _frame = _numFrames-1;
			} else {
				while (_frame >= _numFrames) _frame -= _numFrames;	
			}
			var frame:Vector.<Number> = _frames[_frame];
			var count:uint = 0;
			for each (var _val:Number in frame) {
				setBoneProp(count, _val);
				count++;
			}
		}
		
		private function setBoneProp(_index:Number, _val:Number):void {
			var count:int = 0;
			for each (var _bone:BvhBone in _bones) {
				count += _bone.numChannels;
				if (count > _index) {
					var _idx:int = _index - (count - _bone.numChannels);
					_bone[_bone.channels[_idx]] = _val;
					break;
				}
			}
		}
		
	}
}