package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Death extends MovieClip {
		var player:MovieClip;
		var main:MovieClip;
		
		public function Death() {
			addEventListener(Event.ENTER_FRAME, checkForDeath);
			
			player = MovieClip(root).player;
			main = MovieClip(root);
		}
		function isColliding(mask:MovieClip, target:MovieClip):Boolean {
			// Get bounds of the target
			var bounds:Rectangle = target.getBounds(stage);
		
			// Test points across the bounds of the target
			for (var x:Number = bounds.left; x <= bounds.right; x += 5) {
				for (var y:Number = bounds.top; y <= bounds.bottom; y += 5) {
					if (mask.hitTestPoint(x, y, true)) {
						return true; // Collision detected
					}
				}
			}
			return false; // No collision
		}
		function checkForDeath(e:Event) {
			if(isColliding(this, player)) {
				main.die();
			}
		}
	}
	
}
