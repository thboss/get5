This is meant to be a more comprehensive explanation of how to install than in the readme: https://github.com/splewis/get5#download-and-installation

Before you start, make sure the CS:GO server is not running.

#### 1. Install Metamod:Source
Download from http://www.sourcemm.net/downloads. Make sure you get the latest version and for your server's operating system. To install, just merge the download's ``addons`` directory with the ``csgo/addons`` directory on the server.

You can confirm you did this correctly by trying the command ``meta version``.

#### 2. Install Sourcemod 
Download from http://www.sourcemod.net/downloads.php. Make sure you get the latest version and for your server's operating system. To install, just merge the ``addons`` and ``cfg`` directory with the ``addons`` and ``cfg`` directories in the server's root ``csgo`` directory.

You may want to add youself as sourcemod admin, see https://wiki.alliedmods.net/Adding_Admins_(SourceMod). Otherwise, get5 commands will have to be used via rcon or directly on the server.

You can confirm you did this correctly by trying the command ``sm version``.

#### 3. Install get5

Extract the download archive into the csgo/ directory on the server. At the very least, the plugin binary ``get5.smx`` must go into ``addons/sourcemod/plugins``, and the translations file ``get5.phrases.txt`` must go into ``addons/sourcemod/translations``. You are strongly recommended just to copy the entire release directories into your server, which will include the default ``cfg/live.cfg`` and ``cfg/warmup.cfg`` files. 

You can download from either the [last release](https://github.com/splewis/get5/releases) or the [last development build](http://ci.splewis.net/job/get5/lastSuccessfulBuild/).

#### 4. Install SteamWorks (optional)
Download the latest SteamWorks binary archive from http://users.alliedmods.net/~kyles/builds/SteamWorks/. Merge the ``addons`` directory in the download with the server's ``addons`` directory.

#### 5. Install get5_apistats plugin (optional)
If you want to use the [get5 web panel](https://github.com/splewis/get5-web) to manage matches and display stats, then you should install the get5_apistats plugin in addition to the get5 plugin. In addition to ``get5.smx`` in ``addons/sourcemod/plugins``, you should have copied ``get5_apistats.smx`` into that directory as well. Both plugins are included in releases/builds.

Note: this requires that you installed the SteamWorks extension from step 5. The command ``get5_web_avaliable`` will tell you if this plugin was successfully installed. If not, it will reply with "unknown command".

#### 6. Create a match config

**NOTE**: if you're just using get5 for scrims don't do this follow these steps: https://github.com/splewis/get5/docs/get5_for_scrims.md

The readme describes the match schema format: https://github.com/splewis/get5#match-schema

I recommend starting from the [example file](https://github.com/splewis/get5/blob/master/configs/get5/example_match.cfg) and modifying it. Note that many fields are optional. Only the "team1" and "team2" sections are actually required. So you can remove the "favored_percentage_team1" field, if you don't want it displayed/have no data for it.

Match configs must be placed anywhere under the ``csgo`` server directory. For example:
- if your match config is at ``csgo/match.cfg``, you can use ``get5_loadmatch match.cfg``
- if your match config is at ``csgo/addons/sourcemod/configs/get5/match.cfg``, you can use ``get5_loadmatch addons/sourcemod/configs/get5/match.cfg``