Get5 contains its own backup system on top of the backup system Valve has built into CS:GO. Every round start and match end get5 writes out a backup file that contains all the info needed to restart the match where it left of. These files will generally be named something like ``get5_backup_match1_map0_round3.txt``.

This file will contain:
- the original match config data
- series scores per team
- current sides for each team
- the built-in backup data CS:GO Valve created to restore money/weapons/current map score/etc.
- the get5 stats data

To load a match backup, you would run ``get5_loadbackup get5_backup_match1_map0_round3.txt``. Note: similar to valve's backup system, get5 has a cvar ``get5_last_backup_file`` that will be set to the last backup file get5 created. You can use this to figure out which get5 backup file to use when restoring.

You may backup from the last round (e.g., someone on both teams typing ``!stop`` in chat), any round in the current game, or a point in between maps. ``get5_loadbackup`` may be used when no match config is loaded, or when a match config is loaded.


### Steps to restore a backup to a restarted/different server

1. Copy the last get5_backup_* file (if you sort by most recently written, you should find it under the ``csgo`` directory)
2. Run ``get5_loadbackup <backupfile>`` on the backup file you copied.
