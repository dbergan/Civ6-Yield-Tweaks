if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end;
local DB_YT = ExposedMembers.DB_YT;

function GetCivicLeft()
	local LocalPlayerID = Game.GetLocalPlayer()
	if (LocalPlayerID == PlayerTypes.NONE) then return nil end

	local LocalPlayer = Players[LocalPlayerID]
	local LocalPlayerCulture = LocalPlayer:GetCulture()
	local LocalPlayersCivicID = LocalPlayerCulture:GetProgressingCivic()
	local LocalPlayerCulProgLeft = LocalPlayerCulture:GetCultureCost(LocalPlayersCivicID) - LocalPlayerCulture:GetCulturalProgress(LocalPlayersCivicID)
	return LocalPlayerCulProgLeft
end

function GetTechLeft()
	local LocalPlayerID = Game.GetLocalPlayer()
	if (LocalPlayerID == PlayerTypes.NONE) then return nil end

	local LocalPlayer = Players[LocalPlayerID]
	local LocalPlayerTechs = LocalPlayer:GetTechs()
	local LocalPlayersTechID = LocalPlayerTechs:GetResearchingTech()
	local LocalPlayerSciProgLeft = LocalPlayerTechs:GetResearchCost(LocalPlayersTechID) - LocalPlayerTechs:GetResearchProgress(LocalPlayersTechID)
	return LocalPlayerSciProgLeft
end


function GetEncounterPoints(OpponentID, SciOrCulture)		-- SciOrCulture = "S" or "C"
-- EncounterPoints: a 0-100 scale assessing how much the opponent is sharing the details of this tech
-- 0 means we haven't met them
-- 100 means they are doing everything possible to share with us
-- Just knowing that a tech exists (seen them use gunpowder, for example) is worth the most


	local LocalPlayerID = Game.GetLocalPlayer()
	if (LocalPlayerID == PlayerTypes.NONE) then return nil end
	local LocalPlayer = Players[LocalPlayerID]
	local LocalPlayerDiplomacy = LocalPlayer:GetDiplomacy()

	local EncounterPoints = 40																		-- start at 40 for having met them and knowing the tech exists (e.g. saw gunpowder for the first time)
	
	EncounterPoints = EncounterPoints + (15 * LocalPlayerDiplomacy:GetVisibilityOn(OpponentID))		-- 15 points for each level of visibility (subsumes any seperate need for bonuses re: traders, delegations, embassies, spy listening posts, alliance level 1, printing press, and Catherine de Medici)
	
	local AllianceType = LocalPlayerDiplomacy:GetAllianceType(OpponentID)
	if AllianceType ~= -1 then
		local AllianceLevel = LocalPlayerDiplomacy:GetAllianceLevel(OpponentID)
		local AlliancePoints = 20 + (10 * AllianceLevel)											-- 30/40/50 for level 1, 2, 3 alliance
		if (SciOrCulture == "S" and GameInfo.Alliances[AllianceType].AllianceType == "ALLIANCE_RESEARCH") or (SciOrCulture == "C" and GameInfo.Alliances[AllianceType].AllianceType == "ALLIANCE_CULTURAL") then
			AlliancePoints = AlliancePoints * 2														-- alliance points worth double (60/80/100) if the alliance type matches
		end
		EncounterPoints = EncounterPoints + AlliancePoints
	else
		if LocalPlayerDiplomacy:GetDeclaredFriendshipTurn(OpponentID) > 0 then
			EncounterPoints = EncounterPoints + 10													-- 10 points for declared friendship (if not in an alliance)
		end
		if LocalPlayerDiplomacy:HasOpenBordersFrom(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for open borders in their territory (if not in an alliance)
		end
		if LocalPlayerDiplomacy:HasDefensivePact(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for defensive pact (if not in an alliance)
		end
		if LocalPlayerDiplomacy:IsFightingAnyJointWarWith(OpponentID) then
			EncounterPoints = EncounterPoints + 10													-- 10 points for joint war (if not in an alliance)
		end
	end

	return EncounterPoints
end

function SendNotification(Header, Body, SciOrCulture)		-- SciOrCulture = "S" or "C"
	local notificationData = {}
	notificationData[ParameterTypes.MESSAGE] = Header
	notificationData[ParameterTypes.SUMMARY] = Body

	if SciOrCulture == "S" then
		NotificationManager.SendNotification(Game.GetLocalPlayer(), NotificationTypes.USER_DEFINED_1, notificationData)
	elseif SciOrCulture == "C" then
		NotificationManager.SendNotification(Game.GetLocalPlayer(), NotificationTypes.USER_DEFINED_2, notificationData)
	end
end


function Init_UI()
	DB_YT.GetCivicLeft = GetCivicLeft
	DB_YT.GetTechLeft = GetTechLeft
	DB_YT.SendNotification = SendNotification
	DB_YT.GetEncounterPoints = GetEncounterPoints
end

Init_UI()