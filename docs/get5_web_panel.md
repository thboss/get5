The [get5 web panel](https://github.com/splewis/get5-web) project can be used along with the get5 game server plugin to make managing matches easier.

To use the web panel, you must have both:
- the get5 server plugin installed
- the get5_apistats plugin installed (this **requires** both the SteamWorks extension and the smjansson extension)

Installing the get5_apistats plugin only requires that you place it's plugin binary (``get5_apistats.smx``) in the ``addons/sourcemod/plugins`` as long as you have SteamWorks and get5 installed.


The get5_apistats plugin does the following:
- receives a api key (saved in ``get5_web_api_url``) and api url (saved in``get5_web_api_key``) from the ``cvars`` section of a match JSON config loaded remotely from the web panel (via the ``get5_loadmatch_url`` command in get5)
- on series start, map start, map end, and round ends sends HTTP requests to the web API to update the stats