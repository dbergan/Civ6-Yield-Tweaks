include('YT_LearnFromOtherCivs_UI')
YT_CivicPopulateNode_LeaderIconIM = {}

PRIOR_PopulateNode = PopulateNode
function PopulateNode(uiNode, playerTechData)
	PRIOR_PopulateNode(uiNode, playerTechData)

	-- skip unrevealed nodes
	if not playerTechData[DATA_FIELD_LIVEDATA][uiNode.Type].IsRevealed then return end

	PlaceLeaderIcons(YT_CivicPopulateNode_LeaderIconIM, uiNode.DB_NameStack, uiNode, uiNode.Type, GameInfo.Civics[uiNode.Type].Index, "C", -5, -25)
end

-- DB - remove the civic filter when playing in the random tech tree mode [ALL]
PRIOR_OnFilterClicked = OnFilterClicked
function OnFilterClicked(filter)
	if not GameConfiguration.GetValue("GAMEMODE_TREE_RANDOMIZER") then
		PRIOR_OnFilterClicked(filter)
	end
end