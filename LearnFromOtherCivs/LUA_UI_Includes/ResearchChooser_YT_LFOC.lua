-- if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
-- local DB_YT = ExposedMembers.DB_YT

include('YT_LearnFromOtherCivs_UI')
local YT_LeaderIconIM = {}
local YT_LeaderIconIM2 = {}

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
	
	PlaceLeaderIcons(YT_LeaderIconIM, ListInstance.DB_NameStack, ListInstance, kData.TechType, GameInfo.Technologies[kData.TechType].Index, "S", -5, -30)

	return ListInstance
end


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

	for _, v in pairs(YT_LeaderIconIM2) do
		v:ResetInstances()
	end
	PlaceLeaderIcons(YT_LeaderIconIM2, kControl.TitleStack, kControl, kData.TechType, GameInfo.Technologies[kData.TechType].Index, "S", -5, -15)

	return kControl
end

function ResetLeaderIcons()
	if YT_LeaderIconIM ~= nil then
		for _, v in pairs(YT_LeaderIconIM) do
			v:ResetInstances()
		end
	end
	if YT_LeaderIconIM2 ~= nil then
		for _, v in pairs(YT_LeaderIconIM2) do
			v:ResetInstances()
		end
	end
end

PRIOR_OnChooseResearch = OnChooseResearch
function OnChooseResearch (techHash:number)
	ResetLeaderIcons()
	PRIOR_OnChooseResearch(techHash)
end

function FlushChanges()
	ResetLeaderIcons()
	if ContextPtr:IsVisible() then
		Refresh();	
	end
end