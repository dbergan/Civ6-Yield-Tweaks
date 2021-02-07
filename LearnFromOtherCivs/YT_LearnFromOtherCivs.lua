if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT

-- this function triggers immediately after the player received their normal science/culture yields for the turn
function YT_GiveActivePlayerBoost(ActivePlayerID)
	if (ActivePlayerID == -1 or ActivePlayerID > 61 or DB_YT.GetBoosts == nil) then return nil end

	local ActivePlayer = Players[ActivePlayerID]
	local ActiveTechID = ActivePlayer:GetTechs():GetResearchingTech()
	local ActiveCivicID = ActivePlayer:GetCulture():GetProgressingCivic()	

	local ScienceBoost = 0
	local CultureBoost = 0

	ScienceBoost, CultureBoost = DB_YT.GetBoosts(ActivePlayerID, ActiveTechID, ActiveCivicID, true)

	ActivePlayer:GetTechs():ChangeCurrentResearchProgress(ScienceBoost)
	ActivePlayer:GetCulture():ChangeCurrentCulturalProgress(CultureBoost)
end


function Init()
	Events.PlayerTurnActivated.Add(YT_GiveActivePlayerBoost)
end

Init()