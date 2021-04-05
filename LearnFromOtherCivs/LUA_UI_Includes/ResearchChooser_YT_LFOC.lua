-- G:\SteamLibrary\steamapps\common\Sid Meier's Civilization VI\Base\Assets\UI\Choosers\ResearchChooser.lua

include('YT_LearnFromOtherCivs_UI')
YT_AddAvailableResearch_LeaderIconIM = {}
YT_RealizeCurrentResearch_LeaderIconIM = {}

-- G:\SteamLibrary\steamapps\common\Sid Meier's Civilization VI\Base\Assets\UI\Choosers\ResearchChooser.lua  [line 181]
-- G:\SteamLibrary\steamapps\common\Sid Meier's Civilization VI\DLC\Expansion2\UI\Replacements\ResearchChooser_Expansion1.lua  [line 48]
PRIOR_AddAvailableResearch = AddAvailableResearch
function AddAvailableResearch( playerID:number, kData:table )
	ListInstance = PRIOR_AddAvailableResearch(playerID, kData)

	-- Set alliance flag icon if XP1 or XP2
	if ListInstance ~= nil and ListInstance.Alliance ~= nil and (Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9") or Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68")) then
		ListInstance.Alliance:SetHide(true)
		if kData then
			local techID = GameInfo.Technologies[kData.TechType].Index;
			if AllyHasOrIsResearchingTech(techID) then
				ListInstance.AllianceIcon:SetToolTipString(GetAllianceIconToolTip());
				ListInstance.AllianceIcon:SetColor(GetAllianceIconColor());
				ListInstance.Alliance:SetHide(false);
			else
				ListInstance.Alliance:SetHide(true);
			end
		end
	end
	if kData == nil or kData.TechType == nil or ListInstance == nil or ListInstance.DB_NameStack == nil then return ListInstance end
	
	if YT_AddAvailableResearch_LeaderIconIM[kData.TechType] ~= nil then
		YT_AddAvailableResearch_LeaderIconIM[kData.TechType]:ResetInstances()
		YT_AddAvailableResearch_LeaderIconIM[kData.TechType] = nil
	end
	PlaceLeaderIcons(YT_AddAvailableResearch_LeaderIconIM, ListInstance.DB_NameStack, ListInstance, kData.TechType, GameInfo.Technologies[kData.TechType].Index, "S", -5, -30)

	return ListInstance
end

-- G:\SteamLibrary\steamapps\common\Sid Meier's Civilization VI\Base\Assets\UI\TechAndCivicSupport.lua  [line 585]
-- G:\SteamLibrary\steamapps\common\Sid Meier's Civilization VI\DLC\Expansion2\UI\Replacements\ResearchChooser_Expansion1.lua  [line 29]
PRIOR_RealizeCurrentResearch = RealizeCurrentResearch
function RealizeCurrentResearch( playerID:number, kData:table, kControl:table )
	if kControl == nil then
		kControl = Controls
	end
	-- Hide alliance flag icon if XP1 or XP2
	if kControl.Alliance ~= nil and (Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9") or Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68")) then
		kControl.Alliance:SetHide(true)
	end

	PRIOR_RealizeCurrentResearch(playerID, kData, kControl)

	if kData == nil or kData.TechType == nil then return end

	if YT_RealizeCurrentResearch_LeaderIconIM ~= nil then
		for _, v in pairs(YT_RealizeCurrentResearch_LeaderIconIM) do
			v:ResetInstances()
			v = nil
		end
	end
	PlaceLeaderIcons(YT_RealizeCurrentResearch_LeaderIconIM, kControl.TitleStack, kControl, kData.TechType, GameInfo.Technologies[kData.TechType].Index, "S", -5, -15)

	return kControl
end

function ResetTechLeaderIcons()
	if YT_AddAvailableResearch_LeaderIconIM ~= nil then
		for _, v in pairs(YT_AddAvailableResearch_LeaderIconIM) do
			v:ResetInstances()
			v = nil
		end
		YT_AddAvailableResearch_LeaderIconIM = nil
		YT_AddAvailableResearch_LeaderIconIM = {}
	end
	if YT_RealizeCurrentResearch_LeaderIconIM ~= nil then
		for _, v in pairs(YT_RealizeCurrentResearch_LeaderIconIM) do
			v:ResetInstances()
			v = nil
		end
		YT_RealizeCurrentResearch_LeaderIconIM = nil
		YT_RealizeCurrentResearch_LeaderIconIM = {}
	end
end

PRIOR_OnChooseResearch = OnChooseResearch
function OnChooseResearch (techHash:number)
	ResetTechLeaderIcons()
	PRIOR_OnChooseResearch(techHash)
end

PRIOR_OnOpenPanel = OnOpenPanel
function OnOpenPanel ()
	ResetTechLeaderIcons()
	PRIOR_OnOpenPanel()
end

function FlushChanges()
	ResetTechLeaderIcons()
	if ContextPtr:IsVisible() then
		Refresh();	
	end
end