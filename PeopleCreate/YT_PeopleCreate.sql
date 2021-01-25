DROP TABLE IF EXISTS BNP_District_Yield ;
DROP TABLE IF EXISTS BNP_Building_Yield ;

CREATE TABLE BNP_District_Yield (DistrictType VARCHAR, YieldType VARCHAR) ;
CREATE TABLE BNP_Building_Yield (BuildingType VARCHAR, DistrictType VARCHAR, YieldType VARCHAR) ;

INSERT INTO BNP_District_Yield (DistrictType, YieldType)
	SELECT DistrictType, YieldType FROM District_CitizenYieldChanges ;

INSERT INTO BNP_Building_Yield (BuildingType, DistrictType, YieldType)
	SELECT Buildings.BuildingType, Buildings.PrereqDistrict, BNP_District_Yield.YieldType FROM Buildings LEFT JOIN BNP_District_Yield ON Buildings.PrereqDistrict = BNP_District_Yield.DistrictType WHERE CitizenSlots IS NOT NULL AND CitizenSlots > 0 ;

DELETE FROM BNP_Building_Yield WHERE YieldType = 'YIELD_PRODUCTION' AND (BuildingType = 'BUILDING_BARRACKS' OR BuildingType = 'BUILDING_STABLE' OR BuildingType = 'BUILDING_MILITARY_ACADEMY' OR BuildingType = 'BUILDING_BASILIKOI_PAIDES' OR BuildingType = 'BUILDING_ORDU') ;
DELETE FROM BNP_Building_Yield WHERE YieldType = 'YIELD_FOOD' AND (BuildingType = 'BUILDING_LIGHTHOUSE' OR BuildingType = 'BUILDING_SEAPORT') ;
DELETE FROM BNP_Building_Yield WHERE YieldType = 'YIELD_GOLD' AND (BuildingType = 'BUILDING_ARMORY' OR BuildingType = 'BUILDING_SHIPYARD') ;
DELETE FROM BNP_District_Yield WHERE YieldType = 'YIELD_GOLD' AND (DistrictType = 'DISTRICT_ENCAMPMENT' OR DistrictType = 'DISTRICT_IKANDA' OR DistrictType = 'DISTRICT_HARBOR' OR DistrictType = 'DISTRICT_COTHON' OR DistrictType = 'DISTRICT_ROYAL_NAVY_DOCKYARD') ;


-- Add a citizen slot to the base districts (e.g. without a library)
UPDATE Districts SET CitizenSlots = 1 WHERE DistrictType IN (SELECT DISTINCT DistrictType FROM BNP_District_Yield) ;


-- Specialists start at one yield because the base districts can hold a spec now (campus spec starts at 1 sci, not 2...)
--  - Gold starts at 2 instead of 1
DELETE FROM District_CitizenYieldChanges WHERE DistrictType IN (SELECT DISTINCT DistrictType FROM District_CitizenYieldChanges) ;
INSERT OR REPLACE INTO District_CitizenYieldChanges (DistrictType, YieldType, YieldChange) 
	SELECT DistrictType, YieldType, CASE WHEN YieldType = 'YIELD_GOLD' THEN 2 ELSE 1 END FROM BNP_District_Yield ;

-- Specialists grow at one yield from each specialist building in the district (library, university, research lab, each make ALL specialists one better)
--  - Gold grows by 2 instead of 1
DELETE FROM Building_CitizenYieldChanges WHERE BuildingType IN (SELECT DISTINCT BuildingType FROM BNP_Building_Yield) ;
INSERT OR REPLACE INTO Building_CitizenYieldChanges (BuildingType, YieldType, YieldChange) 
	SELECT BuildingType, YieldType, CASE WHEN YieldType = 'YIELD_GOLD' THEN 2 ELSE 1 END FROM BNP_Building_Yield ;

-- Buildings lose 1 flat yield of the district's type
--  - Gold loses 2 instead of 1
UPDATE Building_YieldChanges SET YieldChange = YieldChange - CASE WHEN YieldType = 'YIELD_GOLD' THEN 2 ELSE 1 END WHERE EXISTS (SELECT NULL FROM BNP_Building_Yield WHERE Building_YieldChanges.BuildingType = BNP_Building_Yield.BuildingType AND Building_YieldChanges.YieldType = BNP_Building_Yield.YieldType) ;




-- Clean out zeroed/negative rows
DELETE FROM District_CitizenYieldChanges WHERE YieldChange IS NULL OR YieldChange <= 0 ;
DELETE FROM Building_CitizenYieldChanges WHERE YieldChange IS NULL OR YieldChange <= 0 ;
DELETE FROM Building_YieldChanges WHERE YieldChange IS NULL OR YieldChange <= 0 ;


-- Drop temporary tables
DROP TABLE IF EXISTS BNP_District_Yield ;
DROP TABLE IF EXISTS BNP_Building_Yield ;
