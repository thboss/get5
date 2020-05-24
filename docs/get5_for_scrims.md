While get5 is intended for matches (league matches, lan matches, cups, etc.), it can be used for everyday scrims/gathers/whatever as well. If that is your use case, you should do a few things differently.

Note: these features are new to the 0.5.0+ versions.

## Cvars

By default, get5 kicks all players from the server if no match is loaded. You should disable this for a practice server. To do so, edit ``cfg/sourcemod/get5.cfg`` and change:
- ``get5_kick_when_no_match_loaded 0``: this will enable players to join before starting

## Adding your team's steamids

You **must** edit [addons/sourcemod/configs/get5/scrim_template.cfg](https://github.com/splewis/get5/blob/master/configs/get5/scrim_template.cfg) and add your team's players to the "team1" section by their steamids (any format works). Any other player on the server will implicitly be on "team2".

You can list however many players you want. Add all your coaches, analysts, ringers, and such. If someone on your list ends up being on the other team in a scrim, you can use the !ringer command to temporarily swap them (similarly, you can use !ringer to put someone not in the list, on your team temporarily).

## Starting the match

Rather than creating a [match config](https://github.com/splewis/get5#match-schema), you should use the ``get5_scrim`` when the server is on the correct map. You can use this via rcon (``rcon get5_scrim``) or as a regular console command if you have the sourcemod changemap admin flag. You could also type ``!scrim`` in chat.

This command takes optional arguments: ``get5_scrim [other team name] [map name] [matchid]``. For example, if you're playing fnatic on dust2 you might run ``get5_scrim fnatic de_dust2``. The other team name defaults to "away" and the map name defaults to the current map. matchid defaults to "scrim".

Once you've done this, all that has to happen is teams to ready up to start the match.

#### Extra commands
- You can do !swap in chat to swap sides during the warmup phase if you want to start on a different side.
- You can use get5_ringer in console with a steamid to add a player to the "home" team as of 0.6.0
- If you forget commands, use ``!get5`` in chat, and you will get a user friendly menu to do all the above (new in 0.6.0+).

## Changing scrim settings

You can (and should) edit [addons/sourcemod/configs/get5/scrim_template.cfg](https://github.com/splewis/get5/blob/master/configs/get5/scrim_template.cfg). In this you can set any scrim-specific cvars in the ``cvars`` section. 

The default settings will playout all 30 rounds and shorten up the halftime break.

You also may want to lower ``tv_delay`` (and maybe ``tv_enable``) and other settings in your [live config](https://github.com/splewis/get5/blob/master/cfg/get5/live.cfg#L56) at ``cfg/get5/live.cfg``.

## How to prevent [practicemode](https://github.com/splewis/csgo-practice-mode) from starting during a game?

I suggest adding the ``sm_practicemode_can_be_started`` cvar (setting to 0) in your live config. get5 generally resets all cvars set in the live config once the match ends, so it will be restored to 1 after your scrim.

## Other tips

If you have a coach, I'd suggest installing the csgo_hearcoach plugin, it allows coaches to talk in deadtalk with your teammates (this used to be normal CS:GO behavior, but a CS:GO update changed it). You can download the csgo_hearcoach plugin from http://dl.whiffcity.com/plugins/sm-misc/. Just put the ``csgo_hearcoach.smx`` file in ``addons/sourcemod/plugins``. This comes from my [sm-misc](https://github.com/splewis/sm-misc) collection of plugins.