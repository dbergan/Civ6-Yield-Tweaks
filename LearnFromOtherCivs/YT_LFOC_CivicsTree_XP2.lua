include "CivicsTree_Expansion2"

if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT
local YT_LeaderIconIM = {}

PRIOR_PopulateNode = PopulateNode
function PopulateNode(uiNode, playerTechData)
	PRIOR_PopulateNode(uiNode, playerTechData)

	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == false then return end

	if YT_LeaderIconIM[uiNode.Type] == nil then
		YT_LeaderIconIM[uiNode.Type] = InstanceManager:new("YT_LFOC_LeaderIconInstance", "Icon", uiNode.DB_NameStack)
	end
	YT_LeaderIconIM[uiNode.Type]:ResetInstances()
	local LocalPlayerID = Game.GetLocalPlayer()
	local AllPlayers = PlayerManager.GetAliveMajors()
	for _, Player in pairs(AllPlayers) do
		local PlayerID = Player:GetID() 
		local IsNotLocalPlayer = PlayerID ~= LocalPlayerID
		local HasMet = Player:GetDiplomacy():HasMet(LocalPlayerID)
		local HasCivic = Player:GetCulture():HasCivic(GameInfo.Civics[uiNode.Type].Index)

		if IsNotLocalPlayer and HasMet and HasCivic then
			local pPlayerConfig =  PlayerConfigurations[PlayerID]
			local instance = YT_LeaderIconIM[uiNode.Type]:GetInstance()
			local iconName = "ICON_" .. pPlayerConfig:GetLeaderTypeName()
			local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName)
			instance.Icon:SetTexture(textureOffsetX, textureOffsetY, textureSheet)
			local ToolTip = ""
			if DB_YT.GetEncounterPoints ~= nil then
				_, ToolTip = DB_YT.GetEncounterPoints(LocalPlayerID, PlayerID, "C")
			end
			ToolTip = "Already learned by " .. Locale.Lookup("{LOC_" .. pPlayerConfig:GetCivilizationTypeName() .. "_NAME}") .. ToolTip
			instance.Icon:SetToolTipString(ToolTip)
		end
	end
	if DB_YT.ProspectInformation ~= nil then
		local Turns = 0
		_, _, Turns = DB_YT.ProspectInformation(LocalPlayerID, GameInfo.Civics[uiNode.Type].Index, "C")
		if Turns <= 0 then
			uiNode.Turns:SetText("")
		else
			uiNode.Turns:SetText( Locale.Lookup("LOC_TECH_TREE_TURNS", Turns) )
		end
	end
end

PRIOR_OnFilterClicked = OnFilterClicked
function OnFilterClicked(filter)
	if GameConfiguration.GetValue("GAMEMODE_TREE_RANDOMIZER") == nil or GameConfiguration.GetValue("GAMEMODE_TREE_RANDOMIZER") == false then
		PRIOR_OnFilterClicked(filter)
	end
end