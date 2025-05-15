# Thirdperson Toggle Plugin for SourceMod (TF2)
This SourceMod plugin enables players on Team Fortress 2 servers to switch between first-person and third-person perspectives using simple chat or console commands.

# Features
*User Commands*: Players can toggle views with commands like !tp, !thirdperson, !fp, and !firstperson.

*Persistent Preferences*: Utilizes clientprefs to remember each player's preferred view mode across sessions.

*Automatic View Application*: Applies the chosen view mode upon player spawn and when they join the server.

*Viewmodel Management*: Disables the viewmodel in third-person mode for a cleaner visual experience.

*Chat Integration*: Supports both chat and console command inputs for toggling views.

*Localization Support*: Includes multilingual support through thirdperson.phrases.

# Installation
Place the compiled .smx file into your server's addons/sourcemod/plugins/ directory.

Ensure the clientprefs extension is enabled on your server.

Add the thirdperson.phrases.txt file to your addons/sourcemod/translations/ folder.

# Credits
Author: Kometa

Version: 1.0.0
