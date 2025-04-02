package {
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip {
		var dx:Number = 0;
		var dy:Number = 0;
		var temp:Number = 0;
		var falling:Number = 0;
		var lastValue:Number = 0;
		var gravity:int = 1;
		var checkPoint:Object = {
			frame: 101,
			x: 75,
			y: 165
		}
		var jumping:Boolean= false;
		var checkForEnemy:Boolean = false;
		var gamePaused:Boolean = false;
		public var platformGoingUp:Boolean = false;
		var keys:Array = [];
		
		public function Main() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
								   keys[e.keyCode] = true;
								   });
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {   
								   switch(e.keyCode) {
									   case Keyboard.ESCAPE:
									   		gamePaused = !gamePaused;
								   }
								   keys[e.keyCode] = false;
								   });
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
									stage.focus = stage;
								});
			addEventListener(Event.ENTER_FRAME, update);
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
		function fixCollision(dir:int):void {
			temp = 1;
			while(isColliding(level, player)) {
				if(dir == 0) {
					player.y += temp;
				} else {
					player.x += temp;
				}
				if(temp > 0) {
					temp ++;
				} else {
					temp --;
				}
				temp = -temp;
			}
		}
		function Move(steps:Number):void {
			falling ++;
			dx = Math.round(dx * 100) / 100;
			if(dx == 0.02 || dx == -0.02) {
				dx = 0;
			}
			for(var i:int = steps; i >= 0; i--) {
				lastValue = player.x;
				if(!isNaN(dx / steps)) {
					player.x += dx / steps;
				}
				if(isColliding(level, player)) {
					player.rotation = 0;
					player.x = lastValue;
					dx = 0;
				}
				lastValue = player.y;
				if(!isNaN(dy / steps)) {
					player.y += dy / steps;
				}
				if(isColliding(level, player)) {
					if(level.oneWay && player.hitTestObject(level.oneWay)) {
						if(dy > 0) {
							player.rotation = 0;
							player.y = lastValue;
							if(dy > 0) {
								falling = 0;
							}
							dy = 0;
						}
					} else {
						player.y = lastValue;
						player.rotation = 0;
						if(dy > 0) {
							falling = 0;
						}
						dy = 0;
					}
				}
			}
		}
		function die():void {
			level.gotoAndStop(checkPoint.frame);
			player.y = checkPoint.y;
			player.x = checkPoint.x;
			checkForEnemy = true;
		}
		function update(e:Event):void {
			Pause.parent.setChildIndex(Pause, Pause.parent.numChildren - 1);
			if(gamePaused) {
				Pause.gotoAndStop(1);
			} else {
				Pause.gotoAndStop(2);
			}
			if(stage.focus != stage &&	level.currentFrame != 301) {
				gamePaused = true;
			}
			if(!gamePaused) {
				dy += gravity;
				
				if(keys[Keyboard.LEFT]) {
					if(dx > -12) {
						dx -= 2;
					}
				}
				if(keys[Keyboard.RIGHT]) {
					if(dx < 12) {
						dx += 2;
					}
				}
				if(keys[Keyboard.UP]) {
					if(falling < 3) {
						dy = -9;
					}
				}
				
				dx *= 0.8;
				
				Move(Math.abs(dx) + Math.abs(dy));
				if(level.movingPlatform) {
					if(player.hitTestObject(level.movingPlatform.top) && platformGoingUp) {
						player.y = ((level.movingPlatform.y + level.y) - player.height) + 4;
					}
				}
				if(level.trampoline) {
					if(player.hitTestObject(level.trampoline)) {
						dy = -35;   
					}
				}
				if(isColliding(checkPoints, player)) {
					checkPoint.frame = level.currentFrame;
					checkPoint.x = checkPoints.x + checkPoints.forxy.x;
					checkPoint.y = checkPoints.y + checkPoints.forxy.y;
				}
				if(player.x > 575) {
					level.nextFrame();
					player.x = -25;
					
					fixCollision(0);
				}
				if(player.x < -30) {
					level.prevFrame();
					player.x = 560;
					
					fixCollision(0);
				}
				if(player.y > 430) {
					level.gotoAndStop(level.currentFrame + 100);
					player.y = -10;
					
					fixCollision(90);
				}
				if(player.y < -30) {
					level.gotoAndStop(level.currentFrame - 100);
					player.y = 400;
					
					fixCollision(90);
				}
			}
		}
	}
}