package prfm.view.motion
{
	public class InterpPoint
	{
		public var b0:String;
		public var b1:String;
		public var ratio:Number;
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public function InterpPoint(_b0:String, _b1:String, _ratio:Number){
			b0 = _b0;
			b1 = _b1;
			ratio = _ratio;
		}	

	}
}