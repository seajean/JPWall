package  {
	import com.seajean.base.RoundImage;
	import flash.events.MouseEvent;

	public class PhotoThumb extends RoundImage{
		public var square:Number=50;
		private var _data:PhotoVo;
		private var _type:int;
		public function PhotoThumb() {
			this.addEventListener(MouseEvent.CLICK,onThumbClick);
		}
		override public function set round(v:Number):void{
			super.round=v;
		}
		public function set type(v:int):void{
			switch(v){
				case 1:
					iWidth=square;
					iHeight=square;
					break;
				case 2:
					iWidth=square*2+5;
					iHeight=square*2+5;
					break;
				case 3:
					iWidth=square*2+5;
					iHeight=square;
				break;
				case 4:
					iWidth=square;
					iHeight=square*2+5;
				break;
			}
			_type=v;
			if(this.bitmap) redrawFoto();
		}
		public function get type():int{
			return this._type;
		}
		private function onThumbClick(e:MouseEvent):void{
			this.dispatchEvent(new PhotoEvent(PhotoEvent.ACTION_THUMB_CLICK,data,true));
		}
		public function set data(vo:PhotoVo):void{
			vo.target=this;
			this._data=vo;
			this.loadImage(vo.thumb);
		}
		public function get data():PhotoVo{
			return this._data;
		}
		/*
		protected  override function onComplete(e:Event):void{
			super.onComplete(e);
			bitmap.bitmapData.applyFilter(bitmap.bitmapData,bitmap.bitmapData.rect,new Point(0,0),new BlurFilter(50,50));
		}
		*/
	}
}
