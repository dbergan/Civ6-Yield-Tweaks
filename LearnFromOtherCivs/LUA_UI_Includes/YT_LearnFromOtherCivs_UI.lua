if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT


function ProspectInformation(ActivePlayerID, ResearchItemID, SciOrCulture, TruncateOverflow)		-- SciOrCulture = "S" or "C"
	if ActivePlayerID == -1 or Players == nil then return 0, "", 0 end
	TruncateOverflow = TruncateOverflow or false

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerDiplomacy = ActivePlayer:GetDiplomacy()
	local ActivePlayerResearch = {}
	local CurrentYield = 0
	local ProgLeft = 0
	if SciOrCulture == "S" then
		ActivePlayerResearch = ActivePlayer:GetTechs()
		CurrentYield = ActivePlayerResearch:GetScienceYield()
		ProgLeft = ActivePlayerResearch:GetResearchCost(ResearchItemID) - ActivePlayerResearch:GetResearchProgress(ResearchItemID)
	else
		ActivePlayerResearch = ActivePlayer:GetCulture()
		CurrentYield = ActivePlayerResearch:GetCultureYield()
		ProgLeft = ActivePlayerResearch:GetCultureCost(ResearchItemID) - ActivePlayerResearch:GetCulturalProgress(ResearchItemID)
	end

	local Encounters = {}
	for _, Opponent in ipairs(PlayerManager.GetAliveMajors()) do
		local OpponentID = Opponent:GetID()
		if OpponentID ~= ActivePlayerID then
			if ActivePlayerDiplomacy:HasMet(OpponentID) then
				if (SciOrCulture == "S" and Opponent:GetTechs():HasTech(ResearchItemID)) or (SciOrCulture == "C" and Opponent:GetCulture():HasCivic(ResearchItemID)) then
					local temp = { OpponentName = PlayerConfigurations[OpponentID]:GetCivilizationTypeName(), EncounterPoints = GetEncounterPoints(ActivePlayerID, OpponentID, 1, SciOrCulture) }
					table.insert(Encounters, temp)
				end
			end
		end
	end
	table.sort(Encounters, function(a,b) if a.EncounterPoints == b.EncounterPoints then return a.OpponentName < b.OpponentName else return a.EncounterPoints > b.EncounterPoints end end)

	local Bonus = 0
	local TotalBonus = 0
	local Notifications = {}
	for i, Encounter in ipairs(Encounters) do
		local Bonus = CurrentYield * Encounter.EncounterPoints / 100
		Bonus = Bonus * (0.5 ^ (i - 1))
		if TruncateOverflow == true then
			if ProgLeft <= 0 then
				Bonus = 0
			elseif Bonus > ProgLeft then
				Bonus = ProgLeft + 0.01
			end
		end
		TotalBonus = TotalBonus + Bonus
		ProgLeft = ProgLeft - Bonus

		if Bonus > 0 then
			local temp = { OpponentName = Encounter.OpponentName, Bonus = Bonus }
			table.insert(Notifications, temp)
		end
	end

	local Note = ""
	for _, Notif in ipairs(Notifications) do
		if Note ~= "" then
			Note = Note .. "[NEWLINE]"
		end
		Note = Note .. " [ICON_Bullet]+" .. string.format("%.2f", Notif.Bonus) .. " from {LOC_" .. Notif.OpponentName .. "_NAME}"
	end

	local Turns = 0
	if (CurrentYield + TotalBonus) > 0 then
		Turns = math.ceil(ProgLeft / (CurrentYield + TotalBonus))
		if Turns < 1 then
			Turns = 1
		end
	end

	return TotalBonus, Note, Turns
end

function GetBoosts(ActivePlayerID, ActiveTechID, ActiveCivicID, SendNotifications)
	if ActivePlayerID == -1 then return 0, 0 end

	local ScienceBoost = 0
	local CultureBoost = 0
	local ScienceNote = ""
	local CultureNote = ""

	ScienceBoost, ScienceNote = ProspectInformation(ActivePlayerID, ActiveTechID, "S", true)
	CultureBoost, CultureNote = ProspectInformation(ActivePlayerID, ActiveCivicID, "C", true)

	if SendNotifications == true and ScienceNote ~= "" then
		SendNotification(ActivePlayerID, "Learn From Other Civs", ScienceNote, "S")
	end
	if SendNotifications == true and CultureNote ~= "" then
		SendNotification(ActivePlayerID, "Learn From Other Civs", CultureNote, "C")
	end

	return ScienceBoost, CultureBoost
end

function GetCivicLeft(ActivePlayerID)
	if ActivePlayerID == -1 or Players == nil then return nil end

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerCulture = ActivePlayer:GetCulture()
	local ActivePlayersCivicID = ActivePlayerCulture:GetProgressingCivic()
	local ActivePlayerCulProgLeft = ActivePlayerCulture:GetCultureCost(ActivePlayersCivicID) - ActivePlayerCulture:GetCulturalProgress(ActivePlayersCivicID)
	return ActivePlayerCulProgLeft
