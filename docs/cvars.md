Note: these are auto-executed on plugin start by the auto-generated (the 1st time the plugin starts) file ``cfg/sourcemod/get5.cfg``.

You should either set these in the above file, or in the match config's ``cvars`` section. Note: cvars set in the ``cvars`` section of a match config will override other settings.

## Pausing

- ``get5_max_pauses``: maximum number of pauses a team can use, 0=unlimited
- ``get5_max_pause_time``: maximum number of time the game can spend paused by a team, 0=unlimited
- ``get5_reset_pauses_each_half``: whether pause limits are reset each halftime period (default 1)
- ``get5_fixed_pause_time``: if nonzero, the fixed length all pauses will be
- ``get5_pausing_enabled``: whether pausing (!pause command) is enabled
- ``get5_allow_technical_pause``: whether technical pauses (!tech command) are enabled (default 1)


## File name formatting

Note: for these, setting the cvar to an empty string ("") will disable the file writing entirely.

- ``get5_time_format``: time format string (default ``"%Y-%m-%d_%H``), only affects if a {TIME} tag is used in other file-name formatting cvars
- ``get5_demo_name_format``: format to name demo files in (default ``{MATCHID}_map{MAPNUMBER}_{MAPNAME}``)
- ``get5_event_log_format``: format to write get5 event logs to (default ``logs/get5_match{MATCHID}.log``)
- ``get5_stats_path_format``: path where stats are output each map end if set

### Substitation variables

Valid substitutions into the above file name formatting cvars (when surrounded by {}): 
- TIME
- MAPNAME
- MAPNUMBER
- MATCHID
- TEAM1
- TEAM2
- MATCHTITLE (not yet released; will be in 0.8.x)

## Match management timers
- ``get5_time_to_start``: time (in seconds) teams have to ready up before forfeiting the match, 0=unlimited
- ``get5_time_to_make_knife_decision``: time (in seconds) a team has to make a !stay/!swap decision after winning knife round, 0=unlimited
- ``get5_veto_countdown``: time (in seconds) to countdown before veto process commences
- ``get5_end_match_on_empty_server``: whether the match is ended with no winner if all players leave (note: this will happen even if all players disconnect even in warmup with the intention to reconnect!)

## Backup system

- ``get5_last_backup_file``: last match backup file get5 wrote in the current series, this is automatically updated by get5 each time a backup file is written
- ``get5_max_backup_age``: number of seconds before a get5 backup file is automatically deleted, 0 to disable

## Miscellaneous

- ``get5_autoload_config``: a config file to autoload on map starts if no match is loaded
- ``get5_check_auths``: whether the steamids from a "players" section are used to force players onto teams (default 1)
- ``get5_kick_when_no_match_loaded``: whether to kick all clients if no match is loaded
- ``get5_live_cfg``: config file executed when the game goes live
- ``get5_live_countdown_time``: number of seconds used to count down when a match is going live
- ``get5_message_prefix``: The tag applied before plugin messages
- ``get5_stop_command_enabled``: whether the !stop command is enabled
- ``get5_warmup_cfg``: config file executed in warmup periods
- ``get5_print_damage``: whether to print damage reports on round ends
- ``get5_damageprint_format``: formatting of damage reports: defaults to ``--> ({DMG_TO} dmg / {HITS_TO} hits) to ({DMG_FROM} dmg / {HITS_FROM} hits) from {NAME} ({HEALTH} HP)``