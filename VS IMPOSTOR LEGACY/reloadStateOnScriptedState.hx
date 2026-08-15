import flixel.addons.transition.FlxTransitionableState;
import funkin.FunkinAssets;
import funkin.Mods;
import funkin.data.GameFlags;
import funkin.data.Lang;
import funkin.scripting.PluginsManager;

/**
	## `ScriptedState`でも正常にステートリロードができるようになるプラグイン
	F5, F6, F7を使用したデバッグ用のステートリロードが`ScriptedState`でも正常に動作するようになります。

	## Plugin that allows state reloading to work properly with `ScriptedState`
	The debug state reload functions using F5, F6, and F7 will now work properly with `ScriptedState`.
**/
function description() {}

function onUpdate(elapsed:Float) {
	if (!ClientPrefs.inDevMode)
		return;

	if (FlxG.keys.justPressed.F5) {
		FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
		resetState();
	}

	if (FlxG.keys.justPressed.F6) {
		FlxG.signals.preStateCreate.addOnce((state) -> {
			FunkinAssets.cache.clearStoredMemory();
			FunkinAssets.cache.clearUnusedMemory();
		});
		PluginsManager.populate();
		GameFlags.getAwards(true);
		Lang.reloadLangFile();
		FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
		resetState();

		Mods.currentModConfig = Mods.loadTopModConfig();
	}

	if (FlxG.keys.justPressed.F7) {
		Lang.reloadLangFile();
		FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
		resetState();
	}
}

function resetState() {
	var realStateName:String = Type.getClassName(Type.getClass(FlxG.state)).split('.').pop();
	if (realStateName == 'ScriptedState')
		FlxG.switchState(new ScriptedState(FlxG.state.scriptName));
	else
		FlxG.resetState();
}
