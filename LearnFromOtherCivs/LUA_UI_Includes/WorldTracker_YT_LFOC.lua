-- if not ExposedMembers.DB_YT then ExposedMembers.DB_YT = {} end
-- local DB_YT = ExposedMembers.DB_YT

include('YT_LearnFromOtherCivs_UI')
local YT_LeaderIconIM = {}
local YT_LeaderIconIM2 = {}

PRIOR_RealizeCurrentResearch = RealizeCurrentResearch
function RealizeCurrentResearch(playerID, kData, kControl)
	if kControl == nil then
		kControl = Controls
	end

	PRIOR_RealizeCurrentResearch(playerID, kData, kControl)

	if kData == nil or kData.TechType == nil then return end

	for _, v in pairs(YT_LeaderIconIM) do
		v:ResetInstances()
	end
	PlaceLeaderIcons(YT_LeaderIconIM, kControl.DB_TitleStack, kControl, kData.TechType, GameInfo.Technologies[kData.TechType].Index, "S", -5, -15)

	return kControl
end

PRIOR_RealizeCurrentCivic = RealizeCurrentCivic
function RealizeCurrentCivic(playerID, kData, kControl, cachedModifiers)
	if kControl == nil then
		kControl = Controls
	end

	PRIOR_RealizeCurrentCivic(playerID, kData, kControl, cachedModifiers)

	if kData == nil or kData.CivicType == nil then return end

	for _, v in pairs(YT_LeaderIconIM2) do
		v:ResetInstances()
	end
	PlaceLeaderIcons(YT_LeaderIconIM2, kControl.DB_TitleStack, kControl, kData.CivicType, GameInfo.Civics[kData.CivicType].Index, "C", -5, -15)
end