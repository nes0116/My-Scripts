### Reload State on ScriptedState
## Features
Allows scripts to be executed through plugin commands.

For example:
`PluginsManager.callPluginFunc('scriptLoader', 'loadScript', ['PATH/TO/SCRIPT', 'SCRIPTTAG']);`

Don't forget to import `funkin.scripting.PluginsManager`.