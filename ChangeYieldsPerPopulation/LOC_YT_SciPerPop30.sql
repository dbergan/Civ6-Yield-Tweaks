UPDATE LocalizedText SET Text = Text || CASE WHEN INSTR(Text, '[MOD]') = 0 THEN ' [COLOR_RED][MOD][ENDCOLOR]' ELSE '' END WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGEGROUP_SCIENCE_NAME' AND Language = 'en_US' ;
UPDATE LocalizedText SET Text = Text || CASE WHEN INSTR(Text, '[MOD]') = 0 THEN ' [COLOR_RED][MOD][ENDCOLOR]' ELSE '' END WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGE_SCIENCE_2_CHAPTER_CONTENT_TITLE' AND Language = 'en_US' ;
UPDATE LocalizedText SET Text = REPLACE(Text, 'Citizens (0.7 per [ICON_Citizen])', 'Citizens ([COLOR_RED]0.30[ENDCOLOR] per [ICON_Citizen]) [COLOR_RED][from the mod "DB [ICON_Science]Yield Tweaks[ICON_Culture]"][ENDCOLOR]') WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGE_SCIENCE_2_CHAPTER_CONTENT_PARA_1' AND Language = 'en_US' ;
UPDATE LocalizedText SET Text = REPLACE(Text, 'Citizens (0.5 per [ICON_Citizen])', 'Citizens ([COLOR_RED]0.30[ENDCOLOR] per [ICON_Citizen]) [COLOR_RED][from the mod "DB [ICON_Science]Yield Tweaks[ICON_Culture]"][ENDCOLOR]') WHERE Tag = 'LOC_PEDIA_CONCEPTS_PAGE_SCIENCE_2_CHAPTER_CONTENT_PARA_1' AND Language = 'en_US' ;
