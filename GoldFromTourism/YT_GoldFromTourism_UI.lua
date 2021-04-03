if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
local DB_YT = ExposedMembers.DB_YT


function YT_GetGoldFromForeignTourists(ActivePlayerID)
	local ActivePlayer = Players[ActivePlayerID]
	local ActivePlayerCulture = ActivePlayer:GetCulture()
	local OtherPlayerIDs = PlayerManager.GetAliveMajorIDs()
	local PerTurnSum = 0
	for _, LoopPlayerID in ipairs(OtherPlayerIDs) do
		if ActivePlayerID ~= LoopPlayerID and ActivePlayer:GetDiplomacy():HasMet(LoopPlayerID) == true then
			local Temp = ActivePlayerCulture:GetTouristsFromTooltip(LoopPlayerID)
			local z = 0
			local PerTurn = 0
			local Lifetime = 0
			for y in string.gmatch(Temp, '(%d+)') do
				if z == 0 then
					PerTurn = y
				else
					Lifetime = y
				end
				z = z + 1
			end
			PerTurnSum = PerTurnSum + PerTurn
		end
	end
	local OtherPlayers = PlayerManager.GetAliveMajorsCount() - 1
	return PerTurnSum / OtherPlayers
end

function YT_GoldFromTourism_Init_UI()
	DB_YT.YT_GetGoldFromForeignTourists = YT_GetGoldFromForeignTourists
end

YT_GoldFromTourism_Init_UI()