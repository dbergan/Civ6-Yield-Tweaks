if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT

-- this function triggers immediately after the player received their normal science/culture yields for the turn
function YT_GiveActivePlayerBoost(ActivePlayerID)
	if (ActivePlayerID == PlayerTypes.NONE or ActivePlayerID > 61) then return nil end

	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerDiplomacy = ActivePlayer:GetDiplomacy()
	local ActivePlayerTechs = ActivePlayer:GetTechs()
	local ActivePlayerCulture = ActivePlayer:GetCulture()

	local ActivePlayersTechID = ActivePlayerTechs:GetResearchingTech()
	local ActiveScience = ActivePlayerTechs:GetScienceYield()
	local ActivePlayersCivicID = ActivePlayerCulture:GetProgressingCivic()
	local ActiveCulture = ActivePlayerCulture:GetCultureYield()
	

	local ActivePlayerCulProgLeft = DB_YT.GetCivicLeft(ActivePlayerID)
	local ActivePlayerSciProgLeft = DB_YT.GetTechLeft(ActivePlayerID)

	local TotalScienceBonus = 0
	local TotalCultureBonus = 0

	local TechEncounters = {}
	local CivicEncounters = {}

	for _, Opponent in ipairs(PlayerManager.GetAliveMajors()) do
		local OpponentID = Opponent:GetID()
		if OpponentID ~= ActivePlayerID then
			if ActivePlayerDiplomacy:HasMet(OpponentID) then
				if Opponent:GetTechs():HasTech(ActivePlayersTechID) then
					local temp = { OpponentName = PlayerConfigurations[OpponentID]:GetCivilizationTypeName(), EncounterPoints = DB_YT.GetEncounterPoints(ActivePlayerID, OpponentID, "S") }
					table.insert(TechEncounters, temp)
				end
				
				if Opponent:GetCulture():HasCivic(ActivePlayersCivicID) then
					local temp = { OpponentName = PlayerConfigurations[OpponentID]:GetCivilizationTypeName(), EncounterPoints = DB_YT.GetEncounterPoints(ActivePlayerID, OpponentID, "C") }
					table.insert(CivicEncounters, temp)
				end 
			end
		end
	end

	table.sort(TechEncounters, function(a,b) return a.EncounterPoints > b.EncounterPoints end)
	table.sort(CivicEncounters, function(a,b) return a.EncounterPoints > b.EncounterPoints end)
	local ScienceNotifications = {}
	for i, Encounter in ipairs(TechEncounters) do
		local ScienceBonus = ActiveScience * Encounter.EncounterPoints / 100
		ScienceBonus = ScienceBonus * (0.5 ^ (i - 1))
		if ActivePlayerSciProgLeft <= 0 then
			ScienceBonus = 0
		elseif ScienceBonus > ActivePlayerSciProgLeft then
			ScienceBonus = ActivePlayerSciProgLeft
		end
		TotalScienceBonus = TotalScienceBonus + ScienceBonus
		ActivePlayerSciProgLeft = ActivePlayerSciProgLeft - ScienceBonus

		if ScienceBonus > 0 then
			local temp = { OpponentName = Encounter.OpponentName, Bonus = ScienceBonus }
			table.insert(ScienceNotifications, temp)
		end
	end

	local CultureNotifications = {}
	for i, Encounter in ipairs(CivicEncounters) do
		local CultureBonus = ActiveCulture * Encounter.EncounterPoints / 100
		CultureBonus = CultureBonus * (0.5 ^ (i - 1))
		if ActivePlayerCulProgLeft <= 0 then
			CultureBonus = 0
		elseif CultureBonus > ActivePlayerCulProgLeft then
			CultureBonus = ActivePlayerCulProgLeft
		end
		TotalCultureBonus = TotalCultureBonus + CultureBonus
		ActivePlayerCulProgLeft = ActivePlayerCulProgLeft - CultureBonus

		if CultureBonus > 0 then
			local temp = { OpponentName = Encounter.OpponentName, Bonus = CultureBonus }
			table.insert(CultureNotifications, temp)
		end
	end

	-- Add bonuses
	ActivePlayerTechs:ChangeCurrentResearchProgress(TotalScienceBonus)
	ActivePlayerCulture:ChangeCurrentCulturalProgress(TotalCultureBonus)

	-- Send notifications
	local Body = ""
	for _, Notif in ipairs(ScienceNotifications) do
		if Body ~= "" then
			Body = Body .. "[NEWLINE]"
		end
		Body = Body .. string.format("%.1f", Notif.Bonus) .. "[ICON_Science] from {LOC_" .. Notif.OpponentName .. "_NAME}"
	end
	if Body ~= "" then
		DB_YT.SendNotification(ActivePlayerID, "Learn From Other Civs", Body, "S")
	end

	Body = ""
	for _, Notif in ipairs(CultureNotifications) do
		if Body ~= "" then
			Body = Body .. "[NEWLINE]"
		end
		Body = Body .. string.format("%.1f", Notif.Bonus) .. "[ICON_Culture] from {LOC_" .. Notif.OpponentName .. "_NAME}"
	end
	if Body ~= "" then
		DB_YT.SendNotification(ActivePlayerID, "Learn From Other Civs, Begin", Body, "C")
	end

end


function Init()
	Events.PlayerTurnActivated.Add (YT_GiveActivePlayerBoost)
end

Init()