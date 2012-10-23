package  {
	import com.seajean.base.RoundImage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.filters.BlurFilter;

	public class BigImage extends RoundImage{

		public function BigImage() {
			// constructor code
		}
		protected  override function onComplete(e:Event):void{
			super.onComplete(e);
			smooth();
		}
		
		override public function redrawFoto():void{
			super.redrawFoto();
			smooth();
		}
		private function smooth():void{
			if(!bitmap) return;
			if(bitmap.width>1000){
				bitmap.bitmapData.applyFilter(bitmap.bitmapData,bitmap.bitmapData.rect,new Point(0,0),new BlurFilter(3,3));
			}else{
				bitmap.bitmapData.applyFilter(bitmap.bitmapData,bitmap.bitmapData.rect,new Point(0,0),new BlurFilter(2,2));
			}
		}

	}
	
}
