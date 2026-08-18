import Reflect;
import Type;
import funkin.FunkinAssets;
import funkin.Mods;
import funkin.backend.Logger;
import funkin.scripting.PluginsManager;

function onLoad() {
	if (StringTools.startsWith(script.name, 'multipleScriptLoader_')) {
		PluginsManager.loadedScripts.members.remove(script);
		script.destroy();
	}
}

var activeScriptedState:Bool = false;

function onStateCreate() {
	var missingScriptLoader:Bool = true;
	for (plugin in PluginsManager.loadedScripts.members) {
		if (StringTools.startsWith(plugin.name, 'scriptLoader')) {
			missingScriptLoader = false;
			break;
		}
	}

	if (missingScriptLoader) {
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
