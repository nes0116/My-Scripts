import lime.math.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.filters.GlowFilter;
import sys.FileSystem;
import sys.io.File;

var stateCreated:Bool = false;
var screenshotPreview:Sprite;
var flashSpr:Sprite;

function onUpdate(elapsed:Float) {
	if (!stateCreated)
		return;

	if (FlxG.keys.justPressed.F2) {
		function formatNum(num:Int):String {
			return num < 10 ? '0' + num : '' + num;
		}

		FlxG.sound.play(Paths.sound('shopbuy'));

		if (!FileSystem.exists("./screenshots/"))
			FileSystem.createDirectory("./screenshots/");

		if (FlxG.game.contains(screenshotPreview)) {
			FlxG.game.removeChild(screenshotPreview);
			FlxTween.cancelTweensOf(screenshotPreview);
		}
		if (FlxG.game.contains(flashSpr)) {
			FlxG.game.removeChild(flashSpr);
			FlxTween.cancelTweensOf(flashSpr);
		}

		new FlxTimer().start(0.01, (_) -> {
			var fileName:String = 'Screenshot-${formatNum(Date.now().getFullYear())}-${formatNum(Date.now().getMonth() + 1)}-${formatNum(Date.now().getDate())} ${formatNum(Date.now().getHours())}${formatNum(Date.now().getMinutes())}${formatNum(Date.now().getSeconds())}';
			File.saveBytes('screenshots/' + fileName + '.png',
				FlxG.stage.window.readPixels(new Rectangle(0, 0, FlxG.stage.window.width, FlxG.stage.window.height)).encode());

			screenshotPreview = new Sprite();
			var screenshotBitmap = new Bitmap(BitmapData.fromImage(FlxG.stage.window.readPixels()));
			screenshotPreview.addChild(screenshotBitmap);
			screenshotPreview.scaleX = screenshotPreview.scaleY = 0.25;
			screenshotPreview.x = 10;
			screenshotPreview.y = 10;
			screenshotPreview.name = 'screenshotPreview';
			screenshotPreview.filters = [new GlowFilter(0xFF000000, 1, 10, 10)];
			FlxG.addChildBelowMouse(screenshotPreview);
			FlxTween.tween(screenshotPreview, {alpha: 0}, 0.15, {
				ease: FlxEase.quadOut,
				startDelay: 3,
				onComplete: _ -> {
					screenshotPreview = null;
					if (FlxG.game.contains(screenshotPreview))
						FlxG.game.removeChild(screenshotPreview);
				}
			});
			screenshotPreview.y -= 10;
			FlxTween.tween(screenshotPreview, {y: screenshotPreview.y + 10}, 0.25, {ease: FlxEase.quadOut});

			var flashBitmap:Bitmap = new Bitmap(new BitmapData(Std.int(FlxG.stage.width), Std.int(FlxG.stage.height), false, 0xFFFFFFFF));
			flashSpr = new Sprite();
			flashSpr.addChild(flashBitmap);
			FlxG.game.addChild(flashSpr);
			flashSpr.alpha = !ClientPrefs.flashing ? 0.1 : 0.25;
			FlxTween.tween(flashSpr, {alpha: 0}, 0.5, {ease: FlxEase.quadOut, onComplete: _ -> FlxG.removeChild(flashSpr)});
		});
	}

	// addEventListener MouseEvent.MOUSE_DOWN doesn't work why
	if (FlxG.game.contains(screenshotPreview)) {
		if (FlxG.game.mouseX >= screenshotPreview.x
			&& FlxG.game.mouseY >= screenshotPreview.y
			&& FlxG.game.mouseX < screenshotPreview.x + screenshotPreview.width
			&& FlxG.game.mouseY < screenshotPreview.y + screenshotPreview.height) {
			if (FlxG.mouse.justPressed) {
				CoolUtil.openFolder('screenshots/', true);
			}
		}
	}
}

function onStateCreate() {
	if (FlxG.game.contains(screenshotPreview))
		FlxG.game.removeChild(screenshotPreview);
	if (FlxG.game.contains(flashSpr))
		FlxG.game.removeChild(flashSpr);
	stateCreated = true;
}
