function onStateCreate() {
	for (i in 0...2) {
		if (ClientPrefs.keyBinds.get('volume_mute')[i] == -1) {
			ClientPrefs.keyBinds.get('volume_mute')[i] = ClientPrefs.keyBinds.get('volume_mute')[0];
		}
	}

	ClientPrefs.flush();

	FlxG.sound.muteKeys = ClientPrefs.keyBinds.get('volume_mute');
	FlxG.sound.volumeUpKeys = ClientPrefs.keyBinds.get('volume_up');
	FlxG.sound.volumeDownKeys = ClientPrefs.keyBinds.get('volume_down');
}