end

function GetTechLeft(ActivePlayerID)
	if ActivePlayerID == -1 or Players == nil then return nil end

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerTechs = ActivePlayer:GetTechs()
	local ActivePlayersTechID = ActivePlayerTechs:GetResearchingTech()
	local ActivePlayerSciProgLeft = ActivePlayerTechs:GetResearchCost(ActivePlayersTechID) - ActivePlayerTechs:GetResearchProgress(ActivePlayersTechID)
	return ActivePlayerSciProgLeft
end


function GetEncounterPoints(ActivePlayerID, OpponentID, OpponentCount, SciOrCulture)		-- OpponentCount = 1 for full bonus, 2 for half, 3 for 0.25. etc   //   SciOrCulture = "S" or "C"
-- EncounterPoints: a 0-200 scale assessing how much the opponent is sharing the details of this tech
-- Each point means a +1% boost to our nation's science
-- 0 means we haven't met them
-- 200 means we're getting the max info from them (and our own tech is getting a +200% boost)

	if ActivePlayerID == nil or ActivePlayerID == -1 or Players == nil then return 0, "" end

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerDiplomacy = ActivePlayer:GetDiplomacy()
	local DiplomaticVisibility = ActivePlayerDiplomacy:GetVisibilityOn(OpponentID)

	local EncounterPoints = 40																		-- start at 40 for having met them and knowing the tech exists (e.g. saw gunpowder for the first time)
	local TooltipBreakdown = "[NEWLINE][ICON_Bullet]+40% Met"
	
	EncounterPoints = EncounterPoints + (15 * DiplomaticVisibility)									-- 15 points for each level of visibility (subsumes any seperate need for bonuses re: traders, delegations, embassies, spy listening posts, alliance level 1, printing press, and Catherine de Medici)
	if DiplomaticVisibility == 0 then
		TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+0% No Diplomatic Visibility"
	elseif DiplomaticVisibility == 1 then
		TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+15% Limited Diplomatic Visibility"
	elseif DiplomaticVisibility == 2 then
		TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+30% Open Diplomatic Visibility"
	elseif DiplomaticVisibility == 3 then
		TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+45% Secret Diplomatic Visibility"
	elseif DiplomaticVisibility == 4 then
		TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+60% Top Secret Diplomatic Visibility"
	end
	
	local AllianceType = ActivePlayerDiplomacy:GetAllianceType(OpponentID)
	if AllianceType ~= -1 then
		local AllianceLevel = ActivePlayerDiplomacy:GetAllianceLevel(OpponentID)
		local AlliancePoints = 20 + (10 * AllianceLevel)											-- 30/40/50 for level 1, 2, 3 alliance
		if (SciOrCulture == "S" and GameInfo.Alliances[AllianceType].AllianceType == "ALLIANCE_RESEARCH") or (SciOrCulture == "C" and GameInfo.Alliances[AllianceType].AllianceType == "ALLIANCE_CULTURAL") then
			AlliancePoints = AlliancePoints * 2														-- alliance points worth double (60/80/100) when the alliance type matches
			if SciOrCulture == "S" then
				TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+" .. tostring(AlliancePoints) .. "% Level " .. tostring(AllianceLevel) .. " Research Alliance"
			else
				TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+" .. tostring(AlliancePoints) .. "% Level " .. tostring(AllianceLevel) .. " Cultural Alliance"
			end
		else
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+" .. tostring(AlliancePoints) .. "% Level " .. tostring(AllianceLevel) .. " Alliance"
		end
		EncounterPoints = EncounterPoints + AlliancePoints
	else
		TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+0% No Alliance"
		local DipState = Players[OpponentID]:GetDiplomaticAI():GetDiplomaticStateIndex(ActivePlayerID)
		if GameInfo.DiplomaticStates[DipState].StateType == "DIPLO_STATE_DECLARED_FRIEND" then
			EncounterPoints = EncounterPoints + 10													-- 10 points for declared friendship (if not in an alliance)
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+10% Declared Friendship"
		else
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+0% No Declared Friendship"
		end
		if ActivePlayerDiplomacy:HasOpenBordersFrom(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for open borders in their territory (if not in an alliance)
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+10% Open Borders (in their territory)"
		else
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+0% No Open Borders (in their territory)"
		end
		if ActivePlayerDiplomacy:HasDefensivePact(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for defensive pact (if not in an alliance)
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+10% Defensive Pact"
		else
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+0% No Defensive Pact"
		end
		if ActivePlayerDiplomacy:IsFightingAnyJointWarWith(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for joint war (if not in an alliance)
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+10% Joint War"
		else
			TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]+0% No Joint War"
		end
	end

	if OpponentCount > 1 then
		local RedundantDiff = EncounterPoints
		EncounterPoints = EncounterPoints * (0.5 ^ (OpponentCount - 1))
		RedundantDiff = RedundantDiff - EncounterPoints
		TooltipBreakdown = TooltipBreakdown .. "[NEWLINE][ICON_Bullet]-" .. string.format("%.0f", RedundantDiff) .. "% Redundant Information"
	end

	TooltipBreakdown = "[NEWLINE]+" .. tostring(EncounterPoints) .. "% bonus to our research" .. TooltipBreakdown

	return EncounterPoints, TooltipBreakdown
end

function SendNotification(ActivePlayerID, Header, Body, SciOrCulture)		-- SciOrCulture = "S" or "C"
	if ActivePlayerID == -1 then return end

	local notificationData = {}
	notificationData[ParameterTypes.MESSAGE] = Header
	notificationData[ParameterTypes.SUMMARY] = Body

	if SciOrCulture == "S" then
		NotificationManager.SendNotification(ActivePlayerID, NotificationTypes.USER_DEFINED_8, notificationData)
	elseif SciOrCulture == "C" then
		NotificationManager.SendNotification(ActivePlayerID, NotificationTypes.USER_DEFINED_9, notificationData)
	end
end

function PlaceLeaderIcons(LeaderIconIM, NameStack, ListInstance, TechOrCivicType, TechOrCivicID, SciOrCulture, OffsetX, OffsetY)
	if LeaderIconIM[TechOrCivicType] == nil then
		LeaderIconIM[TechOrCivicType] = InstanceManager:new("YT_LFOC_LeaderIconInstance", "Icon", NameStack)
	end
	LeaderIconIM[TechOrCivicType]:ResetInstances()

	if not GameConfiguration.GetValue("YT_LEARN_FROM_OTHER_CIVS") then return end

	local LocalPlayerID = Game.GetLocalPlayer()
	local AllPlayers = PlayerManager.GetAliveMajors()
	local Encounters = {}
	for _, Player in pairs(AllPlayers) do
		local PlayerID = Player:GetID()
		local IsNotLocalPlayer = PlayerID ~= LocalPlayerID
		local HasMet = Player:GetDiplomacy():HasMet(LocalPlayerID)
		local HasIt = false
		if SciOrCulture == 'S' then
			HasIt = Player:GetTechs():HasTech(TechOrCivicID)
		else
			HasIt = Player:GetCulture():HasCivic(TechOrCivicID)
		end
		
		if IsNotLocalPlayer and HasMet and HasIt then
			local temp = { PlayerID = PlayerID, OpponentName = PlayerConfigurations[PlayerID]:GetCivilizationTypeName() }
			temp.EncounterPoints = GetEncounterPoints(LocalPlayerID, PlayerID, 1, SciOrCulture)
			table.insert(Encounters, temp)
		end
		table.sort(Encounters, function(a,b) if a.EncounterPoints == nil or a.EncounterPoints == b.EncounterPoints then return a.OpponentName < b.OpponentName else return a.EncounterPoints > b.EncounterPoints end end)
	end


	for i, Encounter in ipairs(Encounters) do
		local pPlayerConfig = PlayerConfigurations[Encounter.PlayerID]
		local instance = LeaderIconIM[TechOrCivicType]:GetInstance()
		local iconName = "ICON_" .. pPlayerConfig:GetLeaderTypeName()
		local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName)
		instance.Icon:SetTexture(textureOffsetX, textureOffsetY, textureSheet)
		local ToolTip = ""
		_, ToolTip = GetEncounterPoints(LocalPlayerID, Encounter.PlayerID, i, SciOrCulture)
		ToolTip = "Already learned by " .. Locale.Lookup("LOC_" .. pPlayerConfig:GetCivilizationTypeName() .. "_NAME") .. ToolTip

		instance.Icon:SetToolTipString(ToolTip)
		instance.Icon:SetOffsetVal(OffsetX, OffsetY)
		instance.Icon:SetHide(false)

	end	
	
	local Turns = 0
	_, _, Turns = ProspectInformation(LocalPlayerID, TechOrCivicID, SciOrCulture)

	if ListInstance.TurnsLeft ~= nil then
		if Turns <= 0 then
			ListInstance.TurnsLeft:SetText("")
		else
			ListInstance.TurnsLeft:SetText( "[ICON_Turn]" .. tostring(Turns) )
		end
	end

	if ListInstance.Turns ~= nil then
		if Turns <= 0 then
			ListInstance.Turns:SetText("")
		else
			ListInstance.Turns:SetText(tostring(Turns) .. " TURNS")
		end
	end
end


function Init_UI()
	DB_YT.ProspectInformation = ProspectInformation
	DB_YT.GetBoosts = GetBoosts
	DB_YT.GetCivicLeft = GetCivicLeft
	DB_YT.GetTechLeft = GetTechLeft
	DB_YT.SendNotification = SendNotification
	DB_YT.GetEncounterPoints = GetEncounterPoints
end

Init_UI()