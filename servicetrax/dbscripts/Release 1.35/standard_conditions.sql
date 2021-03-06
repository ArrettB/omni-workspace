 
 / *   T o   p r e v e n t   a n y   p o t e n t i a l   d a t a   l o s s   i s s u e s ,   y o u   s h o u l d   r e v i e w   t h i s   s c r i p t   i n   d e t a i l   b e f o r e   r u n n i n g   i t   o u t s i d e   t h e   c o n t e x t   o f   t h e   d a t a b a s e   d e s i g n e r . * /  
 B E G I N   T R A N S A C T I O N  
 S E T   Q U O T E D _ I D E N T I F I E R   O N  
 S E T   A R I T H A B O R T   O N  
 S E T   N U M E R I C _ R O U N D A B O R T   O F F  
 S E T   C O N C A T _ N U L L _ Y I E L D S _ N U L L   O N  
 S E T   A N S I _ N U L L S   O N  
 S E T   A N S I _ P A D D I N G   O N  
 S E T   A N S I _ W A R N I N G S   O N  
 C O M M I T  
 B E G I N   T R A N S A C T I O N  
 G O  
 C R E A T E   T A B L E   d b o . S T A N D A R D _ C O N D I T I O N S  
 	 (  
 	 s t a n d a r d _ c o n d i t i o n _ i d   n u m e r i c ( 1 8 ,   0 )   I D E N T I T Y ( 1 , 1 )   N O T   N U L L ,  
 	 n a m e   v a r c h a r ( 4 0 0 )   N O T   N U L L ,  
 	 a c t i v e _ f l a g   v a r c h a r ( 1 )   N O T   N U L L ,  
 	 s e q u e n c e _ n o   n u m e r i c ( 2 ,   0 )   N O T   N U L L ,  
 	 d a t e _ c r e a t e d   d a t e t i m e   N O T   N U L L ,  
 	 c r e a t e d _ b y   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L ,  
 	 d a t e _ m o d i f i e d   d a t e t i m e   N U L L ,  
 	 m o d i f i e d _ b y   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O N S T R A I N T  
 	 	 P K _ S T A N D A R D _ C O N D I T I O N S   P R I M A R Y   K E Y   C L U S T E R E D    
 	 	 (  
 	 	 s t a n d a r d _ c o n d i t i o n _ i d   A S C  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )  
 	 )     O N   [ P R I M A R Y ]  
 G O  
 D E C L A R E   @ v   s q l _ v a r i a n t    
 S E T   @ v   =   N ' i s   t h e   c o n d i t i o n   a v a i l a b l e   f o r   u s e   o n   n e w   q u o t e s '  
 E X E C U T E   s p _ a d d e x t e n d e d p r o p e r t y   N ' M S _ D e s c r i p t i o n ' ,   @ v ,   N ' S C H E M A ' ,   N ' d b o ' ,   N ' T A B L E ' ,   N ' S T A N D A R D _ C O N D I T I O N S ' ,   N ' C O L U M N ' ,   N ' a c t i v e _ f l a g '  
 G O  
 A L T E R   T A B L E   d b o . S T A N D A R D _ C O N D I T I O N S   A D D   C O N S T R A I N T  
 	 C K _ S T A N D A R D _ C O N D I T I O N S   C H E C K   ( a c t i v e _ f l a g   I N   ( ' Y ' ,   ' N ' ) )  
 G O  
 D E C L A R E   @ v   s q l _ v a r i a n t    
 S E T   @ v   =   N ' B O O L E A N '  
 E X E C U T E   s p _ a d d e x t e n d e d p r o p e r t y   N ' M S _ D e s c r i p t i o n ' ,   @ v ,   N ' S C H E M A ' ,   N ' d b o ' ,   N ' T A B L E ' ,   N ' S T A N D A R D _ C O N D I T I O N S ' ,   N ' C O N S T R A I N T ' ,   N ' C K _ S T A N D A R D _ C O N D I T I O N S '  
 G O  
 A L T E R   T A B L E   d b o . S T A N D A R D _ C O N D I T I O N S   A D D   C O N S T R A I N T  
 	 D F _ S T A N D A R D _ C O N D I T I O N S _ a c t i v e _ f l a g   D E F A U L T   ' Y '   F O R   a c t i v e _ f l a g  
 G O  
  
 A L T E R   T A B L E   [ d b o ] . [ S T A N D A R D _ C O N D I T I O N S ]     W I T H   N O C H E C K   A D D     C O N S T R A I N T   [ F K _ S C _ U S E R S _ C ]   F O R E I G N   K E Y ( [ C R E A T E D _ B Y ] )  
 R E F E R E N C E S   [ d b o ] . [ U S E R S ]   ( [ U S E R _ I D ] )  
 G O  
 A L T E R   T A B L E   [ d b o ] . [ S T A N D A R D _ C O N D I T I O N S ]   C H E C K   C O N S T R A I N T   [ F K _ S C _ U S E R S _ C ]  
 G O  
 A L T E R   T A B L E   [ d b o ] . [ S T A N D A R D _ C O N D I T I O N S ]     W I T H   N O C H E C K   A D D     C O N S T R A I N T   [ F K _ S C _ U S E R S _ M ]   F O R E I G N   K E Y ( [ M O D I F I E D _ B Y ] )  
 R E F E R E N C E S   [ d b o ] . [ U S E R S ]   ( [ U S E R _ I D ] )  
 G O  
 A L T E R   T A B L E   [ d b o ] . [ S T A N D A R D _ C O N D I T I O N S ]   C H E C K   C O N S T R A I N T   [ F K _ S C _ U S E R S _ M ]  
 G O  
 C O M M I T  
 