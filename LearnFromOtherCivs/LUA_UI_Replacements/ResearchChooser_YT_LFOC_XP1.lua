include('ResearchChooser_Expansion1')

-- G:\SteamLibrary\steamapps\common\Sid Meier's Civilization VI\DLC\Expansion2\UI\Replacements\ResearchChooser_Expansion1.lua  [line 48]
function AddAvailableResearch( playerID:number, kData:table )
	local kControl = BASE_AddAvailableResearch(playerID, kData);

	if kData then
		local techID = GameInfo.Technologies[kData.TechType].Index;
		if AllyHasOrIsResearchingTech(techID) then
			kControl.AllianceIcon:SetToolTipString(GetAllianceIconToolTip());
			kControl.AllianceIcon:SetColor(GetAllianceIconColor());
			kControl.Alliance:SetHide(false);
		else
			kControl.Alliance:SetHide(true);
		end
	end
-- DB - need to return the control so we can add leader icons
	return kControl
-- /DB
end

include('ResearchChooser_YT_LFOC')