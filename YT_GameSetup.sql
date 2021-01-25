INSERT OR REPLACE INTO Parameters (ParameterId, Name, Description, 
Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Visible, ReadOnly,
SupportsSinglePlayer, SupportsLANMultiplayer, SupportsInternetMultiplayer, SupportsHotSeat, SupportsPlayByCloud,
ChangeableAfterGameStart, ChangeableAfterPlayByCloudMatchCreate, SortIndex) VALUES 

('YT_SCIENCE_PER_POP', 'LOC_YT_SCIENCE_PER_POP_NAME', 'LOC_YT_SCIENCE_PER_POP_DESC', 
'YTScienceRate', 30, 'Game', 'YT_SCIENCE_PER_POP', 'AdvancedOptions', 1, 0, 
1, 1, 1, 1, 1, 
0, 0, 320),

('YT_CULTURE_PER_POP', 'LOC_YT_CULTURE_PER_POP_NAME', 'LOC_YT_CULTURE_PER_POP_DESC', 
'YTCultureRate', 30, 'Game', 'YT_CULTURE_PER_POP', 'AdvancedOptions', 1, 0, 
1, 1, 1, 1, 1, 
0, 0, 321),


('YT_REMOVE_TECH_BOOSTS', 'LOC_YT_REMOVE_TECH_BOOSTS_NAME', 'LOC_YT_REMOVE_TECH_BOOSTS_DESC', 
'bool', 1, 'Game', 'YT_REMOVE_TECH_BOOSTS', 'AdvancedOptions', 1, 0, 
1, 1, 1, 1, 1, 
0, 0, 322),

('YT_REMOVE_CIVIC_BOOSTS', 'LOC_YT_REMOVE_CIVIC_BOOSTS_NAME', 'LOC_YT_REMOVE_CIVIC_BOOSTS_DESC', 
'bool', 1, 'Game', 'YT_REMOVE_CIVIC_BOOSTS', 'AdvancedOptions', 1, 0, 
1, 1, 1, 1, 1, 
0, 0, 323),

('YT_LEARN_FROM_OTHER_CIVS', 'LOC_YT_LEARN_FROM_OTHER_CIVS_NAME', 'LOC_YT_LEARN_FROM_OTHER_CIVS_DESC', 
'bool', 1, 'Game', 'YT_LEARN_FROM_OTHER_CIVS', 'AdvancedOptions', 1, 0, 
1, 1, 1, 1, 1, 
0, 0, 324),

('YT_PEOPLE_CREATE', 'LOC_YT_PEOPLE_CREATE_NAME', 'LOC_YT_PEOPLE_CREATE_DESC', 
'bool', 1, 'Game', 'YT_PEOPLE_CREATE', 'AdvancedOptions', 1, 0, 
1, 1, 1, 1, 1, 
0, 0, 325),

('YT_GREAT_PEOPLE_COME_FROM_PEOPLE', 'LOC_YT_GREAT_PEOPLE_COME_FROM_PEOPLE_NAME', 'LOC_YT_GREAT_PEOPLE_COME_FROM_PEOPLE_DESC', 
'bool', 1, 'Game', 'YT_GREAT_PEOPLE_COME_FROM_PEOPLE', 'AdvancedOptions', 1, 0, 
1, 1, 1, 1, 1, 
0, 0, 326)

;

INSERT OR REPLACE INTO DomainValues (Domain, Name, Description, SortIndex, Value) VALUES
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_15_NAME', 'LOC_YT_SCIENCE_PER_POP_15_DESC', 15, 15),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_20_NAME', 'LOC_YT_SCIENCE_PER_POP_20_DESC', 20, 20),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_25_NAME', 'LOC_YT_SCIENCE_PER_POP_25_DESC', 25, 25),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_30_NAME', 'LOC_YT_SCIENCE_PER_POP_30_DESC', 30, 30),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_35_NAME', 'LOC_YT_SCIENCE_PER_POP_35_DESC', 35, 35),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_40_NAME', 'LOC_YT_SCIENCE_PER_POP_40_DESC', 40, 40),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_45_NAME', 'LOC_YT_SCIENCE_PER_POP_45_DESC', 45, 45),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_50_NAME', 'LOC_YT_SCIENCE_PER_POP_50_DESC', 50, 50),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_55_NAME', 'LOC_YT_SCIENCE_PER_POP_55_DESC', 55, 55),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_60_NAME', 'LOC_YT_SCIENCE_PER_POP_60_DESC', 60, 60),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_65_NAME', 'LOC_YT_SCIENCE_PER_POP_65_DESC', 65, 65),
('YTScienceRate', 'LOC_YT_SCIENCE_PER_POP_70_NAME', 'LOC_YT_SCIENCE_PER_POP_70_DESC', 70, 70),

('YTCultureRate', 'LOC_YT_CULTURE_PER_POP_15_NAME', 'LOC_YT_CULTURE_PER_POP_15_DESC', 15, 15),
('YTCultureRate', 'LOC_YT_CULTURE_PER_POP_20_NAME', 'LOC_YT_CULTURE_PER_POP_20_DESC', 20, 20),
('YTCultureRate', 'LOC_YT_CULTURE_PER_POP_25_NAME', 'LOC_YT_CULTURE_PER_POP_25_DESC', 25, 25),
('YTCultureRate', 'LOC_YT_CULTURE_PER_POP_30_NAME', 'LOC_YT_CULTURE_PER_POP_30_DESC', 30, 30)

;