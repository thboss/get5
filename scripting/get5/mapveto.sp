/**
 * Map vetoing functions
 */

#define CONFIRM_NEGATIVE_VALUE "_"

public void CreateVeto() {
  if (g_MapPoolList.Length % 2 == 0) {
    LogError(
        "Warning, the maplist is even number sized (%d maps), vetos may not function correctly!",
        g_MapPoolList.Length);
  }

  g_VetoCaptains[Get5Team_1] = GetTeamCaptain(Get5Team_1);
  g_VetoCaptains[Get5Team_2] = GetTeamCaptain(Get5Team_2);
  ResetReadyStatus();
  if (g_PauseOnVetoCvar.BoolValue) {
    PauseGame(Get5Team_None, Get5PauseType_Admin);
  }
  CreateTimer(1.0, Timer_VetoCountdown, _, TIMER_REPEAT);
}

public Action Timer_VetoCountdown(Handle timer) {
  static int warningsPrinted = 0;
  if (warningsPrinted >= g_VetoCountdownCvar.IntValue) {
    warningsPrinted = 0;
    Get5Team startingTeam = OtherMatchTeam(g_LastVetoTeam);
    VetoController(g_VetoCaptains[startingTeam]);
    return Plugin_Stop;
  } else {
    warningsPrinted++;
    int secondsRemaining = g_VetoCountdownCvar.IntValue - warningsPrinted + 1;
    Get5_MessageToAll("%t", "VetoCountdown", secondsRemaining);
    return Plugin_Continue;
  }
}

static void AbortVeto() {
  Get5_MessageToAll("%t", "CaptainLeftOnVetoInfoMessage");
  Get5_MessageToAll("%t", "ReadyToResumeVetoInfoMessage");
  ChangeState(Get5State_PreVeto);
}

public void VetoFinished() {
  ChangeState(Get5State_Warmup);
  Get5_MessageToAll("%t", "MapDecidedInfoMessage");

  if (IsPaused()) {
    UnpauseGame(Get5Team_None);
  }

  // Use total series score as starting point, to not print skipped maps
  int seriesScore = g_TeamSeriesScores[Get5Team_1] + g_TeamSeriesScores[Get5Team_2];
  for (int i = seriesScore; i < g_MapsToPlay.Length; i++) {
    char map[PLATFORM_MAX_PATH];
    g_MapsToPlay.GetString(i, map, sizeof(map));
    Get5_MessageToAll("%t", "MapIsInfoMessage", i + 1 - seriesScore, map);
  }

  g_MapChangePending = true;
  CreateTimer(10.0, Timer_NextMatchMap);
}

// Main Veto Controller

