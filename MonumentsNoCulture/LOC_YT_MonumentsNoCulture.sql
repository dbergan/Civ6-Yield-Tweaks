INSERT OR REPLACE INTO LocalizedText 
(Tag, Text, Language) VALUES

('LOC_YT_MOD_NOTE', '[NEWLINE][NEWLINE][COLOR_Red]from mod "DB [ICON_Science]Yield Tweaks[ICON_Culture]"[ENDCOLOR]', 'en_US') ;

UPDATE LocalizedText SET Text = REPLACE(Text, 'Provides +1 Loyalty per turn in this city. If the city already has maximum Loyalty, also provides an additional +1 [ICON_Culture] Culture.', 'Provides +2 Loyalty per turn in this city and 100% faster border growth. [COLOR_RED][MOD][ENDCOLOR]') WHERE Tag = 'LOC_BUILDING_MONUMENT_EXPANSION1_DESCRIPTION' AND Language = 'en_US' ;
