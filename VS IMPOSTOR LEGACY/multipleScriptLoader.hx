import Type;
import funkin.FunkinAssets;
import funkin.Mods;
import funkin.backend.Logger;
import funkin.scripting.PluginsManager;

/**
	## ステートに複数のスクリプトを自動で実行できるようになるプラグイン

	このプラグインを動作させるには別プラグイン、`scriptLoader.hx`が必要です！

	現時点ではステートに複数のプラグインを実行する機能が実装されていないため、このプラグインを作りました。

	(`assets/scripts/states/MainMenuState.hx`と`content/scripts/states/MainMenuState.hx`が同時に実行されない、など)

	`content/scripts/plugins/`にこのスクリプトを入れることで、ステートに複数のプラグインを自動で実行できるようになります。

	例えば、`MainMenuState`で実行するスクリプトを増やしたい場合、`content/YourModName/scripts/MainMenuState/script.hx`のようにスクリプトを作成すると、

	そのスクリプトがステートに追加されるようになります。

	一応`ScriptedState`でも使用可能です。

	(`content/YourModName/scripts/YourStateName/script.hx`)

	## Plugin that allows multiple scripts to be automatically executed in a state

	This plugin requires another plugin, `scriptLoader.hx` in order to function!

	Currently, there is no built-in functionality to execute multiple scripts in a state, so I created this plugin.

	For example, `assets/scripts/states/MainMenuState.hx` and `content/scripts/states/MainMenuState.hx` cannot be executed at the same time.

	By placing this script in `content/scripts/plugins/`, you can automatically execute multiple scripts in a state.

	For example, if you want to add more scripts to `MainMenuState`, you can create a script at:

	`content/YourModName/scripts/MainMenuState/script.hx`

	The script will then be automatically added to the state.

	This plugin can also be used with `ScriptedState`.

	For example:

	`content/YourModName/scripts/YourStateName/script.hx`
**/
function description() {}

var activeScriptedState:Bool = false;

function onStateCreate() {
	if (!FunkinAssets.exists('content/scripts/plugins/scriptLoader.hx')) {
		Logger.log('[MUTIPLESCRIPTLOADER] This plugin requires another plugin, scriptLoader.hx in order to function!', 2, true);
		return;
	}

	var realStateName:String = Type.getClassName(Type.getClass(FlxG.state)).split('.').pop();
	var stateName:String = FlxG.state.scriptName;

	if (realStateName == 'ScriptedState') {
		var enableMods:Array<String> = Mods.enabled;

		for (mod in enableMods) {
			var path:String = 'content/$mod/scripts/states/$stateName';
			if (FunkinAssets.exists('$path.hx')) {
				PluginsManager.callPluginFunc('scriptLoader', 'loadScript', ['$path.hx', '$stateName']);
				activeScriptedState = true;
			}

			if (!FunkinAssets.exists('$path'))
				continue;

			var scriptList:Array<String> = FunkinAssets.readDirectory('content/$mod/scripts/states/$stateName/');
			for (script in scriptList) {
				if (FunkinAssets.exists('$path/$script')) {
					PluginsManager.callPluginFunc('scriptLoader', 'loadScript', ['$path/$script', '$stateName']);
					activeScriptedState = true;
				}
			}
		}
	} else {
		if (realStateName.length == 0)
			return;

		var path:String = 'assets/scripts/states/$realStateName';
		if (FunkinAssets.exists('$path')) {
			var scriptList:Array<String> = FunkinAssets.readDirectory('assets/scripts/states/$realStateName/');
			for (script in scriptList) {
				PluginsManager.callPluginFunc('scriptLoader', 'loadScript', ['$path/$script.hx', '$realStateName']);
				FlxG.state.scripted = true;
			}
		}

		var enableMods:Array<String> = Mods.enabled;
		for (mod in enableMods) {
			var path:String = 'content/$mod/scripts/states/$realStateName.hx';
			if (FunkinAssets.exists('$path')) {
				PluginsManager.callPluginFunc('scriptLoader', 'loadScript', ['$path', '$realStateName']);
				FlxG.state.scripted = true;
			}

			var path:String = 'content/$mod/scripts/states/$realStateName';
			if (FunkinAssets.exists('$path')) {
				var scriptList:Array<String> = FunkinAssets.readDirectory('content/$mod/scripts/states/$realStateName/');
				for (script in scriptList) {
					PluginsManager.callPluginFunc('scriptLoader', 'loadScript', ['$path/$script', '$realStateName']);
					FlxG.state.scripted = true;
				}
			}
		}
	}

	FlxG.state.scripted = activeScriptedState;
}
