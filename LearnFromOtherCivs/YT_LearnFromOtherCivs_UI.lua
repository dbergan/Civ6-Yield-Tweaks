if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT


function ProspectInformation(ActivePlayerID, ResearchItemID, SciOrCulture)		-- SciOrCulture = "S" or "C"
	if ActivePlayerID == -1 or Players == nil then return 0, "", 0 end

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
					local temp = { OpponentName = PlayerConfigurations[OpponentID]:GetCivilizationTypeName(), EncounterPoints = GetEncounterPoints(ActivePlayerID, OpponentID, SciOrCulture) }
					table.insert(Encounters, temp)
				end
			end
		end
	end
	table.sort(Encounters, function(a,b) if a.EncounterPoints == b.EncounterPoints then return a.OpponentName > b.OpponentName else return a.EncounterPoints > b.EncounterPoints end end)

	local Bonus = 0
	local TotalBonus = 0
	local Notifications = {}
	for i, Encounter in ipairs(Encounters) do
		local Bonus = CurrentYield * Encounter.EncounterPoints / 100
		Bonus = Bonus * (0.5 ^ (i - 1))
		if ProgLeft <= 0 then
			Bonus = 0
		elseif Bonus > ProgLeft then
			Bonus = ProgLeft
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
		Note = Note .. "[ICON_Bullet]+" .. string.format("%.2f", Notif.Bonus) .. " from {LOC_" .. Notif.OpponentName .. "_NAME}"
	end

	local Turns = 0
	if (CurrentYield + TotalBonus) > 0 then
		Turns = 1 + math.ceil(ProgLeft / (CurrentYield + TotalBonus))
	end

	return TotalBonus, Note, Turns
end

function GetBoosts(ActivePlayerID, ActiveTechID, ActiveCivicID, SendNotifications)
	if ActivePlayerID == -1 then return 0, 0 end

	local ScienceBoost = 0
	local CultureBoost = 0
	local ScienceNote = ""
	local CultureNote = ""

	ScienceBoost, ScienceNote = ProspectInformation(ActivePlayerID, ActiveTechID, "S")
	CultureBoost, CultureNote = ProspectInformation(ActivePlayerID, ActiveCivicID, "C")

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


function GetEncounterPoints(ActivePlayerID, OpponentID, SciOrCulture)		-- SciOrCulture = "S" or "C"
-- EncounterPoints: a 0-200 scale assessing how much the opponent is sharing the details of this tech
-- Each point means a +1% boost to our nation's science
-- 0 means we haven't met them
-- 200 means we're getting the max info from them (and our own tech is getting a +200% boost)

	if ActivePlayerID == -1 or Players == nil then return 0, "" end

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
		if ActivePlayerDiplomacy:GetDeclaredFriendshipTurn(OpponentID) > 0 then
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


function Init_UI()
	DB_YT.ProspectInformation = ProspectInformation
	DB_YT.GetBoosts = GetBoosts
	DB_YT.GetCivicLeft = GetCivicLeft
	DB_YT.GetTechLeft = GetTechLeft
	DB_YT.SendNotification = SendNotification
	DB_YT.GetEncounterPoints = GetEncounterPoints
end

Init_UI()