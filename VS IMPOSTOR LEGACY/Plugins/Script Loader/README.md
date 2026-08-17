### Reload State on ScriptedState
## Recommended Engine Version
1.1.2
## Update History
### 1.0.1
- Fixed an issue where plugins were being loaded multiple times.
  - Do not rename plugin scripts, as doing so may cause them to be loaded multiple times.
## Features
Allows scripts to be executed through plugin commands.

For example:
`PluginsManager.callPluginFunc('scriptLoader', 'loadScript', ['PATH/TO/SCRIPT', 'SCRIPTTAG']);`

Don't forget to import `funkin.scripting.PluginsManager`.