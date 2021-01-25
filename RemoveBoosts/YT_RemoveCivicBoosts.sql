UPDATE Boosts SET 
BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',
TriggerDescription = 'LOC_DB_CIVIC_BOOST',
TriggerLongDescription = '',
Unit1Type = NULL,
Unit2Type = NULL,
BuildingType = NULL,
ImprovementType = NULL,
BoostingTechType = NULL,
ResourceType = NULL,
NumItems = 0,
DistrictType = NULL,
RequiresResource = 0,
RequirementSetId = NULL,
GovernmentSlotType = NULL,
BoostingCivicType = NULL,
GovernmentTierType = NULL 
WHERE CivicType IS NOT NULL ;

DELETE FROM Quests WHERE QuestType = 'QUEST_TRIGGER_CIVIC_BOOST' ;