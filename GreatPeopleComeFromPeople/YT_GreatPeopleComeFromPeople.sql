DROP TABLE IF EXISTS BNP_District_GP ;
DROP TABLE IF EXISTS BNP_Building_GP ;

CREATE TABLE BNP_District_GP (DistrictType VARCHAR, GreatPersonClassType VARCHAR) ;
CREATE TABLE BNP_Building_GP (BuildingType VARCHAR, DistrictType VARCHAR, GreatPersonClassType VARCHAR) ;

INSERT INTO BNP_District_GP (DistrictType, GreatPersonClassType)
	SELECT DistrictType, GreatPersonClassType FROM District_GreatPersonPoints ;
DELETE FROM BNP_District_GP WHERE DistrictType = 'DISTRICT_LAVRA' AND GreatPersonClassType != 'GREAT_PERSON_CLASS_PROPHET' ;

INSERT INTO BNP_Building_GP (BuildingType, DistrictType, GreatPersonClassType)
	SELECT Buildings.BuildingType, Buildings.PrereqDistrict, BNP_District_GP.GreatPersonClassType FROM Buildings LEFT JOIN BNP_District_GP ON Buildings.PrereqDistrict = BNP_District_GP.DistrictType WHERE CitizenSlots IS NOT NULL AND CitizenSlots > 0 ;

-- Add a citizen slot to the base districts (e.g. without a library)
UPDATE Districts SET CitizenSlots = 1 WHERE DistrictType IN (SELECT DISTINCT DistrictType FROM BNP_District_GP) ;


-- Add GPP yields to the specialists according to their district (each spec at campus, +1 Great Scientist point per turn)
DELETE FROM District_CitizenGreatPersonPoints WHERE DistrictType IN (SELECT DISTINCT DistrictType FROM BNP_District_GP) ;
INSERT OR REPLACE INTO District_CitizenGreatPersonPoints (DistrictType, GreatPersonClassType, PointsPerTurn) 
	SELECT DistrictType, GreatPersonClassType, 1 FROM BNP_District_GP ;

-- Districts lose 1 GPP
UPDATE District_GreatPersonPoints SET PointsPerTurn = PointsPerTurn - 1 WHERE EXISTS (SELECT NULL FROM BNP_District_GP WHERE District_GreatPersonPoints.DistrictType = BNP_District_GP.DistrictType AND District_GreatPersonPoints.GreatPersonClassType = BNP_District_GP.GreatPersonClassType) ;

-- Buildings lose 1 GPP
UPDATE Building_GreatPersonPoints SET PointsPerTurn = PointsPerTurn - 1 WHERE EXISTS (SELECT NULL FROM BNP_Building_GP WHERE Building_GreatPersonPoints.BuildingType = BNP_Building_GP.BuildingType AND Building_GreatPersonPoints.GreatPersonClassType = BNP_Building_GP.GreatPersonClassType) ;


-- Clean out zeroed/negative rows
DELETE FROM District_CitizenGreatPersonPoints WHERE PointsPerTurn IS NULL OR PointsPerTurn <= 0 ;
DELETE FROM District_GreatPersonPoints WHERE PointsPerTurn IS NULL OR PointsPerTurn <= 0 ;
DELETE FROM Building_GreatPersonPoints WHERE PointsPerTurn IS NULL OR PointsPerTurn <= 0 ;

-- Drop temporary tables
DROP TABLE IF EXISTS BNP_District_GP ;
DROP TABLE IF EXISTS BNP_Building_GP ;
