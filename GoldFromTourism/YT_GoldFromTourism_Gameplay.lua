if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT

-- this function triggers immediately after the player received their normal science/culture yields for the turn
function YT_GoldFromTourism(ActivePlayerID, blsFirstTime)
	if (blsFirstTime ~= true or ActivePlayerID == -1 or ActivePlayerID > 61 or DB_YT.YT_GetGoldFromForeignTourists == nil) then return nil end

	local GoldFromForeignTourists = 0
	ForeignTourists = DB_YT.YT_GetGoldFromForeignTourists(ActivePlayerID)

	if GoldFromForeignTourists > 0 then
		Players[ActivePlayerID]:GetTreasury():ChangeGoldBalance(GoldFromForeignTourists)
	end
end

function YT_GoldFromTourism_Init()
	Events.PlayerTurnActivated.Add(YT_GoldFromTourism)
end

YT_GoldFromTourism_Init()