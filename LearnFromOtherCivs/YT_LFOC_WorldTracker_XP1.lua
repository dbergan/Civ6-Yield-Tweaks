include "WorldTracker_Expansion1"


if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT
local YT_LeaderIconIM = {}
local YT_LeaderIconIM2 = {}

PRIOR_RealizeCurrentResearch = RealizeCurrentResearch
function RealizeCurrentResearch(playerID, kData, kControl)
	if kControl == nil then
		kControl = Controls
	end

	PRIOR_RealizeCurrentResearch(playerID, kData, kControl)

	if kData == nil then return end
	if kData.TechType == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == false then return end

	for _, v in pairs(YT_LeaderIconIM) do
		v:ResetInstances()
	end
	if YT_LeaderIconIM[kData.TechType] == nil then
		YT_LeaderIconIM[kData.TechType] = InstanceManager:new("YT_LFOC_LeaderIconInstance", "Icon", kControl.DB_TitleStack)
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
			instance.Icon:SetOffsetVal(-5, -15)
		end
	end
	if DB_YT.ProspectInformation == nil then
		kControl.TurnsLeft:SetText("")
		kControl.TurnsLeftLabel:SetHide(true)
	else
		local Turns = 0
		_, _, Turns = DB_YT.ProspectInformation(LocalPlayerID, GameInfo.Technologies[kData.TechType].Index, "S")
		if Turns <= 0 then
			kControl.TurnsLeft:SetText("")
			kControl.TurnsLeftLabel:SetHide(true)
		else
			kControl.TurnsLeft:SetText( "[ICON_Turn]" .. tostring(Turns) )
			kControl.TurnsLeftLabel:SetHide(false)
		end
	end
end

PRIOR_RealizeCurrentCivic = RealizeCurrentCivic
function RealizeCurrentCivic(playerID, kData, kControl, cachedModifiers)
	PRIOR_RealizeCurrentCivic(playerID, kData, kControl, cachedModifiers)

	if kData == nil then return end
	if kData.CivicType == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == nil then return end
	if GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") == false then return end

	if kControl == nil then
		kControl = Controls
	end
	for _, v in pairs(YT_LeaderIconIM2) do
		v:ResetInstances()
	end
	if YT_LeaderIconIM2[kData.CivicType] == nil then
		YT_LeaderIconIM2[kData.CivicType] = InstanceManager:new("YT_LFOC_LeaderIconInstance", "Icon", kControl.DB_TitleStack)
	end
	YT_LeaderIconIM2[kData.CivicType]:ResetInstances()
	local LocalPlayerID = Game.GetLocalPlayer()
	local AllPlayers = PlayerManager.GetAliveMajors()
	for _, Player in pairs(AllPlayers) do
		local PlayerID = Player:GetID()
		local IsNotLocalPlayer = PlayerID ~= LocalPlayerID
		local HasMet = Player:GetDiplomacy():HasMet(LocalPlayerID)
		local HasCivic = Player:GetCulture():HasCivic(GameInfo.Civics[kData.CivicType].Index)

		if IsNotLocalPlayer and HasMet and HasCivic then
			local pPlayerConfig =  PlayerConfigurations[PlayerID]
			local instance = YT_LeaderIconIM2[kData.CivicType]:GetInstance()
			local iconName = "ICON_" .. pPlayerConfig:GetLeaderTypeName()
			local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName)
			instance.Icon:SetTexture(textureOffsetX, textureOffsetY, textureSheet)
			local ToolTip = ""
			if DB_YT.GetEncounterPoints ~= nil then
				_, ToolTip = DB_YT.GetEncounterPoints(LocalPlayerID, PlayerID, "C")
			end
			ToolTip = "Already learned by " .. Locale.Lookup("{LOC_" .. pPlayerConfig:GetCivilizationTypeName() .. "_NAME}") .. ToolTip
			instance.Icon:SetToolTipString(ToolTip)
			instance.Icon:SetOffsetVal(-5, -15)
		end
	end
	if DB_YT.ProspectInformation == nil then
		kControl.TurnsLeft:SetText("")
		kControl.TurnsLeftLabel:SetHide(true)
	else
		local Turns = 0
		_, _, Turns = DB_YT.ProspectInformation(LocalPlayerID, GameInfo.Civics[kData.CivicType].Index, "C")
		if Turns <= 0 then
			kControl.TurnsLeft:SetText("")
			kControl.TurnsLeftLabel:SetHide(true)
		else
			kControl.TurnsLeft:SetText( "[ICON_Turn]" .. tostring(Turns) )
			kControl.TurnsLeftLabel:SetHide(false)
		end
	end
end