include "ResearchChooser_Expansion1"

-- From G:\SteamLibrary\steamapps\common\Sid Meier's Civilization VI\DLC\Expansion2\UI\Replacements\ResearchChooser_Expansion1.lua
-- edits marked with DB
function AddAvailableResearch( playerID:number, kData:table )
	local kControl = BASE_AddAvailableResearch(playerID, kData);
-- DB
	kControl.Alliance:SetHide(true)
-- /DB
	if kData then
		local techID = GameInfo.Technologies[kData.TechType].Index;
		if AllyHasOrIsResearchingTech(techID) then
			kControl.AllianceIcon:SetToolTipString(GetAllianceIconToolTip());
			kControl.AllianceIcon:SetColor(GetAllianceIconColor());
			kControl.Alliance:SetHide(false);
		else
			kControl.Alliance:SetHide(true);
		end
	end
-- DB
	return kControl
-- /DB
end





if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT
local YT_LeaderIconIM = {}
local YT_LeaderIconIM2 = {}

PRIOR_AddAvailableResearch = AddAvailableResearch
function AddAvailableResearch( playerID:number, kData:table )
	kItemInstance = PRIOR_AddAvailableResearch(playerID, kData)

	if kData == nil then return end
	if kData.TechType == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == false then return end

	if YT_LeaderIconIM[kData.TechType] == nil then
		YT_LeaderIconIM[kData.TechType] = InstanceManager:new("YT_LFOC_LeaderIconInstance", "Icon", kItemInstance.DB_NameStack)
	end
	YT_LeaderIconIM[kData.TechType]:ResetInstances()
	local LocalPlayerID = Game.GetLocalPlayer()
	local AllPlayers = PlayerManager.GetAliveMajors()
	for _, Player in pairs(AllPlayers) do
		local PlayerID = Player:GetID() 
		local IsNotLocalPlayer = PlayerID ~= LocalPlayerID
		local HasMet = Player:GetDiplomacy():HasMet(LocalPlayerID)
		local HasTech = Player:GetTechs():HasTech(GameInfo.Technologies[kData.TechType].Index)
		if IsNotLocalPlayer and HasMet and HasTech then
			local pPlayerConfig =  PlayerConfigurations[PlayerID]
			local instance = YT_LeaderIconIM[kData.TechType]:GetInstance()
			local iconName = "ICON_" .. pPlayerConfig:GetLeaderTypeName()
			local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName)
			instance.Icon:SetTexture(textureOffsetX, textureOffsetY, textureSheet)
			local ToolTip = ""
			if DB_YT.GetEncounterPoints ~= nil then
				_, ToolTip = DB_YT.GetEncounterPoints(LocalPlayerID, PlayerID, "S")
			end
			ToolTip = "Already learned by " .. Locale.Lookup("{LOC_" .. pPlayerConfig:GetCivilizationTypeName() .. "_NAME}") .. ToolTip
			instance.Icon:SetToolTipString(ToolTip)

			instance.Icon:SetOffsetVal(-5, -30)
		end
	end
	if DB_YT.ProspectInformation ~= nil then
		local Turns = 0
		_, _, Turns = DB_YT.ProspectInformation(LocalPlayerID, GameInfo.Technologies[kData.TechType].Index, "S")
		if Turns <= 0 then
			kItemInstance.TurnsLeft:SetText("")
		else
			kItemInstance.TurnsLeft:SetText( "[ICON_Turn]" .. tostring(Turns) )
		end
	end
end

PRIOR_RealizeCurrentResearch = RealizeCurrentResearch
function RealizeCurrentResearch( playerID:number, kData:table, kControl:table )
	if kControl == nil then
		kControl = Controls
	end
	if kControl.Alliance ~= nil then
		kControl.Alliance:SetHide(true)
	end

	PRIOR_RealizeCurrentResearch(playerID, kData, kControl)

	if kData == nil then return end
	if kData.TechType == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == false then return end

	for _, v in pairs(YT_LeaderIconIM2) do
		v:ResetInstances()
	end
	if YT_LeaderIconIM2[kData.TechType] == nil then
		YT_LeaderIconIM2[kData.TechType] = InstanceManager:new("YT_LFOC_LeaderIconInstance", "Icon", kControl.TitleStack)
	end
	YT_LeaderIconIM2[kData.TechType]:ResetInstances()
	local LocalPlayerID = Game.GetLocalPlayer()
	local AllPlayers = PlayerManager.GetAliveMajors()
	for _, Player in pairs(AllPlayers) do
		local PlayerID = Player:GetID() 
		local IsNotLocalPlayer = PlayerID ~= LocalPlayerID
		local HasMet = Player:GetDiplomacy():HasMet(LocalPlayerID)
		local HasTech = Player:GetTechs():HasTech(GameInfo.Technologies[kData.TechType].Index)

		if IsNotLocalPlayer and HasMet and HasTech then
			local pPlayerConfig =  PlayerConfigurations[PlayerID]
			local instance = YT_LeaderIconIM2[kData.TechType]:GetInstance()
			local iconName = "ICON_" .. pPlayerConfig:GetLeaderTypeName()
			local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName)
			instance.Icon:SetTexture(textureOffsetX, textureOffsetY, textureSheet)
			local ToolTip = ""
			if DB_YT.GetEncounterPoints ~= nil then
				_, ToolTip = DB_YT.GetEncounterPoints(LocalPlayerID, PlayerID, "S")
			end
			ToolTip = "Already learned by " .. Locale.Lookup("{LOC_" .. pPlayerConfig:GetCivilizationTypeName() .. "_NAME}") .. ToolTip
			instance.Icon:SetToolTipString(ToolTip)
			instance.Icon:SetOffsetVal(-5, -15)
		end
	end
	if DB_YT.ProspectInformation ~= nil then
		local Turns = 0
		_, _, Turns = DB_YT.ProspectInformation(LocalPlayerID, GameInfo.Technologies[kData.TechType].Index, "S")
		if Turns <= 0 then
			kControl.TurnsLeft:SetText("")
		else
			kControl.TurnsLeft:SetText( "[ICON_Turn]" .. tostring(Turns) )
		end
	end
end

PRIOR_OnChooseResearch = OnChooseResearch
function OnChooseResearch (techHash:number)
	if YT_LeaderIconIM ~= nil then
		for _, v in pairs(YT_LeaderIconIM) do
			v:ResetInstances()
		end
	end
	if YT_LeaderIconIM2 ~= nil then
		for _, v in pairs(YT_LeaderIconIM2) do
			v:ResetInstances()
		end
	end

	PRIOR_OnChooseResearch(techHash)
end