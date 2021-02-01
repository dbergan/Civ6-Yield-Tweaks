if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end;
local DB_YT = ExposedMembers.DB_YT;

function GetCivicLeft(ActivePlayerID)
	if (ActivePlayerID == PlayerTypes.NONE) then return nil end

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerCulture = ActivePlayer:GetCulture()
	local ActivePlayersCivicID = ActivePlayerCulture:GetProgressingCivic()
	local ActivePlayerCulProgLeft = ActivePlayerCulture:GetCultureCost(ActivePlayersCivicID) - ActivePlayerCulture:GetCulturalProgress(ActivePlayersCivicID)
	return ActivePlayerCulProgLeft
end

function GetTechLeft(ActivePlayerID)
	if (ActivePlayerID == PlayerTypes.NONE) then return nil end

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerTechs = ActivePlayer:GetTechs()
	local ActivePlayersTechID = ActivePlayerTechs:GetResearchingTech()
	local ActivePlayerSciProgLeft = ActivePlayerTechs:GetResearchCost(ActivePlayersTechID) - ActivePlayerTechs:GetResearchProgress(ActivePlayersTechID)
	return ActivePlayerSciProgLeft
end


function GetEncounterPoints(ActivePlayerID, OpponentID, SciOrCulture)		-- SciOrCulture = "S" or "C"
-- EncounterPoints: a 0-100 scale assessing how much the opponent is sharing the details of this tech
-- 0 means we haven't met them
-- 100 means they are doing everything possible to share with us
-- Just knowing that a tech exists (seen them use gunpowder, for example) is worth the most


	if (ActivePlayerID == PlayerTypes.NONE) then return nil end

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerDiplomacy = ActivePlayer:GetDiplomacy()

	local EncounterPoints = 40																		-- start at 40 for having met them and knowing the tech exists (e.g. saw gunpowder for the first time)
	
	EncounterPoints = EncounterPoints + (15 * ActivePlayerDiplomacy:GetVisibilityOn(OpponentID))		-- 15 points for each level of visibility (subsumes any seperate need for bonuses re: traders, delegations, embassies, spy listening posts, alliance level 1, printing press, and Catherine de Medici)
	
	local AllianceType = ActivePlayerDiplomacy:GetAllianceType(OpponentID)
	if AllianceType ~= -1 then
		local AllianceLevel = ActivePlayerDiplomacy:GetAllianceLevel(OpponentID)
		local AlliancePoints = 20 + (10 * AllianceLevel)											-- 30/40/50 for level 1, 2, 3 alliance
		if (SciOrCulture == "S" and GameInfo.Alliances[AllianceType].AllianceType == "ALLIANCE_RESEARCH") or (SciOrCulture == "C" and GameInfo.Alliances[AllianceType].AllianceType == "ALLIANCE_CULTURAL") then
			AlliancePoints = AlliancePoints * 2														-- alliance points worth double (60/80/100) if the alliance type matches
		end
		EncounterPoints = EncounterPoints + AlliancePoints
	else
		if ActivePlayerDiplomacy:GetDeclaredFriendshipTurn(OpponentID) > 0 then
			EncounterPoints = EncounterPoints + 10													-- 10 points for declared friendship (if not in an alliance)
		end
		if ActivePlayerDiplomacy:HasOpenBordersFrom(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for open borders in their territory (if not in an alliance)
		end
		if ActivePlayerDiplomacy:HasDefensivePact(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for defensive pact (if not in an alliance)
		end
		if ActivePlayerDiplomacy:IsFightingAnyJointWarWith(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for joint war (if not in an alliance)
		end
	end

	return EncounterPoints
end

function SendNotification(ActivePlayerID, Header, Body, SciOrCulture)		-- SciOrCulture = "S" or "C"
	local notificationData = {}
	notificationData[ParameterTypes.MESSAGE] = Header
	notificationData[ParameterTypes.SUMMARY] = Body

	if SciOrCulture == "S" then
		NotificationManager.SendNotification(ActivePlayerID, NotificationTypes.USER_DEFINED_1, notificationData)
	elseif SciOrCulture == "C" then
		NotificationManager.SendNotification(ActivePlayerID, NotificationTypes.USER_DEFINED_2, notificationData)
	end
end


function Init_UI()
	DB_YT.GetCivicLeft = GetCivicLeft
	DB_YT.GetTechLeft = GetTechLeft
	DB_YT.SendNotification = SendNotification
	DB_YT.GetEncounterPoints = GetEncounterPoints
end

Init_UI()