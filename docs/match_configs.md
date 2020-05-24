The match config is described in the readme: https://github.com/splewis/get5#match-schema

This page aims to give advice on manually managing these config files.

**Note: this requires at least being on a 0.2.0 development build**

## Going *laissez faire*

The cvar ``get5_check_auths`` (which you should set in ``cfg/sourcemod/get5.cfg``, or the match config ``cvars`` section) can be set to 0, which will stop the plugin from forcing players onto the correct team. This means the ``players`` section will not be used, and can be omitted if you don't want to set everyone's steamid. 

This is generally not recommended, as there are great advantages to letting the plugin handle forcing players onto the correct teams and kicking people that shouldn't be in the server.

## Managing team data from separate files

One strategy for storing all the team data is to create a config for each team, then you can use the "fromfile" field when creating match configs.

By using this strategy, you would:
- Create a team config file for every team in your tournament/league/etc.
- When a match is played, update the server's match config team1:fromfile and team2:fromfile fields.

For example:
``match.cfg``:
```
"Match"
{

	"maps_to_win"		"1"
	"skip_veto"		"0"
	"side_type"		"standard"

	"maplist"
	{
		"de_cache"		""
		"de_cbble"		""
		"de_dust2"		""
		"de_mirage"		""
		"de_nuke"		""
		"de_overpass"		""
		"de_train"		""
	}

	"players_per_team"		"5"

	"team1"
	{
		"fromfile"		"addons/sourcemod/configs/get5/team_nip.cfg"
	}

	"team2"
	{
		"fromfile"		"addons/sourcemod/configs/get5/team_nv.cfg"
	}

	"cvars"
	{
		"hostname"		"Match server #1"
	}
}
```

``team_nip.cfg``:
```
"team"
{
	"name"		"NiP" 
	"flag"		"SE"
	"logo"		"nip"
	"matchtext"		""
	"players"
	{
		"STEAM_1:1:52245092"		""
	}
}
```

``team_nv.cfg``:
```
"team"
{
	"name"		"EnvyUs" 
	"flag"		"FR"
	"logo"		"nv"
	"matchtext"		""
	"players"
	{
		"STEAM_1:0:78189799"		""
	}
}
```

Note: this works for both KeyValues and JSON formatted configs.