package  {
	import flash.events.Event;
	public class PhotoEvent extends Event {
		public static const ACTION_THUMB_CLICK:String="action_thumb_click";
		public static const LOAD_PHOTO_XML_SECCESS:String="load_photo_xml_seccess";
		public static const ACTION_THUMB_OVER:String="action_thumb_over";
		public static const ACTION_THUMB_OUT:String="action_thumb_out";
		public static const HIDE_LOADING:String="hide_loding";
		public static const SHOW_LOADING:String="show_loading";
		public var data:*;
		public function PhotoEvent(type:String,dt:*,bubble:Boolean=false,cancel:Boolean=false) {
			data=dt;
			super(type,bubble,cancel);
		}
	}
}
