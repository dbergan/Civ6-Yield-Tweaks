if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT

function BoostLaggers(turn)
	local LocalPlayerID = Game.GetLocalPlayer()
	if (LocalPlayerID == PlayerTypes.NONE) then return nil end

	local LocalPlayer = Players[LocalPlayerID]
	local LocalPlayerDiplomacy = LocalPlayer:GetDiplomacy()
	local LocalPlayerTechs = LocalPlayer:GetTechs()
	local LocalPlayerCulture = LocalPlayer:GetCulture()

	local LocalPlayersTechID = LocalPlayerTechs:GetResearchingTech()
	local LocalScience = LocalPlayerTechs:GetScienceYield()
	local LocalPlayersCivicID = LocalPlayerCulture:GetProgressingCivic()
	local LocalCulture = LocalPlayerCulture:GetCultureYield()
	

	local LocalPlayerCulProgLeft = DB_YT.GetCivicLeft()
	local LocalPlayerSciProgLeft = DB_YT.GetTechLeft()
	LocalPlayerCulProgLeft = LocalPlayerCulProgLeft - LocalCulture
	LocalPlayerSciProgLeft = LocalPlayerSciProgLeft - LocalScience

	local TotalScienceBonus = 0
	local TotalCultureBonus = 0

	local TechEncounters = {}
	local CivicEncounters = {}

	for _, Opponent in ipairs(PlayerManager.GetAliveMajors()) do
		local OpponentID = Opponent:GetID()
		if OpponentID ~= LocalPlayerID then
			if LocalPlayerDiplomacy:HasMet(OpponentID) then
				if Opponent:GetTechs():HasTech(LocalPlayersTechID) then
					local temp = { OpponentName = PlayerConfigurations[OpponentID]:GetCivilizationTypeName(), EncounterPoints = DB_YT.GetEncounterPoints(OpponentID, "S") }
					table.insert(TechEncounters, temp)
				end
				
				if Opponent:GetCulture():HasCivic(LocalPlayersCivicID) then
					local temp = { OpponentName = PlayerConfigurations[OpponentID]:GetCivilizationTypeName(), EncounterPoints = DB_YT.GetEncounterPoints(OpponentID, "C") }
					table.insert(CivicEncounters, temp)
				end 
			end
		end
	end

	table.sort(TechEncounters, function(a,b) return a.EncounterPoints > b.EncounterPoints end)
	table.sort(CivicEncounters, function(a,b) return a.EncounterPoints > b.EncounterPoints end)
	local ScienceNotifications = {}
	for i, Encounter in ipairs(TechEncounters) do
		local ScienceBonus = LocalScience * Encounter.EncounterPoints / 100
		ScienceBonus = ScienceBonus * (0.5 ^ (i - 1))
		if LocalPlayerSciProgLeft <= 0 then
			ScienceBonus = 0
		elseif ScienceBonus > LocalPlayerSciProgLeft then
			ScienceBonus = LocalPlayerSciProgLeft
		end
		TotalScienceBonus = TotalScienceBonus + ScienceBonus
		LocalPlayerSciProgLeft = LocalPlayerSciProgLeft - ScienceBonus

		if ScienceBonus > 0 then
			local temp = { OpponentName = Encounter.OpponentName, Bonus = ScienceBonus }
			table.insert(ScienceNotifications, temp)
		end
	end

	local CultureNotifications = {}
	for i, Encounter in ipairs(CivicEncounters) do
		local CultureBonus = LocalCulture * Encounter.EncounterPoints / 100
		CultureBonus = CultureBonus * (0.5 ^ (i - 1))
		if LocalPlayerCulProgLeft <= 0 then
			CultureBonus = 0
		elseif CultureBonus > LocalPlayerCulProgLeft then
			CultureBonus = LocalPlayerCulProgLeft
		end
		TotalCultureBonus = TotalCultureBonus + CultureBonus
		LocalPlayerCulProgLeft = LocalPlayerCulProgLeft - CultureBonus

		if CultureBonus > 0 then
			local temp = { OpponentName = Encounter.OpponentName, Bonus = CultureBonus }
			table.insert(CultureNotifications, temp)
		end
	end

	-- Add bonuses
	LocalPlayerTechs:ChangeCurrentResearchProgress(TotalScienceBonus)
	LocalPlayerCulture:ChangeCurrentCulturalProgress(TotalCultureBonus)

	-- Send notifications
	local Body = ""
	for _, Notif in ipairs(ScienceNotifications) do
		if Body ~= "" then
			Body = Body .. "[NEWLINE]"
		end
		Body = Body .. string.format("%.1f", Notif.Bonus) .. "[ICON_Science] from {LOC_" .. Notif.OpponentName .. "_NAME}"
	end
	if Body ~= "" then
		DB_YT.SendNotification("Learn From Other Civs", Body, "S")
	end

	Body = ""
	for _, Notif in ipairs(CultureNotifications) do
		if Body ~= "" then
			Body = Body .. "[NEWLINE]"
		end
		Body = Body .. string.format("%.1f", Notif.Bonus) .. "[ICON_Culture] from {LOC_" .. Notif.OpponentName .. "_NAME}"
	end
	if Body ~= "" then
		DB_YT.SendNotification("Learn From Other Civs", Body, "C")
	end

end

function Init()
	Events.TurnEnd.Add( BoostLaggers )
end

Init()