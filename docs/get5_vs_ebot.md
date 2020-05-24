[eBot](http://www.esport-tools.net/ebot/) is a very popular tool for running matches and has been around since 2012. This page aims to outline some differences between get5 and eBot.

## Overall system

eBot is written in php and nodejs has two parts:
- a server daemon listening to the log from the game server
- a web panel for creating/monitoring matches

Both are required and are generally installed together on a web server separate from game servers. 

get5 similarly has two parts, but one is optional:
- a game server plugin (required)
- a [web panel](https://github.com/splewis/get5/docs/get5_web_panel) that is optional


## Features

Both projects generally have the same features. A few key differences are:
- get5 offers locking steamids to specific teams. eBot does not in the open-source version.
- get5 offers a map veto system inside the game server and best-of-X series.
- get5 offers a [plugin api](https://github.com/splewis/get5/blob/master/scripting/include/get5.inc) on the game server for other sourcemod plugins to adjust behavior easily.


## Reliability

The get5 server plugin will generally be more reliable than eBot listening to a server's UDP log. In practice, if things are setup correctly eBot will rarely encounter issues, though. Not requiring a central server to manage all things is an advantage of get5, but then requires more installation work.

In terms of breakage, a CS:GO update *can* break both get5 and eBot. A server update could change the format of CS:GO's logging, which could break eBot. This is highly unlikely and not a serious concern. 

Since get5 relies on Sourcemod, CS:GO updates sometimes break sourcemod or a sourcemod function get5 uses - this roughly happens every ~4-6 months. Usually, a gamedata update from sourcemod developers (usually happens with a few hours to a day) fixes these. Note that many other services (FaceIt, CEVO rely on sourcemod+metamod, ESEA relies on metamod) rely on sourcemod working, so others have vested interests in sourcemod working quickly as well.