public void VetoController(int client) {
  if (!IsPlayer(client) || GetClientMatchTeam(client) == Get5Team_Spec) {
    AbortVeto();
  }

  int mapsLeft = g_MapsLeftInVetoPool.Length;
  int maxMaps = MaxMapsToPlay(g_MapsToWin);

  int mapsPicked = g_MapsToPlay.Length;
  int sidesSet = g_MapSides.Length;

  int seriesScore = g_TeamSeriesScores[Get5Team_1] + g_TeamSeriesScores[Get5Team_2];

  // This is a dirty hack to get ban/ban/pick/pick/ban/ban
  // instead of straight vetoing until the maplist is the length
  // of the series.
  // This only applies to a standard Bo3 in the 7-map pool.
  // TODO: It should be written more generically.
  bool bo3_hack = false;
  if (maxMaps == 3 && (mapsLeft == 4 || mapsLeft == 5) && g_MapPoolList.Length == 7) {
    bo3_hack = true;
  }

  // Yet another dirty hack to skip the last two bans if we are
  // in a situation where one a team has map advantage.
  bool bo3_last_veto_hack = false;
  if (maxMaps == 3 && mapsLeft <= 3 && seriesScore > 0 && g_MapPoolList.Length == 7) {
    bo3_last_veto_hack = true;
  }

  // This is also a bit hacky.
  // The purpose is to force the veto process to take a
  // ban/ban/ban/ban/pick/pick/last map unused process for BO2's.
  bool bo2_hack = false;
  if (g_BO2Match && (mapsLeft == 3 || mapsLeft == 2)) {
    bo2_hack = true;
  }

  if (sidesSet < mapsPicked) {
    if (g_MatchSideType == MatchSideType_Standard) {
      GiveSidePickMenu(client);

    } else if (g_MatchSideType == MatchSideType_AlwaysKnife) {
      g_MapSides.Push(SideChoice_KnifeRound);
      VetoController(client);

    } else if (g_MatchSideType == MatchSideType_NeverKnife) {
      g_MapSides.Push(SideChoice_Team1CT);
      VetoController(client);
    }

  } else if (mapsLeft == seriesScore || bo3_last_veto_hack) {
    // We have as many maps left as the total series score, or we can skip the last two
    // bans in a bo3 which means some maps will be skipped (i.e. they have already been "won" by a
    // team)
    // If series score is 0 we won't get here

    // Add maps to the front of the active maplist equal to the total series score, as these are the
    // maps
    // that will be skipped
    char mapName[PLATFORM_MAX_PATH];
    for (int i = 0; i < seriesScore; i++) {
      // Get the next map in the veto pool
      g_MapsLeftInVetoPool.GetString(0, mapName, sizeof(mapName));
      g_MapsLeftInVetoPool.Erase(0);

      // Add it to the front of the active maplist
      g_MapsToPlay.ShiftUp(0);
      g_MapsToPlay.SetString(0, mapName);

      // Add a side type to map sides too, so the sides don't come out of order
      g_MapSides.ShiftUp(0);
      g_MapSides.Set(0, SideChoice_KnifeRound);
    }

    // We're specifically not firing any events here, as the maps will be skipped anyway
    // TODO: maybe we should?

    VetoFinished();

  } else if (mapsLeft == 1) {
    if (g_BO2Match) {
      // Terminate the veto since we've had ban-ban-ban-ban-pick-pick
      VetoFinished();
      return;
    }

    // Only 1 map left in the pool, add it directly to the active maplist.
    char mapName[PLATFORM_MAX_PATH];
    g_MapsLeftInVetoPool.GetString(0, mapName, sizeof(mapName));
    g_MapsToPlay.PushString(mapName);

    if (g_MatchSideType == MatchSideType_Standard) {
      g_MapSides.Push(SideChoice_KnifeRound);
    } else if (g_MatchSideType == MatchSideType_AlwaysKnife) {
      g_MapSides.Push(SideChoice_KnifeRound);
    } else if (g_MatchSideType == MatchSideType_NeverKnife) {
      g_MapSides.Push(SideChoice_Team1CT);
    }

    Get5MapPickedEvent event =
        new Get5MapPickedEvent(g_MatchID, Get5Team_None, mapName, g_MapsToPlay.Length - 1);

    LogDebug("Calling Get5_OnMapPicked()");

    Call_StartForward(g_OnMapPicked);
    Call_PushCell(event);
    Call_Finish();

    EventLogger_LogAndDeleteEvent(event);

    VetoFinished();
  } else if (mapsLeft + mapsPicked <= maxMaps || bo3_hack || bo2_hack) {
    GiveMapPickMenu(client);
  } else {
    GiveMapVetoMenu(client);
  }
}

// Confirmations

public void GiveConfirmationMenu(int client, MenuHandler handler, const char[] title,
                          const char[] confirmChoice) {
  // Figure out text for positive and negative values
  char positiveBuffer[1024], negativeBuffer[1024];
  Format(positiveBuffer, sizeof(positiveBuffer), "%T", "ConfirmPositiveOptionText", client);
  Format(negativeBuffer, sizeof(negativeBuffer), "%T", "ConfirmNegativeOptionText", client);

  // Create menu
  Menu menu = new Menu(handler);
  menu.SetTitle("%T", title, client, confirmChoice);
  menu.ExitButton = false;
  menu.Pagination = MENU_NO_PAGINATION;

  // Add rows of padding to move selection out of "danger zone"
  for (int i = 0; i < 7; i++) {
    menu.AddItem(CONFIRM_NEGATIVE_VALUE, "", ITEMDRAW_NOTEXT);
  }

  // Add actual choices
  menu.AddItem(confirmChoice, positiveBuffer);
  menu.AddItem(CONFIRM_NEGATIVE_VALUE, negativeBuffer);

  // Show menu and disable confirmations
  g_ActiveVetoMenu = menu;
  menu.Display(client, MENU_TIME_FOREVER);
  SetConfirmationTime(false);
}

