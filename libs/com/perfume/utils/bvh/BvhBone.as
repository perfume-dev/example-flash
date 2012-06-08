package com.perfume.utils.bvh{
	public class BvhBone{
		public var name:String;
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		public var offsetZ:Number = 0;
		
		public var endOffsetX:Number = 0;
		public var endOffsetY:Number = 0;
		public var endOffsetZ:Number = 0;
		
		public var Xposition:Number = 0;
		public var Yposition:Number = 0;
		public var Zposition:Number = 0;
		public var Xrotation:Number = 0;
		public var Yrotation:Number = 0;
		public var Zrotation:Number = 0;
		
		public var translatedX:Number = 0;
		public var translatedY:Number = 0;
		public var translatedZ:Number = 0;
		public var endTranslatedX:Number = 0;
		public var endTranslatedY:Number = 0;
		public var endTranslatedZ:Number = 0;
		
		public var numChannels:int;
		public var channels:Vector.<String>;
		
		public var parent:BvhBone;
		public var children:Vector.<BvhBone>;
		
		public var isEnd:Boolean = false;
		
		public function BvhBone(_parent:BvhBone = null) {
			parent = _parent;
			channels = new Vector.<String>();
			children = new Vector.<BvhBone>();
		}
		
		public function get isRoot():Boolean {
			return (parent == null);
		}
		
		public function destroy():void {
			parent = null;
			channels = null;
			children = null;
		}
	}
}