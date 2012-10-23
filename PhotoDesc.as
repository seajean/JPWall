package  {
	
	import flash.display.MovieClip;
	//import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	public class PhotoDesc extends MovieClip {
		
		
		public function PhotoDesc() {
			descText.autoSize=TextFieldAutoSize.LEFT;
		}
		
		public function set data(v:PhotoVo):void{
			descText.text=v.desc;
		}
	}
	
}