static void SetConfirmationTime(bool enabled) {
  if (enabled) {
    g_VetoMenuTime = GetTickedTime();
  } else {
    // Set below 0 to signal that we don't want confirmation
    g_VetoMenuTime = -1.0;
  }
}

static bool ConfirmationNeeded() {
  // Don't give confirmations if it's been disabled
  if (g_VetoConfirmationTimeCvar.FloatValue <= 0.0) {
    return false;
  }
  // Don't give confirmation if the veto time is less than 0
  // (in case we're presenting a menu that doesn't need confirmation)
  if (g_VetoMenuTime < 0.0) {
    return false;
  }

  float diff = GetTickedTime() - g_VetoMenuTime;
  return diff <= g_VetoConfirmationTimeCvar.FloatValue;
}

static bool ConfirmationNegative(const char[] choice) {
  return StrEqual(choice, CONFIRM_NEGATIVE_VALUE);
}

// Map Vetos

public void GiveMapVetoMenu(int client) {
  Menu menu = new Menu(MapVetoMenuHandler);
  menu.SetTitle("%T", "MapVetoBanMenuText", client);
  menu.ExitButton = false;
  // Don't paginate the menu if we have 7 maps or less, as they will fit
  // on one page when we don't add the pagination options
  if (g_MapsLeftInVetoPool.Length <= 7) {
    menu.Pagination = MENU_NO_PAGINATION;
  }

  char mapName[PLATFORM_MAX_PATH];
  for (int i = 0; i < g_MapsLeftInVetoPool.Length; i++) {
    g_MapsLeftInVetoPool.GetString(i, mapName, sizeof(mapName));
    menu.AddItem(mapName, mapName);
  }
  g_ActiveVetoMenu = menu;
  menu.Display(client, MENU_TIME_FOREVER);
  SetConfirmationTime(true);
}

public int MapVetoMenuHandler(Menu menu, MenuAction action, int param1, int param2) {
  if (action == MenuAction_Select) {
    int client = param1;
    Get5Team team = GetClientMatchTeam(client);
    char mapName[PLATFORM_MAX_PATH];
    menu.GetItem(param2, mapName, sizeof(mapName));

    // Go back if we were called from a confirmation menu and client selected no
    if (ConfirmationNegative(mapName)) {
      GiveMapVetoMenu(client);
      return;
    }
    // Show a confirmation menu if needed
    if (ConfirmationNeeded()) {
      GiveConfirmationMenu(client, MapVetoMenuHandler, "MapVetoBanConfirmMenuText", mapName);
      return;
    }

    RemoveStringFromArray(g_MapsLeftInVetoPool, mapName);

    Get5_MessageToAll("%t", "TeamVetoedMapInfoMessage", g_FormattedTeamNames[team], mapName);

    Get5MapVetoedEvent event = new Get5MapVetoedEvent(g_MatchID, team, mapName);

    LogDebug("Calling Get5_OnMapVetoed()");
    Call_StartForward(g_OnMapVetoed);
    Call_PushCell(event);
    Call_Finish();

    EventLogger_LogAndDeleteEvent(event);

    VetoController(GetNextTeamCaptain(client));
    g_LastVetoTeam = team;

  } else if (action == MenuAction_Cancel) {
    if (g_GameState == Get5State_Veto) {
      AbortVeto();
    }

  } else if (action == MenuAction_End) {
    delete menu;
  }
}

// Map Picks

public void GiveMapPickMenu(int client) {
  Menu menu = new Menu(MapPickMenuHandler);
  menu.SetTitle("%T", "MapVetoPickMenuText", client);
  menu.ExitButton = false;
  // Don't paginate the menu if we have 7 maps or less, as they will fit
  // on one page when we don't add the pagination options
  if (g_MapsLeftInVetoPool.Length <= 7) {
    menu.Pagination = MENU_NO_PAGINATION;
  }

  char mapName[PLATFORM_MAX_PATH];
  for (int i = 0; i < g_MapsLeftInVetoPool.Length; i++) {
    g_MapsLeftInVetoPool.GetString(i, mapName, sizeof(mapName));
    menu.AddItem(mapName, mapName);
  }
  g_ActiveVetoMenu = menu;
  menu.Display(client, MENU_TIME_FOREVER);
  SetConfirmationTime(true);
}

