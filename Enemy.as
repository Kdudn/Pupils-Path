package {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.setTimeout;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class Enemy extends MovieClip {
		var goingLeft:Boolean = false;
		var lvlframe:int;
		var dx:Number = 1.5;
		var dy:Number = 0;
		var lastValue:int = 0;
		var level:MovieClip;
		var player:MovieClip;
		var main:MovieClip;
		
		public function Enemy(dir:String = "right") {
			// Delay adding event listener to ensure enemy is fully initialized
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if(dir == "left") {
				dx = -dx;
			}
		}
		
		private function onAddedToStage(e:Event):void {
			// Now that the enemy has been added to the stage, we can safely access stage elements
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Now you can safely reference the stage or other objects
			level = MovieClip(root).level;
			player = MovieClip(root).player;
			main = MovieClip(root);
			
			lvlframe = level.currentFrame;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		function isColliding(mask:MovieClip, target:MovieClip):Boolean {
			var bounds:Rectangle = target.getBounds(stage);
			for (var x:Number = bounds.left; x <= bounds.right; x += 5) {
				for (var y:Number = bounds.top; y <= bounds.bottom; y += 5) {
					if (mask.hitTestPoint(x, y, true)) {
					return true;
					}
				}
			}
			return false;
		}
		function Move(steps:Number):void {
			dx = Math.round(dx * 100) / 100;
			for(var i:int = steps; i >= 0; i--) {
				lastValue = this.x;
				if(!isNaN(dx / steps)) {
					this.x += dx / steps;
				}
				if(isColliding(level, this)) {
					this.x = lastValue;
					dx = -dx;
				}
				lastValue = this.y;
				if(!isNaN(dy / steps)) {
					this.y += dy / steps;
				}
				if(isColliding(level, this)) {
					this.y = lastValue;
					this.rotation = 0;
					dy = 0;
				}
			}
		}
		function die():void {
			if (this.parent) {
				this.parent.removeChild(this); // Remove enemy from the stage
				removeEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		function update(e:Event):void {
			if(!main.gamePaused) {
				if (level.currentFrame != lvlframe) {
					die();
				}
			
				if (this.currentFrame == 1) {
					dy++; // Gravity
					Move(Math.abs(dx) + Math.abs(dy));
					
					// Check for edges
					var groundLeft:Boolean = level.hitTestPoint(this.x - this.width / 2, this.y + this.height / 2, true);
					var groundRight:Boolean = level.hitTestPoint(this.x + this.width / 2, this.y + this.height / 2, true);
					
					// If there's no ground ahead, turn around
					if (!groundLeft && dx < 0) {
						dx = -dx; // Reverse direction
					} else if (!groundRight && dx > 0) {
						dx = -dx; // Reverse direction
					}
					
					if (isColliding(this, player)) {
						if (main.dy > 3) {
							main.dy = -10;
							this.gotoAndStop(2);
							setTimeout(function():void {
								die();
							}, 1000);
						} else {
							main.die();
							die();
						}
					}
				}
			}
	
		}
	}
}