function BoostLaggers(turn)
	-- These are the crucial variables
	-- x4.00 means that if 4 out of 4 opponents have this tech (and are doing everything they can to help us), our science gets +400%
	-- If we just meet all the other civs (and none are helping us), our science gets +200%
	local ScienceMultiplier = 4.00 ;
	local CultureMultiplier = 4.00 ;




	local LocalPlayerID = Game.GetLocalPlayer() ;
	if (LocalPlayerID == PlayerTypes.NONE) then
		return nil;
	end
	local LocalPlayer = Players[LocalPlayerID];
	local LocalPlayerDiplomacy = LocalPlayer:GetDiplomacy();
	local LocalPlayerTechs = LocalPlayer:GetTechs();
	local LocalPlayerCulture = LocalPlayer:GetCulture();


	local LocalPlayersTechID = LocalPlayerTechs:GetResearchingTech() ;
	local LocalScience = LocalPlayerTechs:GetScienceYield();

	local LocalPlayersCivicID = LocalPlayerCulture:GetProgressingCivic() ;
	local LocalCulture = LocalPlayerCulture:GetCultureYield();

	local MaxEncounterPoints = PlayerManager.GetAliveMajorsCount() - 1 ;
	MaxEncounterPoints = MaxEncounterPoints * 100 ;
	local TechEncounterPoints = 0 ;
	local CivicEncounterPoints = 0 ;

	local tMajors = PlayerManager.GetAliveMajors();

	for i, Opponent in ipairs(tMajors) do
		local OpponentID = Opponent:GetID() ;
		if OpponentID ~= LocalPlayerID then
			if LocalPlayerDiplomacy:HasMet(OpponentID) then
				if Opponent:GetTechs():HasTech(LocalPlayersTechID) then
					TechEncounterPoints = TechEncounterPoints + GetEncounterPoints(LocalPlayerDiplomacy, OpponentID) ;
				end

				if Opponent:GetCulture():HasCivic(LocalPlayersCivicID) then
					CivicEncounterPoints = CivicEncounterPoints + GetEncounterPoints(LocalPlayerDiplomacy, OpponentID) ;
				end 
			end
		end
	end

	local LocalScienceBonusMultiplier = ((TechEncounterPoints / MaxEncounterPoints)) * ScienceMultiplier ;
	local LocalCultureBonusMultiplier = ((CivicEncounterPoints / MaxEncounterPoints)) * CultureMultiplier ;
	local LocalScienceBonusYield = LocalScienceBonusMultiplier * LocalScience ;
	local LocalCultureBonusYield = LocalCultureBonusMultiplier * LocalCulture ;

	local LocalPlayerSciProgLeft = LocalPlayerTechs:GetResearchCost(LocalPlayersTechID) - LocalPlayerTechs:GetResearchProgress(LocalPlayersTechID) ;

	if (LocalScience + LocalScienceBonusYield) > LocalPlayerSciProgLeft then
		if LocalScience > LocalPlayerSciProgLeft then
			LocalScienceBonusYield = 0 ;
		else
			LocalScienceBonusYield = LocalPlayerSciProgLeft - LocalScience ;
		end
	end
	LocalPlayerTechs:ChangeCurrentResearchProgress(LocalScienceBonusYield);


	-- GetCulturalProgress() doesn't work here (it's a UI function only), so we have to clip in an inexact fashion... (WHY FIRAXIS, WHY!?)
	-- local LocalPlayerCultProgLeft = LocalPlayerCulture:GetCultureCost(LocalPlayersCivicID) - LocalPlayerCulture:GetCulturalProgress(LocalPlayersCivicID) ;
	local CivicTurnsLeft = LocalPlayerCulture:GetTurnsLeftOnCurrentCivic() ; -- LocalPlayersCivicID) ;

	-- if there's <= 1 turn left, we don't apply any bonus because the normal yield will complete it and overflow
	if CivicTurnsLeft > 1 then
		local ProgressLeftMin = ((CivicTurnsLeft - 1) * LocalCulture) + 0.01 ;
		local ProgressLeftMax = CivicTurnsLeft * LocalCulture ;
		-- If we don't complete the civic even with all our bonus, then we'll receive the whole bonus
		-- Here's where we have to decide how much bonus to receive if we're going to complete the civic with the bonus... we don't want excessive overflow
		-- For now, I'm just going to clip to ProgressLeftMax, which will often create overflow, but not a lot
		if (LocalCulture + LocalCultureBonusYield) > ProgressLeftMax then
			LocalCultureBonusYield = ProgressLeftMax - LocalCulture ;
		end
		LocalPlayerCulture:ChangeCurrentCulturalProgress(LocalCultureBonusYield);
	end
end




-- EncounterPoints: a 0-100 scale assessing how much the opponent is sharing the details of this tech
-- 0 means we haven't met them
-- 100 means they are doing everything possible to share with us
-- Just knowing that a tech exists (seen them use gunpowder, for example) is worth the most
-- ...
-- I planned to have a lot of other nuances in here (declared friend, open borders, defensive pact, joint war, alliance level) but apparently we don't have access to that knowledge on the gameplay script side (WHY FIRAXIS, WHY!?)
-- Thus, it's just "have we met them?" and diplomatic visibility
function GetEncounterPoints(LocalPlayerDiplomacy, OpponentID)
	local EncounterPoints = 50 ; -- start at 50 for having met them and knowing the tech exists (e.g. saw gunpowder for the first time)
	EncounterPoints = EncounterPoints + (12.5 * LocalPlayerDiplomacy:GetVisibilityOn(OpponentID)) ; -- 12.5 points for each level of visibility (subsumes any seperate need for bonuses re: traders, delegations, embassies, spy listening posts, alliance level 1, printing press, and Catherine de Medici)
	return EncounterPoints ;
end



function Init()
	Events.TurnEnd.Add( BoostLaggers );
end

Init();