INSERT OR REPLACE INTO LocalizedText 
(Tag, Text, Language) VALUES

('LOC_YT_MOD_NOTE', '[NEWLINE][NEWLINE][COLOR_Red]from mod "DB [ICON_Science]Yield Tweaks[ICON_Culture]"[ENDCOLOR]', 'en_US'),
('LOC_YT_MOD_CULTURE_FROM_CHARMING_APPEAL_DESC', '+{1_num} [ICON_Culture] Culture from charming appeal [COLOR_RED][MOD][ENDCOLOR]', 'en_US'),
('LOC_YT_MOD_CULTURE_FROM_BREATHTAKING_APPEAL_DESC', '+{1_num} [ICON_Culture] Culture from breathtaking appeal [COLOR_RED][MOD][ENDCOLOR]', 'en_US')
 ;

UPDATE LocalizedText SET Text = Text || '[NEWLINE][NEWLINE]Provides an extra +1/+2 [ICON_Culture] Culture when placed on a tile with Charming/Breathtaking Appeal. [COLOR_RED][MOD][ENDCOLOR]' WHERE Tag = 'LOC_DISTRICT_THEATER_DESCRIPTION' AND Language = 'en_US' ;
