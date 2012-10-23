package  {
	
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	
	
	public class PhotoTip extends MovieClip {
		
		
		public function PhotoTip() {
			var ff:DropShadowFilter=new DropShadowFilter(0,45,0,0.8,15,15,2,4);
			this.filters=[ff];
			info_text.autoSize=TextFieldAutoSize.LEFT;
		}
		public function set data(v:PhotoVo):void{
			info_text.text=v.desc;
			info_text.y=int((120-info_text.height)/2);
		}
	}
	
}
