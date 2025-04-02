package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class MovingPlatform extends MovieClip {
		var goingUp:Boolean = true;
		var waiting:Boolean = false;
		var topPoint:Number;
		var bottomPoint:Number;
		var lvlframe:int;
				
		public function MovingPlatform(pointTop:Number, pointBottom:Number, frame:int) {
			addEventListener(Event.ENTER_FRAME, movePlatform);
			
			topPoint = pointTop;
			bottomPoint = pointBottom;
			lvlframe = frame;
		}
		function movePlatform(e:Event):void {
			
			if (!waiting) {
				// Move the platform
				if (goingUp) {
					this.y -= 2.5;
				} else {
					this.y += 2.5;
				}
				
				// Check if the platform has reached the boundaries using a tolerance
				if (this.y >= bottomPoint || this.y <= topPoint) {
					waiting = true; // Start waiting
					setTimeout(function():void {
						goingUp = !goingUp; // Toggle direction
						waiting = false;   // Resume movement
					}, 2000);
				}
			}
		}
	}
}