public int MapPickMenuHandler(Menu menu, MenuAction action, int param1, int param2) {
  if (action == MenuAction_Select) {
    int client = param1;
    Get5Team team = GetClientMatchTeam(client);
    char mapName[PLATFORM_MAX_PATH];
    menu.GetItem(param2, mapName, sizeof(mapName));

    // Go back if we were called from a confirmation menu and client selected no
    if (ConfirmationNegative(mapName)) {
      GiveMapPickMenu(client);
      return;
    }
    // Show a confirmation menu if needed
    if (ConfirmationNeeded()) {
      GiveConfirmationMenu(client, MapPickMenuHandler, "MapVetoPickConfirmMenuText", mapName);
      return;
    }

    g_MapsToPlay.PushString(mapName);
    RemoveStringFromArray(g_MapsLeftInVetoPool, mapName);

    Get5_MessageToAll("%t", "TeamPickedMapInfoMessage", g_FormattedTeamNames[team], mapName,
                      g_MapsToPlay.Length);
    g_LastVetoTeam = team;

    Get5MapPickedEvent event =
        new Get5MapPickedEvent(g_MatchID, team, mapName, g_MapsToPlay.Length - 1);

    LogDebug("Calling Get5_OnMapPicked()");

    Call_StartForward(g_OnMapPicked);
    Call_PushCell(event);
    Call_Finish();

    EventLogger_LogAndDeleteEvent(event);

    VetoController(GetNextTeamCaptain(client));

  } else if (action == MenuAction_Cancel) {
    if (g_GameState == Get5State_Veto) {
      AbortVeto();
    }

  } else if (action == MenuAction_End) {
    delete menu;
  }
}

// Side Picks

public void GiveSidePickMenu(int client) {
  Menu menu = new Menu(SidePickMenuHandler);
  menu.ExitButton = false;
  char mapName[PLATFORM_MAX_PATH];
  g_MapsToPlay.GetString(g_MapsToPlay.Length - 1, mapName, sizeof(mapName));
  menu.SetTitle("%T", "MapVetoSidePickMenuText", client, mapName);
  menu.AddItem("CT", "CT");
  menu.AddItem("T", "T");
  g_ActiveVetoMenu = menu;
  menu.Display(client, MENU_TIME_FOREVER);
  SetConfirmationTime(true);
}

public int SidePickMenuHandler(Menu menu, MenuAction action, int param1, int param2) {
  if (action == MenuAction_Select) {
    int client = param1;
    Get5Team team = GetClientMatchTeam(client);
    char choice[PLATFORM_MAX_PATH];
    menu.GetItem(param2, choice, sizeof(choice));

    // Go back if we were called from a confirmation menu and client selected no
    if (ConfirmationNegative(choice)) {
      GiveSidePickMenu(client);
      return;
    }
    // Show a confirmation menu if needed
    if (ConfirmationNeeded()) {
      GiveConfirmationMenu(client, SidePickMenuHandler, "MapVetoSidePickConfirmMenuText", choice);
      return;
    }

    int selectedSide;
    if (StrEqual(choice, "CT")) {
      selectedSide = CS_TEAM_CT;
      if (team == Get5Team_1)
        g_MapSides.Push(SideChoice_Team1CT);
      else
        g_MapSides.Push(SideChoice_Team1T);
    } else {
      selectedSide = CS_TEAM_T;
      if (team == Get5Team_1)
        g_MapSides.Push(SideChoice_Team1T);
      else
        g_MapSides.Push(SideChoice_Team1CT);
    }

    int mapNumber = g_MapsToPlay.Length - 1;

    char mapName[PLATFORM_MAX_PATH];
    g_MapsToPlay.GetString(mapNumber, mapName, sizeof(mapName));

    Get5_MessageToAll("%t", "TeamSelectSideInfoMessage", g_FormattedTeamNames[team], choice,
                      mapName);

    Get5SidePickedEvent event = new Get5SidePickedEvent(g_MatchID, mapNumber, mapName, team,
                                                        view_as<Get5Side>(selectedSide));

    LogDebug("Calling Get5_OnSidePicked()");

    Call_StartForward(g_OnSidePicked);
    Call_PushCell(event);
    Call_Finish();

    EventLogger_LogAndDeleteEvent(event);

    VetoController(client);

  } else if (action == MenuAction_Cancel) {
    if (g_GameState == Get5State_Veto) {
      AbortVeto();
    }

  } else if (action == MenuAction_End) {
    delete menu;
  }
}
