import flixel.util.FlxDestroyUtil;
import funkin.FunkinAssets;
import funkin.backend.Logger;

public function loadScript(path:String, name:String) {
	final scriptFile = path;
	if (FlxG.state.scriptGroup.exists(scriptFile))
		return true;

	if (FunkinAssets.exists(scriptFile)) {
		var newScript = FunkinScript.fromFile(scriptFile, name);
		if (newScript.__garbage) {
			newScript = FlxDestroyUtil.destroy(newScript);
			return false;
		}

		Logger.log('Script ($scriptFile) initialized', 3);

		FlxG.state.scriptGroup.addScript(newScript, true);

        FlxG.state.scriptGroup.parent = FlxG.state;

		if (newScript.exists('onLoad'))
			newScript.call('onLoad', []);
	}
}
