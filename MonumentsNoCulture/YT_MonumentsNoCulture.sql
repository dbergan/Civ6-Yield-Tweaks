DELETE FROM Building_YieldChanges WHERE BuildingType = 'BUILDING_MONUMENT' ;

DELETE FROM BuildingModifiers WHERE ModifierId = 'MONUMENT_CULTURE_AT_FULL_LOYALTY' ;
DELETE FROM Modifiers WHERE ModifierId = 'MONUMENT_CULTURE_AT_FULL_LOYALTY' ;
DELETE FROM ModifierArguments WHERE ModifierId = 'MONUMENT_CULTURE_AT_FULL_LOYALTY' ;

UPDATE ModifierArguments SET Value = 2 WHERE ModifierId = 'MONUMENT_LOYALTY' AND Name = 'Amount' ;

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MONUMENT', 'YT_MOD_MONUMENT_BORDER_EXPANSION') ;
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('YT_MOD_MONUMENT_BORDER_EXPANSION', 'MODIFIER_SINGLE_CITY_CULTURE_BORDER_EXPANSION') ;
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('YT_MOD_MONUMENT_BORDER_EXPANSION', 'Amount', 100) ;
