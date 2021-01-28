UPDATE LocalizedText SET Text = Text || CASE WHEN INSTR(Text, '[MOD]') = 0 THEN ' [COLOR_RED][MOD][ENDCOLOR]' ELSE '' END WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGEGROUP_SCIENCE_NAME' AND Language = 'en_US' ;
UPDATE LocalizedText SET Text = Text || CASE WHEN INSTR(Text, '[MOD]') = 0 THEN ' [COLOR_RED][MOD][ENDCOLOR]' ELSE '' END WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGE_SCIENCE_2_CHAPTER_CONTENT_TITLE' AND Language = 'en_US' ;
UPDATE LocalizedText SET Text = Text || CASE WHEN INSTR(Text, '[MOD]') = 0 THEN ' [COLOR_RED][MOD][ENDCOLOR]' ELSE '' END WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGEGROUP_CULTURE_NAME' AND Language = 'en_US' ;
UPDATE LocalizedText SET Text = Text || CASE WHEN INSTR(Text, '[MOD]') = 0 THEN ' [COLOR_RED][MOD][ENDCOLOR]' ELSE '' END WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGE_CULTURE_2_CHAPTER_CONTENT_TITLE' AND Language = 'en_US' ;

-- ('', '', 'en_US'),

INSERT OR IGNORE INTO LocalizedText 
(Tag, Text, Language) VALUES
('LOC_YT_LEARN_FROM_OTHER_CIVS_EXPLANATION', '[COLOR_RED]\/ \/ \/ \/ \/ \/ [from the mod "DB [ICON_Science]Yield Tweaks[ICON_Culture] - Learn From Other Civs game option"] \/ \/ \/ \/ \/ \/[ENDCOLOR][NEWLINE][NEWLINE]Your civilization''s science/culture output gets a bonus when you are researching a tech/civic that you''ve seen in another civilization. Consider: the most helpful knowledge for researching something like, say, nuclear fission or democracy, would be knowing that it exists and seeing it in action somewhere in the world. And seeing it in different nations gives you more ways to learn about it.[NEWLINE][NEWLINE]Here''s how it works... For each civ that has the tech/civic you are researching, you calculate your civilization''s "Encounter Points" with that civilization. The nitty gritty of these points follow below, but the gist is that the friendlier you are with that civilization, the more encounter points you will get. In other words, you would learn about gunpowder faster from a friend than you would from an enemy, and even more from a scientific research ally.[NEWLINE][NEWLINE]So first we add up every other civilization''s Encounter Points, and then we start with the civ that has the highest amount. For every Encounter Point you have with that civilization, you receive a 1% bonus to your nation''s science/culture output. The lowest Encounter Points you could have is 40, and the highest is 200. Thus, from just that one other civilization knowing the thing you''re researching, you will get a minimum of +40% (i.e. if you''ve only just met them, or you''re at war) and as much as +200% (i.e. if you have a Level 3 Research Alliance and Top Secret diplomatic visibility).[NEWLINE][NEWLINE]Next we move to the civ where we have the 2nd highest amount of Encounter Points. From this civ we receive half the bonus that we did from the first civ, because, it is assumed that about half of what you learn about gunpowder from your second best friend is redundant with what you already knew from your best friend. So each Encounter Point you have with #2 is worth a 0.5% bonus. Then we move to the civ with the third highest Encounter Points and those are again worth half as much as #2 (i.e. 0.25%), and so on for every other civilization that we''ve met that has the thing we''re researching. Therefore, the biggest bonuses come from your one or two best friends, and the rest are just table scraps. Your scientists aren''t really learning anything new from North Korea''s implementation of rocketry; although if it was the world''s only successful implementation of rocketry, they''d learn quite a bit.[NEWLINE][NEWLINE][COLOR_Blue]LIST OF ENCOUNTER POINTS[ENDCOLOR][NEWLINE][ICON_Bullet]Met Civilization +40[NEWLINE][ICON_Bullet]Diplomatic Visibility: Limited +15[NEWLINE][ICON_Bullet]Diplomatic Visibility: Open +30[NEWLINE][ICON_Bullet]Diplomatic Visibility: Secret +45[NEWLINE][ICON_Bullet]Diplomatic Visibility: Top Secret +60[NEWLINE][ICON_Bullet]Alliance Level 1 +30 (+60 if Alliance Type matches *)[NEWLINE][ICON_Bullet]Alliance Level 2 +40 (+80 if Alliance Type matches *)[NEWLINE][ICON_Bullet]Alliance Level 3 +50 (+100 if Alliance Type matches *)[NEWLINE][ICON_Bullet]Declared Friend +10 (when not in an alliance)[NEWLINE][ICON_Bullet]Open Borders in their territory +10 (when not in an alliance)[NEWLINE][ICON_Bullet]Defensive Pact +10 (when not in an alliance)[NEWLINE][ICON_Bullet]In a Joint War together +10 (when not in an alliance)[NEWLINE]* If the alliance type is Scientific and you are researching a tech that ally has; or if the alliance type is Cultural and you are researching a civic that ally has' , 'en_US'),
('LOC_PEDIA_CONCEPTS_PAGE_SCIENCE_2_CHAPTER_CONTENT_PARA_2', '{LOC_YT_LEARN_FROM_OTHER_CIVS_EXPLANATION}' , 'en_US'),
('LOC_PEDIA_CONCEPTS_PAGE_CULTURE_2_CHAPTER_CONTENT_PARA_2', '{LOC_YT_LEARN_FROM_OTHER_CIVS_EXPLANATION}' , 'en_US') ;
