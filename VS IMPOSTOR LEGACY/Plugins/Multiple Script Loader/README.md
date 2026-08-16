### Multiple Script Loader
## Features
It allows multiple scripts to be executed in the current State.

For example, the following scripts will all be executed simultaneously in `MainMenuState`:

* `assets/scripts/states/MainMenuState.hx`
* `content/scripts/states/MainMenuState.hx`
* `content/scripts/states/MainMenuState/script.hx`
* `content/EnabledModName/scripts/states/script.hx`

Substates are not supported.
