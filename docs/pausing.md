Get5 offers several cvars for how pausing will work:

- ``get5_max_pauses``: maximum number of pauses a team can use, 0=unlimited
- ``get5_max_pause_time``: maximum number of time the game can spend paused by a team, 0=unlimited
- ``get5_reset_pauses_each_half``: whether pause limits are reset each halftime period (default 1)
- ``get5_fixed_pause_time``: if nonzero, the fixed length all pauses will be
- ``get5_pausing_enabled``: whether pausing (!pause command) is enabled
- ``get5_allow_technical_pause``: whether technical pauses (!tech command) are enabled (default 1)

**Note**: technical pauses are unlimited in use and duration. There are no checks or limits on their usage, and require both teams (or just the admin in console) to to unpause. 


These can be set in ``cfg/sourcemod/get5.cfg``, or in a match config's ``cvars`` section.

The default settings will allow each team 300 seconds (5 minutes) of overall pause time per half. That is:
- ``get5_max_pauses = 0``
- ``get5_max_pause_time = 300``
- ``get5_reset_pauses_each_half = 1`` 
- ``get5_fixed_pause_time = 0`` 
- ``get5_pausing_enabled = 1`` 


To use the newer Valve-announced pausing ruleset of "each team has 4 30-second pauses per-map", you would use the following cvars:
- ``get5_max_pauses = 4``
- ``get5_reset_pauses_each_half = 0`` 
- ``get5_fixed_pause_time = 30`` 
- ``get5_pausing_enabled = 1`` 