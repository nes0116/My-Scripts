### Multiple Script Loader
## Recommended Engine Version
1.1.2
## Update History
### 1.0.1
- Plugins now work even when placed in the Mods Pack's directory.
  - This prevents the following error message from appearing.
    **[MUTIPLESCRIPTLOADER] This plugin requires another plugin, scriptLoader.hx in order to function!**
### 1.0.2
- Fixed an issue where plugins were being loaded multiple times.
  - Do not rename plugin scripts, as doing so may cause them to be loaded multiple times.
### 1.0.3
- Changed the way duplicate scripts are removed.

  This method seems smarter lol.

## Features
It allows multiple scripts to be executed in the current State.

For example, the following scripts will all be executed simultaneously in `MainMenuState`:

* `assets/scripts/states/MainMenuState.hx`
* `content/scripts/states/MainMenuState.hx`
* `content/scripts/states/MainMenuState/script.hx`
* `content/EnabledModName/scripts/states/script.hx`

Substates are not supported.
