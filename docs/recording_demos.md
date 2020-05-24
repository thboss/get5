### Enabling demos

By default, get5 will record a demo for each game. To do this, you need to enable GOTV on your server. Typically, that is done by adding ``tv_enable 1`` into your server.cfg file. Generally, that is the only action required to get a demo to be recorded.

Once a match starts, the server will issue a ``tv_record`` command with a file based on the value of ``get5_demo_name_format``. This cvar defaults to ``{MATCHID}_map{MAPNUMBER}_{MAPNAME}``. For example, the demo might look something like: ``3_map1_de_dust2.dem``.
 

### Disabling demos

Setting ``get5_demo_name_format`` to `""` will disable demos.

### Where are the demos?

In the root `csgo` directory on the game server. All get5 is doing is issuing a ``tv_record`` command, so it's no different from manually running the command.

### Uploading match demo on game end

Currently, get5 doesn't do any automatic upload of the demo file. For now, if you are willing to write your own sourcepawn plugin, you can use the ``void Get5_OnDemoFinished(const char[] filename)`` forward that get5 provides to do anything you want with the demo file.