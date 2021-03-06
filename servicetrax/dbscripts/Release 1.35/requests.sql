/ *  
       T h u r s d a y ,   M a r c h   1 2 ,   2 0 0 9 9 : 4 8 : 3 2   A M  
       U s e r :   i m s  
       S e r v e r :   L E X U S \ L E X U S 3 2 D E V  
       D a t a b a s e :   i m s _ n e w  
       A p p l i c a t i o n :    
 * /  
  
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
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ U S E R S _ C  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ U S E R S _ M  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . U S E R S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . U S E R S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . U S E R S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ J O B _ L O C A T I O N S  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . J O B _ L O C A T I O N S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . J O B _ L O C A T I O N S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . J O B _ L O C A T I O N S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ P R O J E C T S  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . P R O J E C T S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . P R O J E C T S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . P R O J E C T S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C A R P E T _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ c u s t o m e r _ c o n t a c t 2  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ c u s t o m e r _ c o n t a c t 3  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ c u s t o m e r _ c o n t a c t 4  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ j o b _ l o c _ c o n t a c t  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T S _ A _ M _ S A L E S _ C O N T A C T _ I D  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ B L D G _ M G R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S E C U R I T Y _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ M O V E R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ O T H E R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D _ S A L E S _ R E P _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D _ S A L E S _ S U P _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D _ P R O J _ M G R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D _ D E S I G N E R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A _ M _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A _ M _ I N S T A L L E R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ f u r n 1 _ c o n t a c t  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ f u r n 2 _ c o n t a c t  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ a p p r o v e r _ c o n t a c t  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C U S T O M E R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A L T _ C U S T _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A _ D _ D E S I G N E R _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ G E N _ C O N T R A C T _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ E L E C T R I C I A N _ C O N T A C T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D A T A _ P H O N E _ C O N T A C T S  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C O N T A C T S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C O N T A C T S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C O N T A C T S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A P P R O V A L _ R E Q _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ R E G U L A R _ H O U R S _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ E V E N I N G _ H O U R S _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ W E E K E N D _ H O U R S _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ W A R E H O U S E _ F E E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D U R _ T I M E _ U O M _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ P H A S E D _ I N S T A L L _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ o t h e r _ d e l i v e r y _ t y p e  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ c u s t o m e r _ c o s t i n g _ t y p e  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ s y s _ f u r n _ l i n e _ t y p e  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ o t h e r _ f u r n _ t y p e  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ o r d e r _ t y p e  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O O R D _ W A L L _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 4  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ O C C U P I E D _ S I T E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ N E W _ S I T E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ W A L K B O A R D _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D U M P S T E R _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S T A G I N G _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O S T _ T O _ C U S T _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O S T _ T O _ J O B _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O S T _ T O _ V E N D O R _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ U N I O N _ L A B O R _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S T A T U S E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C C O U N T _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ Q U O T E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ P R I _ F U R N _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ P R I _ F U R N _ L I N E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S E C _ F U R N _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S E C _ F U R N _ L I N E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C A S E _ F U R N _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ f l o o r _ n u m b e r _ t y p e s  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ p r i o r i t y _ t y p e s  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   f k _ r e q u e s t _ l e v e l _ t y p e s  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C A S E _ F U R N _ L I N E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ W O O D _ P R O D U C T _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D E L I V E R Y _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T S _ P R O D _ D I S T  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ F U R N _ P L A N _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ F U R N _ S P E C _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S T A T I O N _ T Y P I C A L _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ P U N C H L I S T _ I T E M _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ W A L L _ M O U N T _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S I T E _ V I S I T _ R E Q _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ S C H E D U L E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O O R D _ P H O N E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O O R D _ F L O O R _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O O R D _ E L E C T R I C A L _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ C O O R D _ M O V E R _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E 1  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 2  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 3  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 4  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 5  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 6  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 7  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 8  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 9  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 1 0  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 1  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 2  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 3  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 5  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 6  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 7  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 8  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 9  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 1 0  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . L O O K U P S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . L O O K U P S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . L O O K U P S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   D F _ _ r e q u e s t s _ _ I S _ C O P _ _ 3 8 1 E 4 0 7 B  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   D F _ _ r e q u e s t s _ _ I S _ S U R _ _ 3 9 1 2 6 4 B 4  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   D F _ _ r e q u e s t s _ _ P R O D _ D _ _ 4 F 0 4 0 7 D 8  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   D F _ _ r e q u e s t s _ _ C S C _ W O _ _ 7 C 0 1 9 6 D 8  
 G O  
 C R E A T E   T A B L E   d b o . T m p _ R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L   I D E N T I T Y   ( 1 ,   1 ) ,  
 	 P R O J E C T _ I D   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L ,  
 	 R E Q U E S T _ N O   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L ,  
 	 V E R S I O N _ N O   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L ,  
 	 R E Q U E S T _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L ,  
 	 R E Q U E S T _ S T A T U S _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L ,  
 	 I S _ S E N T   v a r c h a r ( 1 )   N O T   N U L L ,  
 	 I S _ S E N T _ D A T E   d a t e t i m e   N U L L ,  
 	 I S _ Q U O T E D   v a r c h a r ( 1 )   N U L L ,  
 	 Q U O T E _ R E Q U E S T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D E A L E R _ C U S T _ I D   v a r c h a r ( 5 0 )   N U L L ,  
 	 C U S T O M E R _ P O _ N O   v a r c h a r ( 5 0 )   N U L L ,  
 	 D E A L E R _ P O _ N O   v a r c h a r ( 5 0 )   N U L L ,  
 	 D E A L E R _ P O _ L I N E _ N O   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D E A L E R _ P R O J E C T _ N O   v a r c h a r ( 5 0 )   N U L L ,  
 	 D E S I G N _ P R O J E C T _ N O   v a r c h a r ( 5 0 )   N U L L ,  
 	 P R O J E C T _ V O L U M E   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C C O U N T _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q U O T E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q U O T E _ N E E D E D _ B Y   d a t e t i m e   N U L L ,  
 	 J O B _ L O C A T I O N _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C U S T O M E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A L T _ C U S T O M E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D _ S A L E S _ R E P _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D _ S A L E S _ S U P _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D _ P R O J _ M G R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D _ D E S I G N E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A _ M _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A _ M _ I N S T A L L _ S U P _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A _ D _ D E S I G N E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 G E N _ C O N T R A C T O R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 E L E C T R I C I A N _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D A T A _ P H O N E _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C A R P E T _ L A Y E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 B L D G _ M G R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S E C U R I T Y _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 M O V E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 O T H E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P R I _ F U R N _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P R I _ F U R N _ L I N E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S E C _ F U R N _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S E C _ F U R N _ L I N E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C A S E _ F U R N _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C A S E _ F U R N _ L I N E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W O O D _ P R O D U C T _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W A R E H O U S E _ L O C   v a r c h a r ( 6 0 )   N U L L ,  
 	 F U R N _ P L A N _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P L A N _ L O C A T I O N   v a r c h a r ( 3 0 )   N U L L ,  
 	 F U R N _ S P E C _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W O R K S T A T I O N _ T Y P I C A L _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P O W E R _ T Y P E   v a r c h a r ( 3 0 )   N U L L ,  
 	 P U N C H L I S T _ I T E M _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P U N C H L I S T _ L I N E   v a r c h a r ( 5 0 )   N U L L ,  
 	 W A L L _ M O U N T _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 I N I T _ P R O J _ T E A M _ M T G _ D A T E   d a t e t i m e   N U L L ,  
 	 D E S I G N _ P R E S E N T A T I O N _ D A T E   d a t e t i m e   N U L L ,  
 	 D E S I G N _ C O M P L E T I O N _ D A T E   d a t e t i m e   N U L L ,  
 	 S P E C _ C H E C K _ C M P L _ D A T E   d a t e t i m e   N U L L ,  
 	 D E A L E R _ O R D E R _ P L A C E D _ D A T E   d a t e t i m e   N U L L ,  
 	 I N T _ P R E _ I N S T A L L _ M T G _ D A T E   d a t e t i m e   N U L L ,  
 	 E X T _ P R E _ I N S T A L L _ M T G _ D A T E   d a t e t i m e   N U L L ,  
 	 D E A L E R _ I N S T A L L _ P L A N _ D A T E   d a t e t i m e   N U L L ,  
 	 M F G _ S H I P _ D A T E   d a t e t i m e   N U L L ,  
 	 P R O D _ D E L _ T O _ W H _ D A T E   d a t e t i m e   N U L L ,  
 	 T R U C K _ A R R I V A L _ T I M E   d a t e t i m e   N U L L ,  
 	 C O N S T R U C T _ C O M P L E T E _ D A T E   d a t e t i m e   N U L L ,  
 	 E L E C T R I C A L _ C O M P L E T E _ D A T E   d a t e t i m e   N U L L ,  
 	 C A B L E _ C O M P L E T E _ D A T E   d a t e t i m e   N U L L ,  
 	 C A R P E T _ C O M P L E T E _ D A T E   d a t e t i m e   N U L L ,  
 	 S I T E _ V I S I T _ R E Q _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S I T E _ V I S I T _ D A T E   d a t e t i m e   N U L L ,  
 	 P R O D U C T _ D E L _ T O _ S I T E _ D A T E   d a t e t i m e   N U L L ,  
 	 S C H E D U L E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 E S T _ S T A R T _ D A T E   d a t e t i m e   N U L L ,  
 	 E S T _ S T A R T _ T I M E   d a t e t i m e   N U L L ,  
 	 E S T _ E N D _ D A T E   d a t e t i m e   N U L L ,  
 	 D A Y S _ T O _ C O M P L E T E   n u m e r i c ( 5 ,   0 )   N U L L ,  
 	 M O V E _ I N _ D A T E   d a t e t i m e   N U L L ,  
 	 P U N C H L I S T _ C O M P L E T E _ D A T E   d a t e t i m e   N U L L ,  
 	 C O O R D _ P H O N E _ D A T A _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O O R D _ W A L L _ C O V R _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O O R D _ F L O O R _ C O V R _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O O R D _ E L E C T R I C A L _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O O R D _ M O V E R _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 1   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 1   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 1   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 2   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 2   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 2   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 3   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 3   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 3   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 4   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 4   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 4   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 5   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 5   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 5   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 6   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 6   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 6   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 7   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 7   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 7   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 8   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 8   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 8   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 9   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 9   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 9   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ T Y P E _ I D 1 0   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 Q T Y 1 0   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 1 0   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D E S C R I P T I O N   v a r c h a r ( 1 0 0 0 )   N U L L ,  
 	 A P P R O V A L _ R E Q _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W H O _ C A N _ A P P R O V E _ N A M E   v a r c h a r ( 6 0 )   N U L L ,  
 	 W H O _ C A N _ A P P R O V E _ P H O N E   v a r c h a r ( 5 0 )   N U L L ,  
 	 R E G U L A R _ H O U R S _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 E V E N I N G _ H O U R S _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W E E K E N D _ H O U R S _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 U N I O N _ L A B O R _ R E Q _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O S T _ T O _ C U S T _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O S T _ T O _ V E N D _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C O S T _ T O _ J O B _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W A R E H O U S E _ F E E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 T A X A B L E _ F L A G   v a r c h a r ( 1 )   N U L L ,  
 	 D U R A T I O N _ T I M E _ U O M _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D U R A T I O N _ Q T Y   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P H A S E D _ I N S T A L L _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 L O A D I N G _ D O C K _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D O C K _ A V A I L A B L E _ T I M E   v a r c h a r ( 3 0 )   N U L L ,  
 	 D O C K _ R E S E R V _ R E Q _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S E M I _ A C C E S S _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D O C K _ H E I G H T   v a r c h a r ( 2 0 )   N U L L ,  
 	 E L E V A T O R _ A V A I L _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 E L E V A T O R _ A V A I L _ T I M E   v a r c h a r ( 3 0 )   N U L L ,  
 	 E L E V A T O R _ R E S E R V _ R E Q _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S T A I R _ C A R R Y _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S T A I R _ C A R R Y _ F L I G H T S   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S T A I R _ C A R R Y _ S T A I R S   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S M A L L E S T _ D O O R _ E L E V _ W I D T H   v a r c h a r ( 2 0 )   N U L L ,  
 	 F L O O R _ P R O T E C T I O N _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W A L L _ P R O T E C T I O N _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D O O R W A Y _ P R O T _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W A L K B O A R D _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S T A G I N G _ A R E A _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D U M P S T E R _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 N E W _ S I T E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 O C C U P I E D _ S I T E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 O T H E R _ C O N D I T I O N S   v a r c h a r ( 1 0 0 0 )   N U L L ,  
 	 P _ C A R D _ N U M B E R   v a r c h a r ( 2 0 )   N U L L ,  
 	 F U R N I T U R E 1 _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 F U R N I T U R E 2 _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A P P R O V E R _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P H O N E _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 F L O O R _ N U M B E R _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P R I O R I T Y _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 L E V E L _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 F U R N _ R E Q _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C U S T _ C O N T A C T _ M O D _ D A T E   d a t e t i m e   N U L L ,  
 	 J O B _ L O C A T I O N _ M O D _ D A T E   d a t e t i m e   N U L L ,  
 	 C U S T _ C O L _ 1   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 2   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 3   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 4   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 5   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 6   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 7   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 8   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 9   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 C U S T _ C O L _ 1 0   v a r c h a r ( 2 0 0 )   N U L L ,  
 	 I S _ C O P Y   v a r c h a r ( 1 )   N U L L ,  
 	 I S _ S U R V E Y E D   v a r c h a r ( 1 )   N U L L ,  
 	 F U R N I T U R E _ T Y P E   v a r c h a r ( 1 0 0 )   N U L L ,  
 	 F U R N I T U R E _ Q T Y   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 P R O D _ D I S P _ F L A G   v a r c h a r ( 1 )   N U L L ,  
 	 P R O D _ D I S P _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 A _ M _ S A L E S _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 W O R K _ O R D E R _ R E C E I V E D _ D A T E   d a t e t i m e   N U L L ,  
 	 C S C _ W O _ F I E L D _ F L A G   v a r c h a r ( 1 )   N O T   N U L L ,  
 	 C U S T O M E R _ C O S T I N G _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C U S T O M E R _ C O N T A C T 2 _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C U S T O M E R _ C O N T A C T 3 _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 C U S T O M E R _ C O N T A C T 4 _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 J O B _ L O C A T I O N _ C O N T A C T _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 S Y S T E M _ F U R N I T U R E _ L I N E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 D E L I V E R Y _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 O T H E R _ F U R N I T U R E _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 O T H E R _ D E L I V E R Y _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 O T H E R _ F U R N I T U R E _ D E S C   v a r c h a r ( 1 5 0 )   N U L L ,  
 	 S C H E D U L E _ W I T H _ C L I E N T _ F L A G   v a r c h a r ( 1 )   N U L L ,  
 	 O R D E R _ T Y P E _ I D   n u m e r i c ( 1 8 ,   0 )   N U L L ,  
 	 I S _ S T A I R _ C A R R Y _ R E Q U I R E D   v a r c h a r ( 1 )   N U L L ,  
 	 D A T E _ C R E A T E D   d a t e t i m e   N O T   N U L L ,  
 	 C R E A T E D _ B Y   n u m e r i c ( 1 8 ,   0 )   N O T   N U L L ,  
 	 D A T E _ M O D I F I E D   d a t e t i m e   N U L L ,  
 	 M O D I F I E D _ B Y   n u m e r i c ( 1 8 ,   0 )   N U L L  
 	 )     O N   [ P R I M A R Y ]  
 G O  
 A L T E R   T A B L E   d b o . T m p _ R E Q U E S T S   A D D   C O N S T R A I N T  
 	 D F _ _ r e q u e s t s _ _ I S _ C O P _ _ 3 8 1 E 4 0 7 B   D E F A U L T   ( ' N ' )   F O R   I S _ C O P Y  
 G O  
 A L T E R   T A B L E   d b o . T m p _ R E Q U E S T S   A D D   C O N S T R A I N T  
 	 D F _ _ r e q u e s t s _ _ I S _ S U R _ _ 3 9 1 2 6 4 B 4   D E F A U L T   ( ' N ' )   F O R   I S _ S U R V E Y E D  
 G O  
 A L T E R   T A B L E   d b o . T m p _ R E Q U E S T S   A D D   C O N S T R A I N T  
 	 D F _ _ r e q u e s t s _ _ P R O D _ D _ _ 4 F 0 4 0 7 D 8   D E F A U L T   ( ' N ' )   F O R   P R O D _ D I S P _ F L A G  
 G O  
 A L T E R   T A B L E   d b o . T m p _ R E Q U E S T S   A D D   C O N S T R A I N T  
 	 D F _ _ r e q u e s t s _ _ C S C _ W O _ _ 7 C 0 1 9 6 D 8   D E F A U L T   ( ' N ' )   F O R   C S C _ W O _ F I E L D _ F L A G  
 G O  
 S E T   I D E N T I T Y _ I N S E R T   d b o . T m p _ R E Q U E S T S   O N  
 G O  
 I F   E X I S T S ( S E L E C T   *   F R O M   d b o . R E Q U E S T S )  
 	   E X E C ( ' I N S E R T   I N T O   d b o . T m p _ R E Q U E S T S   ( R E Q U E S T _ I D ,   P R O J E C T _ I D ,   R E Q U E S T _ N O ,   R E Q U E S T _ T Y P E _ I D ,   R E Q U E S T _ S T A T U S _ T Y P E _ I D ,   I S _ S E N T ,   I S _ Q U O T E D ,   Q U O T E _ R E Q U E S T _ I D ,   D E A L E R _ C U S T _ I D ,   C U S T O M E R _ P O _ N O ,   D E A L E R _ P O _ N O ,   D E A L E R _ P O _ L I N E _ N O ,   D E A L E R _ P R O J E C T _ N O ,   D E S I G N _ P R O J E C T _ N O ,   P R O J E C T _ V O L U M E ,   A C C O U N T _ T Y P E _ I D ,   Q U O T E _ T Y P E _ I D ,   Q U O T E _ N E E D E D _ B Y ,   J O B _ L O C A T I O N _ I D ,   C U S T O M E R _ C O N T A C T _ I D ,   A L T _ C U S T O M E R _ C O N T A C T _ I D ,   D _ S A L E S _ R E P _ C O N T A C T _ I D ,   D _ S A L E S _ S U P _ C O N T A C T _ I D ,   D _ P R O J _ M G R _ C O N T A C T _ I D ,   D _ D E S I G N E R _ C O N T A C T _ I D ,   A _ M _ C O N T A C T _ I D ,   A _ M _ I N S T A L L _ S U P _ C O N T A C T _ I D ,   A _ D _ D E S I G N E R _ C O N T A C T _ I D ,   G E N _ C O N T R A C T O R _ C O N T A C T _ I D ,   E L E C T R I C I A N _ C O N T A C T _ I D ,   D A T A _ P H O N E _ C O N T A C T _ I D ,   C A R P E T _ L A Y E R _ C O N T A C T _ I D ,   B L D G _ M G R _ C O N T A C T _ I D ,   S E C U R I T Y _ C O N T A C T _ I D ,   M O V E R _ C O N T A C T _ I D ,   O T H E R _ C O N T A C T _ I D ,   P R I _ F U R N _ T Y P E _ I D ,   P R I _ F U R N _ L I N E _ T Y P E _ I D ,   S E C _ F U R N _ T Y P E _ I D ,   S E C _ F U R N _ L I N E _ T Y P E _ I D ,   C A S E _ F U R N _ T Y P E _ I D ,   C A S E _ F U R N _ L I N E _ T Y P E _ I D ,   W O O D _ P R O D U C T _ T Y P E _ I D ,   D E L I V E R Y _ T Y P E _ I D ,   W A R E H O U S E _ L O C ,   F U R N _ P L A N _ T Y P E _ I D ,   P L A N _ L O C A T I O N ,   F U R N _ S P E C _ T Y P E _ I D ,   W O R K S T A T I O N _ T Y P I C A L _ T Y P E _ I D ,   P O W E R _ T Y P E ,   P U N C H L I S T _ I T E M _ T Y P E _ I D ,   P U N C H L I S T _ L I N E ,   W A L L _ M O U N T _ T Y P E _ I D ,   I N I T _ P R O J _ T E A M _ M T G _ D A T E ,   D E S I G N _ P R E S E N T A T I O N _ D A T E ,   D E S I G N _ C O M P L E T I O N _ D A T E ,   S P E C _ C H E C K _ C M P L _ D A T E ,   D E A L E R _ O R D E R _ P L A C E D _ D A T E ,   I N T _ P R E _ I N S T A L L _ M T G _ D A T E ,   E X T _ P R E _ I N S T A L L _ M T G _ D A T E ,   D E A L E R _ I N S T A L L _ P L A N _ D A T E ,   M F G _ S H I P _ D A T E ,   P R O D _ D E L _ T O _ W H _ D A T E ,   T R U C K _ A R R I V A L _ T I M E ,   C O N S T R U C T _ C O M P L E T E _ D A T E ,   E L E C T R I C A L _ C O M P L E T E _ D A T E ,   C A B L E _ C O M P L E T E _ D A T E ,   C A R P E T _ C O M P L E T E _ D A T E ,   S I T E _ V I S I T _ R E Q _ T Y P E _ I D ,   S I T E _ V I S I T _ D A T E ,   P R O D U C T _ D E L _ T O _ S I T E _ D A T E ,   S C H E D U L E _ T Y P E _ I D ,   E S T _ S T A R T _ D A T E ,   E S T _ S T A R T _ T I M E ,   E S T _ E N D _ D A T E ,   D A Y S _ T O _ C O M P L E T E ,   M O V E _ I N _ D A T E ,   P U N C H L I S T _ C O M P L E T E _ D A T E ,   C O O R D _ P H O N E _ D A T A _ T Y P E _ I D ,   C O O R D _ W A L L _ C O V R _ T Y P E _ I D ,   C O O R D _ F L O O R _ C O V R _ T Y P E _ I D ,   C O O R D _ E L E C T R I C A L _ T Y P E _ I D ,   C O O R D _ M O V E R _ T Y P E _ I D ,   A C T I V I T Y _ T Y P E _ I D 1 ,   Q T Y 1 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 1 ,   A C T I V I T Y _ T Y P E _ I D 2 ,   Q T Y 2 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 2 ,   A C T I V I T Y _ T Y P E _ I D 3 ,   Q T Y 3 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 3 ,   A C T I V I T Y _ T Y P E _ I D 4 ,   Q T Y 4 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 4 ,   A C T I V I T Y _ T Y P E _ I D 5 ,   Q T Y 5 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 5 ,   A C T I V I T Y _ T Y P E _ I D 6 ,   Q T Y 6 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 6 ,   A C T I V I T Y _ T Y P E _ I D 7 ,   Q T Y 7 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 7 ,   A C T I V I T Y _ T Y P E _ I D 8 ,   Q T Y 8 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 8 ,   A C T I V I T Y _ T Y P E _ I D 9 ,   Q T Y 9 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 9 ,   A C T I V I T Y _ T Y P E _ I D 1 0 ,   Q T Y 1 0 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 1 0 ,   D E S C R I P T I O N ,   A P P R O V A L _ R E Q _ T Y P E _ I D ,   W H O _ C A N _ A P P R O V E _ N A M E ,   W H O _ C A N _ A P P R O V E _ P H O N E ,   R E G U L A R _ H O U R S _ T Y P E _ I D ,   E V E N I N G _ H O U R S _ T Y P E _ I D ,   W E E K E N D _ H O U R S _ T Y P E _ I D ,   U N I O N _ L A B O R _ R E Q _ T Y P E _ I D ,   C O S T _ T O _ C U S T _ T Y P E _ I D ,   C O S T _ T O _ V E N D _ T Y P E _ I D ,   C O S T _ T O _ J O B _ T Y P E _ I D ,   W A R E H O U S E _ F E E _ T Y P E _ I D ,   T A X A B L E _ F L A G ,   D U R A T I O N _ T I M E _ U O M _ T Y P E _ I D ,   D U R A T I O N _ Q T Y ,   P H A S E D _ I N S T A L L _ T Y P E _ I D ,   L O A D I N G _ D O C K _ T Y P E _ I D ,   D O C K _ A V A I L A B L E _ T I M E ,   D O C K _ R E S E R V _ R E Q _ T Y P E _ I D ,   S E M I _ A C C E S S _ T Y P E _ I D ,   D O C K _ H E I G H T ,   E L E V A T O R _ A V A I L _ T Y P E _ I D ,   E L E V A T O R _ A V A I L _ T I M E ,   E L E V A T O R _ R E S E R V _ R E Q _ T Y P E _ I D ,   S T A I R _ C A R R Y _ T Y P E _ I D ,   S T A I R _ C A R R Y _ F L I G H T S ,   S T A I R _ C A R R Y _ S T A I R S ,   S M A L L E S T _ D O O R _ E L E V _ W I D T H ,   F L O O R _ P R O T E C T I O N _ T Y P E _ I D ,   W A L L _ P R O T E C T I O N _ T Y P E _ I D ,   D O O R W A Y _ P R O T _ T Y P E _ I D ,   W A L K B O A R D _ T Y P E _ I D ,   S T A G I N G _ A R E A _ T Y P E _ I D ,   D U M P S T E R _ T Y P E _ I D ,   N E W _ S I T E _ T Y P E _ I D ,   O C C U P I E D _ S I T E _ T Y P E _ I D ,   O T H E R _ C O N D I T I O N S ,   D A T E _ C R E A T E D ,   C R E A T E D _ B Y ,   D A T E _ M O D I F I E D ,   M O D I F I E D _ B Y ,   V E R S I O N _ N O ,   P _ C A R D _ N U M B E R ,   F U R N I T U R E 1 _ C O N T A C T _ I D ,   F U R N I T U R E 2 _ C O N T A C T _ I D ,   A P P R O V E R _ C O N T A C T _ I D ,   P H O N E _ C O N T A C T _ I D ,   F L O O R _ N U M B E R _ T Y P E _ I D ,   P R I O R I T Y _ T Y P E _ I D ,   L E V E L _ T Y P E _ I D ,   F U R N _ R E Q _ T Y P E _ I D ,   C U S T _ C O N T A C T _ M O D _ D A T E ,   J O B _ L O C A T I O N _ M O D _ D A T E ,   C U S T _ C O L _ 1 ,   C U S T _ C O L _ 2 ,   C U S T _ C O L _ 3 ,   C U S T _ C O L _ 4 ,   C U S T _ C O L _ 5 ,   C U S T _ C O L _ 6 ,   C U S T _ C O L _ 7 ,   C U S T _ C O L _ 8 ,   C U S T _ C O L _ 9 ,   C U S T _ C O L _ 1 0 ,   I S _ C O P Y ,   I S _ S U R V E Y E D ,   F U R N I T U R E _ T Y P E ,   F U R N I T U R E _ Q T Y ,   P R O D _ D I S P _ F L A G ,   P R O D _ D I S P _ I D ,   A _ M _ S A L E S _ C O N T A C T _ I D ,   W O R K _ O R D E R _ R E C E I V E D _ D A T E ,   C S C _ W O _ F I E L D _ F L A G ,   I S _ S E N T _ D A T E ,   c u s t o m e r _ c o s t i n g _ t y p e _ i d ,   c u s t o m e r _ c o n t a c t 2 _ i d ,   c u s t o m e r _ c o n t a c t 3 _ i d ,   c u s t o m e r _ c o n t a c t 4 _ i d ,   j o b _ l o c a t i o n _ c o n t a c t _ i d ,   s y s t e m _ f u r n i t u r e _ l i n e _ t y p e _ i d ,   o t h e r _ f u r n i t u r e _ t y p e _ i d ,   o t h e r _ d e l i v e r y _ t y p e _ i d ,   s c h e d u l e _ w i t h _ c l i e n t _ f l a g ,   o r d e r _ t y p e _ i d ,   i s _ s t a i r _ c a r r y _ r e q u i r e d )  
 	 	 S E L E C T   R E Q U E S T _ I D ,   P R O J E C T _ I D ,   R E Q U E S T _ N O ,   R E Q U E S T _ T Y P E _ I D ,   R E Q U E S T _ S T A T U S _ T Y P E _ I D ,   I S _ S E N T ,   I S _ Q U O T E D ,   Q U O T E _ R E Q U E S T _ I D ,   D E A L E R _ C U S T _ I D ,   C U S T O M E R _ P O _ N O ,   D E A L E R _ P O _ N O ,   D E A L E R _ P O _ L I N E _ N O ,   D E A L E R _ P R O J E C T _ N O ,   D E S I G N _ P R O J E C T _ N O ,   P R O J E C T _ V O L U M E ,   A C C O U N T _ T Y P E _ I D ,   Q U O T E _ T Y P E _ I D ,   Q U O T E _ N E E D E D _ B Y ,   J O B _ L O C A T I O N _ I D ,   C U S T O M E R _ C O N T A C T _ I D ,   A L T _ C U S T O M E R _ C O N T A C T _ I D ,   D _ S A L E S _ R E P _ C O N T A C T _ I D ,   D _ S A L E S _ S U P _ C O N T A C T _ I D ,   D _ P R O J _ M G R _ C O N T A C T _ I D ,   D _ D E S I G N E R _ C O N T A C T _ I D ,   A _ M _ C O N T A C T _ I D ,   A _ M _ I N S T A L L _ S U P _ C O N T A C T _ I D ,   A _ D _ D E S I G N E R _ C O N T A C T _ I D ,   G E N _ C O N T R A C T O R _ C O N T A C T _ I D ,   E L E C T R I C I A N _ C O N T A C T _ I D ,   D A T A _ P H O N E _ C O N T A C T _ I D ,   C A R P E T _ L A Y E R _ C O N T A C T _ I D ,   B L D G _ M G R _ C O N T A C T _ I D ,   S E C U R I T Y _ C O N T A C T _ I D ,   M O V E R _ C O N T A C T _ I D ,   O T H E R _ C O N T A C T _ I D ,   P R I _ F U R N _ T Y P E _ I D ,   P R I _ F U R N _ L I N E _ T Y P E _ I D ,   S E C _ F U R N _ T Y P E _ I D ,   S E C _ F U R N _ L I N E _ T Y P E _ I D ,   C A S E _ F U R N _ T Y P E _ I D ,   C A S E _ F U R N _ L I N E _ T Y P E _ I D ,   W O O D _ P R O D U C T _ T Y P E _ I D ,   D E L I V E R Y _ T Y P E _ I D ,   W A R E H O U S E _ L O C ,   F U R N _ P L A N _ T Y P E _ I D ,   P L A N _ L O C A T I O N ,   F U R N _ S P E C _ T Y P E _ I D ,   W O R K S T A T I O N _ T Y P I C A L _ T Y P E _ I D ,   P O W E R _ T Y P E ,   P U N C H L I S T _ I T E M _ T Y P E _ I D ,   P U N C H L I S T _ L I N E ,   W A L L _ M O U N T _ T Y P E _ I D ,   I N I T _ P R O J _ T E A M _ M T G _ D A T E ,   D E S I G N _ P R E S E N T A T I O N _ D A T E ,   D E S I G N _ C O M P L E T I O N _ D A T E ,   S P E C _ C H E C K _ C M P L _ D A T E ,   D E A L E R _ O R D E R _ P L A C E D _ D A T E ,   I N T _ P R E _ I N S T A L L _ M T G _ D A T E ,   E X T _ P R E _ I N S T A L L _ M T G _ D A T E ,   D E A L E R _ I N S T A L L _ P L A N _ D A T E ,   M F G _ S H I P _ D A T E ,   P R O D _ D E L _ T O _ W H _ D A T E ,   T R U C K _ A R R I V A L _ T I M E ,   C O N S T R U C T _ C O M P L E T E _ D A T E ,   E L E C T R I C A L _ C O M P L E T E _ D A T E ,   C A B L E _ C O M P L E T E _ D A T E ,   C A R P E T _ C O M P L E T E _ D A T E ,   S I T E _ V I S I T _ R E Q _ T Y P E _ I D ,   S I T E _ V I S I T _ D A T E ,   P R O D U C T _ D E L _ T O _ S I T E _ D A T E ,   S C H E D U L E _ T Y P E _ I D ,   E S T _ S T A R T _ D A T E ,   E S T _ S T A R T _ T I M E ,   E S T _ E N D _ D A T E ,   d a y s _ t o _ c o m p l e t e ,   M O V E _ I N _ D A T E ,   P U N C H L I S T _ C O M P L E T E _ D A T E ,   C O O R D _ P H O N E _ D A T A _ T Y P E _ I D ,   C O O R D _ W A L L _ C O V R _ T Y P E _ I D ,   C O O R D _ F L O O R _ C O V R _ T Y P E _ I D ,   C O O R D _ E L E C T R I C A L _ T Y P E _ I D ,   C O O R D _ M O V E R _ T Y P E _ I D ,   A C T I V I T Y _ T Y P E _ I D 1 ,   Q T Y 1 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 1 ,   A C T I V I T Y _ T Y P E _ I D 2 ,   Q T Y 2 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 2 ,   A C T I V I T Y _ T Y P E _ I D 3 ,   Q T Y 3 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 3 ,   A C T I V I T Y _ T Y P E _ I D 4 ,   Q T Y 4 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 4 ,   A C T I V I T Y _ T Y P E _ I D 5 ,   Q T Y 5 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 5 ,   A C T I V I T Y _ T Y P E _ I D 6 ,   Q T Y 6 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 6 ,   A C T I V I T Y _ T Y P E _ I D 7 ,   Q T Y 7 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 7 ,   A C T I V I T Y _ T Y P E _ I D 8 ,   Q T Y 8 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 8 ,   A C T I V I T Y _ T Y P E _ I D 9 ,   Q T Y 9 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 9 ,   A C T I V I T Y _ T Y P E _ I D 1 0 ,   Q T Y 1 0 ,   A C T I V I T Y _ C A T _ T Y P E _ I D 1 0 ,   D E S C R I P T I O N ,   A P P R O V A L _ R E Q _ T Y P E _ I D ,   W H O _ C A N _ A P P R O V E _ N A M E ,   W H O _ C A N _ A P P R O V E _ P H O N E ,   R E G U L A R _ H O U R S _ T Y P E _ I D ,   E V E N I N G _ H O U R S _ T Y P E _ I D ,   W E E K E N D _ H O U R S _ T Y P E _ I D ,   U N I O N _ L A B O R _ R E Q _ T Y P E _ I D ,   C O S T _ T O _ C U S T _ T Y P E _ I D ,   C O S T _ T O _ V E N D _ T Y P E _ I D ,   C O S T _ T O _ J O B _ T Y P E _ I D ,   W A R E H O U S E _ F E E _ T Y P E _ I D ,   T A X A B L E _ F L A G ,   D U R A T I O N _ T I M E _ U O M _ T Y P E _ I D ,   D U R A T I O N _ Q T Y ,   P H A S E D _ I N S T A L L _ T Y P E _ I D ,   L O A D I N G _ D O C K _ T Y P E _ I D ,   D O C K _ A V A I L A B L E _ T I M E ,   D O C K _ R E S E R V _ R E Q _ T Y P E _ I D ,   S E M I _ A C C E S S _ T Y P E _ I D ,   D O C K _ H E I G H T ,   E L E V A T O R _ A V A I L _ T Y P E _ I D ,   E L E V A T O R _ A V A I L _ T I M E ,   E L E V A T O R _ R E S E R V _ R E Q _ T Y P E _ I D ,   S T A I R _ C A R R Y _ T Y P E _ I D ,   S T A I R _ C A R R Y _ F L I G H T S ,   S T A I R _ C A R R Y _ S T A I R S ,   S M A L L E S T _ D O O R _ E L E V _ W I D T H ,   F L O O R _ P R O T E C T I O N _ T Y P E _ I D ,   W A L L _ P R O T E C T I O N _ T Y P E _ I D ,   D O O R W A Y _ P R O T _ T Y P E _ I D ,   W A L K B O A R D _ T Y P E _ I D ,   S T A G I N G _ A R E A _ T Y P E _ I D ,   D U M P S T E R _ T Y P E _ I D ,   N E W _ S I T E _ T Y P E _ I D ,   O C C U P I E D _ S I T E _ T Y P E _ I D ,   O T H E R _ C O N D I T I O N S ,   D A T E _ C R E A T E D ,   C R E A T E D _ B Y ,   D A T E _ M O D I F I E D ,   M O D I F I E D _ B Y ,   V E R S I O N _ N O ,   P _ C A R D _ N U M B E R ,   F U R N I T U R E 1 _ C O N T A C T _ I D ,   F U R N I T U R E 2 _ C O N T A C T _ I D ,   A P P R O V E R _ C O N T A C T _ I D ,   P H O N E _ C O N T A C T _ I D ,   F L O O R _ N U M B E R _ T Y P E _ I D ,   P R I O R I T Y _ T Y P E _ I D ,   L E V E L _ T Y P E _ I D ,   F U R N _ R E Q _ T Y P E _ I D ,   C U S T _ C O N T A C T _ M O D _ D A T E ,   J O B _ L O C A T I O N _ M O D _ D A T E ,   C U S T _ C O L _ 1 ,   C U S T _ C O L _ 2 ,   C U S T _ C O L _ 3 ,   C U S T _ C O L _ 4 ,   C U S T _ C O L _ 5 ,   C U S T _ C O L _ 6 ,   C U S T _ C O L _ 7 ,   C U S T _ C O L _ 8 ,   C U S T _ C O L _ 9 ,   C U S T _ C O L _ 1 0 ,   I S _ C O P Y ,   I S _ S U R V E Y E D ,   F U R N I T U R E _ T Y P E ,   F U R N I T U R E _ Q T Y ,   P R O D _ D I S P _ F L A G ,   P R O D _ D I S P _ I D ,   A _ M _ S A L E S _ C O N T A C T _ I D ,   W O R K _ O R D E R _ R E C E I V E D _ D A T E ,   C S C _ W O _ F I E L D _ F L A G ,   I S _ S E N T _ D A T E ,   c u s t o m e r _ c o s t i n g _ t y p e _ i d ,   c u s t o m e r _ c o n t a c t 2 _ i d ,   c u s t o m e r _ c o n t a c t 3 _ i d ,   c u s t o m e r _ c o n t a c t 4 _ i d ,   j o b _ l o c a t i o n _ c o n t a c t _ i d ,   s y s t e m _ f u r n i t u r e _ l i n e _ t y p e _ i d ,   o t h e r _ f u r n i t u r e _ t y p e _ i d ,   o t h e r _ d e l i v e r y _ t y p e _ i d ,   s c h e d u l e _ w i t h _ c l i e n t _ f l a g ,   o r d e r _ t y p e _ i d ,   i s _ s t a i r _ c a r r y _ r e q u i r e d   F R O M   d b o . R E Q U E S T S   W I T H   ( H O L D L O C K   T A B L O C K X ) ' )  
 G O  
 S E T   I D E N T I T Y _ I N S E R T   d b o . T m p _ R E Q U E S T S   O F F  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T _ V E N D O R S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ V E N D O R S  
 G O  
 A L T E R   T A B L E   d b o . C U S T O M _ C O L S  
 	 D R O P   C O N S T R A I N T   F K _ C U S T O M _ C O L S _ R E Q U E S T S  
 G O  
 A L T E R   T A B L E   d b o . P U N C H L I S T S  
 	 D R O P   C O N S T R A I N T   f k _ p u n c h l i s t _ r e q u e s t s  
 G O  
 A L T E R   T A B L E   d b o . C H E C K L I S T S  
 	 D R O P   C O N S T R A I N T   F K _ C H E C K L I S T S _ R E Q U E S T S  
 G O  
 A L T E R   T A B L E   d b o . S E R V I C E S  
 	 D R O P   C O N S T R A I N T   F K _ S E R V I C E _ R E Q U E S T S  
 G O  
 A L T E R   T A B L E   d b o . p u r c h a s e _ o r d e r s  
 	 D R O P   C O N S T R A I N T   f k _ p o _ r e q u e s t _ i d  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ Q U O T E _ R E Q U E S T S  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T _ D O C U M E N T S  
 	 D R O P   C O N S T R A I N T   F K _ R E Q U E S T _ D O C U M E N T S _ R E Q U E S T S  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ R E Q U E S T S  
 G O  
 D R O P   T A B L E   d b o . R E Q U E S T S  
 G O  
 E X E C U T E   s p _ r e n a m e   N ' d b o . T m p _ R E Q U E S T S ' ,   N ' R E Q U E S T S ' ,   ' O B J E C T '    
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 P K _ R E Q U E S T S   P R I M A R Y   K E Y   C L U S T E R E D    
 	 (  
 	 R E Q U E S T _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ R E Q U E S T _ P R O J E C T S   O N   d b o . R E Q U E S T S  
 	 (  
 	 P R O J E C T _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ R E Q U E S T _ T Y P E S   O N   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ T Y P E _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ R E Q U E S T S _ N O   O N   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ N O  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ R E Q U E S T _ V E R S I O N _ N O   O N   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ N O ,  
 	 V E R S I O N _ N O  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   n c x _ p r o d u c t _ r e q u e s t _ v e r s i o n   O N   d b o . R E Q U E S T S  
 	 (  
 	 P R O J E C T _ I D ,  
 	 R E Q U E S T _ N O ,  
 	 V E R S I O N _ N O  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ R E Q U E S T _ Q R   O N   d b o . R E Q U E S T S  
 	 (  
 	 Q U O T E _ R E Q U E S T _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ R E Q U E S T S _ J L C   O N   d b o . R E Q U E S T S  
 	 (  
 	 j o b _ l o c a t i o n _ c o n t a c t _ i d  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 P R O D _ D I S P _ Y N   C H E C K   ( ( [ P R O D _ D I S P _ F L A G ]   =   ' Y '   o r   [ P R O D _ D I S P _ F L A G ]   =   ' N ' ) )  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 C S C _ W O _ F I E L D _ Y N   C H E C K   ( ( [ C S C _ W O _ F I E L D _ F L A G ]   =   ' Y '   o r   [ C S C _ W O _ F I E L D _ F L A G ]   =   ' N ' ) )  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A P P R O V A L _ R E Q _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 A P P R O V A L _ R E Q _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C A R P E T _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 C A R P E T _ L A Y E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ R E G U L A R _ H O U R S _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 R E G U L A R _ H O U R S _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ E V E N I N G _ H O U R S _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 E V E N I N G _ H O U R S _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ W E E K E N D _ H O U R S _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 W E E K E N D _ H O U R S _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ W A R E H O U S E _ F E E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 W A R E H O U S E _ F E E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D U R _ T I M E _ U O M _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 D U R A T I O N _ T I M E _ U O M _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ P H A S E D _ I N S T A L L _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 P H A S E D _ I N S T A L L _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ o t h e r _ d e l i v e r y _ t y p e   F O R E I G N   K E Y  
 	 (  
 	 o t h e r _ d e l i v e r y _ t y p e _ i d  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ c u s t o m e r _ c o s t i n g _ t y p e   F O R E I G N   K E Y  
 	 (  
 	 c u s t o m e r _ c o s t i n g _ t y p e _ i d  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ c u s t o m e r _ c o n t a c t 2   F O R E I G N   K E Y  
 	 (  
 	 c u s t o m e r _ c o n t a c t 2 _ i d  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ c u s t o m e r _ c o n t a c t 3   F O R E I G N   K E Y  
 	 (  
 	 c u s t o m e r _ c o n t a c t 3 _ i d  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ c u s t o m e r _ c o n t a c t 4   F O R E I G N   K E Y  
 	 (  
 	 c u s t o m e r _ c o n t a c t 4 _ i d  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ j o b _ l o c _ c o n t a c t   F O R E I G N   K E Y  
 	 (  
 	 j o b _ l o c a t i o n _ c o n t a c t _ i d  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ s y s _ f u r n _ l i n e _ t y p e   F O R E I G N   K E Y  
 	 (  
 	 s y s t e m _ f u r n i t u r e _ l i n e _ t y p e _ i d  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ o t h e r _ f u r n _ t y p e   F O R E I G N   K E Y  
 	 (  
 	 o t h e r _ f u r n i t u r e _ t y p e _ i d  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ o r d e r _ t y p e   F O R E I G N   K E Y  
 	 (  
 	 o r d e r _ t y p e _ i d  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O O R D _ W A L L _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O O R D _ W A L L _ C O V R _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 4   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 4  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ O C C U P I E D _ S I T E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 O C C U P I E D _ S I T E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ N E W _ S I T E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 N E W _ S I T E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ W A L K B O A R D _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 W A L K B O A R D _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D U M P S T E R _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 D U M P S T E R _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S T A G I N G _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 S T A G I N G _ A R E A _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O S T _ T O _ C U S T _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O S T _ T O _ C U S T _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O S T _ T O _ J O B _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O S T _ T O _ J O B _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O S T _ T O _ V E N D O R _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O S T _ T O _ V E N D _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ U N I O N _ L A B O R _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 U N I O N _ L A B O R _ R E Q _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ P R O J E C T S   F O R E I G N   K E Y  
 	 (  
 	 P R O J E C T _ I D  
 	 )   R E F E R E N C E S   d b o . P R O J E C T S  
 	 (  
 	 P R O J E C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S T A T U S E S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ S T A T U S _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T S _ A _ M _ S A L E S _ C O N T A C T _ I D   F O R E I G N   K E Y  
 	 (  
 	 A _ M _ S A L E S _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ Q U O T E _ R E Q U E S T S   F O R E I G N   K E Y  
 	 (  
 	 Q U O T E _ R E Q U E S T _ I D  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C C O U N T _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 A C C O U N T _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ Q U O T E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 Q U O T E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ P R I _ F U R N _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 P R I _ F U R N _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ P R I _ F U R N _ L I N E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 P R I _ F U R N _ L I N E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S E C _ F U R N _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 S E C _ F U R N _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S E C _ F U R N _ L I N E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 S E C _ F U R N _ L I N E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C A S E _ F U R N _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C A S E _ F U R N _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ J O B _ L O C A T I O N S   F O R E I G N   K E Y  
 	 (  
 	 J O B _ L O C A T I O N _ I D  
 	 )   R E F E R E N C E S   d b o . J O B _ L O C A T I O N S  
 	 (  
 	 J O B _ L O C A T I O N _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ U S E R S _ C   F O R E I G N   K E Y  
 	 (  
 	 C R E A T E D _ B Y  
 	 )   R E F E R E N C E S   d b o . U S E R S  
 	 (  
 	 U S E R _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ U S E R S _ M   F O R E I G N   K E Y  
 	 (  
 	 M O D I F I E D _ B Y  
 	 )   R E F E R E N C E S   d b o . U S E R S  
 	 (  
 	 U S E R _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ f l o o r _ n u m b e r _ t y p e s   F O R E I G N   K E Y  
 	 (  
 	 F L O O R _ N U M B E R _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ p r i o r i t y _ t y p e s   F O R E I G N   K E Y  
 	 (  
 	 P R I O R I T Y _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ l e v e l _ t y p e s   F O R E I G N   K E Y  
 	 (  
 	 L E V E L _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C A S E _ F U R N _ L I N E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C A S E _ F U R N _ L I N E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ W O O D _ P R O D U C T _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 W O O D _ P R O D U C T _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D E L I V E R Y _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 D E L I V E R Y _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T S _ P R O D _ D I S T   F O R E I G N   K E Y  
 	 (  
 	 P R O D _ D I S P _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ F U R N _ P L A N _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 F U R N _ P L A N _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ F U R N _ S P E C _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 F U R N _ S P E C _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S T A T I O N _ T Y P I C A L _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 W O R K S T A T I O N _ T Y P I C A L _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ P U N C H L I S T _ I T E M _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 P U N C H L I S T _ I T E M _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ W A L L _ M O U N T _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 W A L L _ M O U N T _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S I T E _ V I S I T _ R E Q _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 S I T E _ V I S I T _ R E Q _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S C H E D U L E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 S C H E D U L E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O O R D _ P H O N E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O O R D _ P H O N E _ D A T A _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O O R D _ F L O O R _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O O R D _ F L O O R _ C O V R _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O O R D _ E L E C T R I C A L _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O O R D _ E L E C T R I C A L _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C O O R D _ M O V E R _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 C O O R D _ M O V E R _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E 1   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 1  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ B L D G _ M G R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 B L D G _ M G R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 2   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 2  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ S E C U R I T Y _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 S E C U R I T Y _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 3   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 3  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ M O V E R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 M O V E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 4   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 4  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ O T H E R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 O T H E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 5   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 5  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D _ S A L E S _ R E P _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 D _ S A L E S _ R E P _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 6   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 6  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D _ S A L E S _ S U P _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 D _ S A L E S _ S U P _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 7   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 7  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D _ P R O J _ M G R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 D _ P R O J _ M G R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 8   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 8  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D _ D E S I G N E R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 D _ D E S I G N E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 9   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 9  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A _ M _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 A _ M _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ T Y P E S 1 0   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ T Y P E _ I D 1 0  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A _ M _ I N S T A L L E R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 A _ M _ I N S T A L L _ S U P _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 1   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 1  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ f u r n 1 _ c o n t a c t   F O R E I G N   K E Y  
 	 (  
 	 F U R N I T U R E 1 _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 2   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 2  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ f u r n 2 _ c o n t a c t   F O R E I G N   K E Y  
 	 (  
 	 F U R N I T U R E 2 _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 3   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 3  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 f k _ r e q u e s t _ a p p r o v e r _ c o n t a c t   F O R E I G N   K E Y  
 	 (  
 	 A P P R O V E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 5   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 5  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ C U S T O M E R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 C U S T O M E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 6   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 6  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A L T _ C U S T _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 A L T _ C U S T O M E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 7   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 7  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A _ D _ D E S I G N E R _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 A _ D _ D E S I G N E R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 8   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 8  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ G E N _ C O N T R A C T _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 G E N _ C O N T R A C T O R _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 9   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 9  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ E L E C T R I C I A N _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 E L E C T R I C I A N _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ A C T I V I T Y _ C A T _ T Y P E S 1 0   F O R E I G N   K E Y  
 	 (  
 	 A C T I V I T Y _ C A T _ T Y P E _ I D 1 0  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D A T A _ P H O N E _ C O N T A C T S   F O R E I G N   K E Y  
 	 (  
 	 D A T A _ P H O N E _ C O N T A C T _ I D  
 	 )   R E F E R E N C E S   d b o . C O N T A C T S  
 	 (  
 	 C O N T A C T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ R E Q U E S T S   F O R E I G N   K E Y  
 	 (  
 	 r e q u e s t _ i d  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . Q U O T E S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . Q U O T E S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . Q U O T E S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T _ D O C U M E N T S   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ D O C U M E N T S _ R E Q U E S T S   F O R E I G N   K E Y  
 	 (  
 	 r e q u e s t _ i d  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T _ D O C U M E N T S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T _ D O C U M E N T S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T _ D O C U M E N T S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . p u r c h a s e _ o r d e r s   A D D   C O N S T R A I N T  
 	 f k _ p o _ r e q u e s t _ i d   F O R E I G N   K E Y  
 	 (  
 	 r e q u e s t _ i d  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . p u r c h a s e _ o r d e r s ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . p u r c h a s e _ o r d e r s ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . p u r c h a s e _ o r d e r s ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . S E R V I C E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ S E R V I C E _ R E Q U E S T S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . S E R V I C E S  
 	 N O C H E C K   C O N S T R A I N T   F K _ S E R V I C E _ R E Q U E S T S  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . S E R V I C E S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . S E R V I C E S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . S E R V I C E S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . C H E C K L I S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ C H E C K L I S T S _ R E Q U E S T S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C H E C K L I S T S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C H E C K L I S T S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C H E C K L I S T S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . P U N C H L I S T S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 f k _ p u n c h l i s t _ r e q u e s t s   F O R E I G N   K E Y  
 	 (  
 	 r e q u e s t _ i d  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . P U N C H L I S T S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . P U N C H L I S T S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . P U N C H L I S T S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . C U S T O M _ C O L S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ C U S T O M _ C O L S _ R E Q U E S T S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     C A S C A D E    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C U S T O M _ C O L S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C U S T O M _ C O L S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . C U S T O M _ C O L S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . R E Q U E S T _ V E N D O R S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ R E Q U E S T _ V E N D O R S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 s e l e c t   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T _ V E N D O R S ' ,   ' O b j e c t ' ,   ' A L T E R ' )   a s   A L T _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T _ V E N D O R S ' ,   ' O b j e c t ' ,   ' V I E W   D E F I N I T I O N ' )   a s   V i e w _ d e f _ P e r ,   H a s _ P e r m s _ B y _ N a m e ( N ' d b o . R E Q U E S T _ V E N D O R S ' ,   ' O b j e c t ' ,   ' C O N T R O L ' )   a s   C o n t r _ P e r   