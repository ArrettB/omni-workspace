- -   S e e   h t t p : / / j i r a . a p e x i t . c o m / j i r a / b r o w s e / A N M - 2 5  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ T I M E _ C A P T U R E _ V ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ d b o ] . [ T I M E _ C A P T U R E _ V ]  
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 C R E A T E   V I E W   d b o . T I M E _ C A P T U R E _ V  
 A S  
 S E L E C T           d b o . S E R V I C E _ L I N E S . O R G A N I Z A T I O N _ I D ,   d b o . S E R V I C E _ L I N E S . T C _ J O B _ N O ,   d b o . S E R V I C E _ L I N E S . T C _ S E R V I C E _ N O ,    
                                             d b o . S E R V I C E _ L I N E S . T C _ S E R V I C E _ L I N E _ N O ,   d b o . S E R V I C E _ L I N E S . B I L L _ J O B _ N O ,   d b o . S E R V I C E _ L I N E S . B I L L _ S E R V I C E _ N O ,    
                                             d b o . S E R V I C E _ L I N E S . B I L L _ S E R V I C E _ L I N E _ N O ,   d b o . J O B S _ V . J O B _ N A M E ,   d b o . S E R V I C E _ L I N E S . R E S O U R C E _ N A M E ,   d b o . S E R V I C E _ L I N E S . I T E M _ N A M E ,    
                                             d b o . J O B S _ V . b i l l i n g _ u s e r _ n a m e ,   d b o . J O B S _ V . f o r e m a n _ r e s o u r c e _ n a m e ,   d b o . S E R V I C E _ L I N E S . T C _ J O B _ I D ,   d b o . S E R V I C E _ L I N E S . T C _ S E R V I C E _ I D ,    
                                             d b o . S E R V I C E _ L I N E S . B I L L _ J O B _ I D ,   d b o . S E R V I C E _ L I N E S . B I L L _ S E R V I C E _ I D ,   d b o . S E R V I C E _ L I N E S . P H _ S E R V I C E _ I D ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ I D ,   C A S T ( d b o . S E R V I C E S . J O B _ I D   A S   v a r c h a r )   +   ' - '   +   C A S T ( d b o . S E R V I C E _ L I N E S . I T E M _ I D   A S   v a r c h a r )    
                                             +   ' - '   +   C A S T ( d b o . S E R V I C E _ L I N E S . S T A T U S _ I D   A S   v a r c h a r )   A S   j o b _ i t e m _ s t a t u s _ i d ,   C A S T ( d b o . S E R V I C E _ L I N E S . T C _ S E R V I C E _ I D   A S   v a r c h a r )    
                                             +   ' - '   +   C A S T ( d b o . S E R V I C E _ L I N E S . S T A T U S _ I D   A S   v a r c h a r )   A S   s e r v i c e _ s t a t u s _ i d ,   C A S T ( d b o . S E R V I C E S . S E R V I C E _ I D   A S   v a r c h a r )    
                                             +   ' - '   +   C A S T ( d b o . S E R V I C E _ L I N E S . I T E M _ I D   A S   v a r c h a r )   +   ' - '   +   C A S T ( d b o . S E R V I C E _ L I N E S . S T A T U S _ I D   A S   v a r c h a r )   A S   s e r v i c e _ i t e m _ s t a t u s _ i d ,    
                                             d b o . J O B S _ V . B I L L I N G _ U S E R _ I D ,   d b o . J O B S _ V . f o r e m a n _ u s e r _ i d ,   d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E _ V A R C H A R ,   d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ W E E K ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ W E E K _ V A R C H A R ,   d b o . J O B S _ V . j o b _ s t a t u s _ t y p e _ c o d e ,   d b o . J O B S _ V . j o b _ s t a t u s _ t y p e _ n a m e ,    
                                             S E R V _ S T A T U S _ T Y P E S . C O D E   A S   s e r v _ s t a t u s _ t y p e _ c o d e ,   S E R V _ S T A T U S _ T Y P E S . N A M E   A S   s e r v _ s t a t u s _ t y p e _ n a m e ,   d b o . S E R V I C E _ L I N E S . S T A T U S _ I D ,    
                                             d b o . S E R V I C E _ L I N E _ S T A T U S E S . N A M E   A S   s t a t u s _ n a m e ,   d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E   A S   s t a t u s _ c o d e ,   d b o . S E R V I C E _ L I N E S . E X P O R T E D _ F L A G ,    
                                             d b o . S E R V I C E _ L I N E S . B I L L E D _ F L A G ,   d b o . S E R V I C E _ L I N E S . P O S T E D _ F L A G ,   d b o . S E R V I C E _ L I N E S . P O O L E D _ F L A G ,   d b o . S E R V I C E _ L I N E S . R E S O U R C E _ I D ,    
                                             d b o . S E R V I C E _ L I N E S . I T E M _ I D ,   d b o . S E R V I C E _ L I N E S . I T E M _ T Y P E _ C O D E ,   d b o . S E R V I C E _ L I N E S . B I L L A B L E _ F L A G ,   d b o . S E R V I C E _ L I N E S . T C _ Q T Y ,    
                                             d b o . S E R V I C E _ L I N E S . T C _ R A T E ,   d b o . S E R V I C E _ L I N E S . t c _ t o t a l ,   d b o . S E R V I C E _ L I N E S . P A Y R O L L _ Q T Y ,   d b o . S E R V I C E _ L I N E S . P A Y R O L L _ R A T E ,    
                                             d b o . S E R V I C E _ L I N E S . p a y r o l l _ t o t a l ,   d b o . S E R V I C E _ L I N E S . E X T _ P A Y _ C O D E ,   d b o . S E R V I C E _ L I N E S . E X P E N S E _ Q T Y ,   d b o . S E R V I C E _ L I N E S . E X P E N S E _ R A T E ,    
                                             d b o . S E R V I C E _ L I N E S . e x p e n s e _ t o t a l ,   d b o . S E R V I C E _ L I N E S . B I L L _ Q T Y ,   d b o . S E R V I C E _ L I N E S . B I L L _ R A T E ,   d b o . S E R V I C E _ L I N E S . b i l l _ t o t a l ,    
                                             d b o . S E R V I C E _ L I N E S . B I L L _ E X P _ Q T Y ,   d b o . S E R V I C E _ L I N E S . B I L L _ E X P _ R A T E ,   d b o . S E R V I C E _ L I N E S . b i l l _ e x p _ t o t a l ,    
                                             d b o . S E R V I C E _ L I N E S . B I L L _ H O U R L Y _ Q T Y ,   d b o . S E R V I C E _ L I N E S . B I L L _ H O U R L Y _ R A T E ,   d b o . S E R V I C E _ L I N E S . b i l l _ h o u r l y _ t o t a l ,    
                                             d b o . S E R V I C E _ L I N E S . A L L O C A T E D _ Q T Y ,   d b o . S E R V I C E _ L I N E S . I N T E R N A L _ R E Q _ F L A G ,   d b o . S E R V I C E _ L I N E S . P A R T I A L L Y _ A L L O C A T E D _ F L A G ,    
                                             d b o . S E R V I C E _ L I N E S . F U L L Y _ A L L O C A T E D _ F L A G ,   d b o . S E R V I C E _ L I N E S . P A L M _ R E P _ I D ,   d b o . S E R V I C E _ L I N E S . E N T E R E D _ D A T E ,    
                                             d b o . S E R V I C E _ L I N E S . E N T E R E D _ B Y ,   U S E R S _ 1 . F U L L _ N A M E   A S   e n t e r e d _ b y _ n a m e ,   d b o . S E R V I C E _ L I N E S . E N T R Y _ M E T H O D ,    
                                             d b o . S E R V I C E _ L I N E S . O V E R R I D E _ D A T E ,   d b o . S E R V I C E _ L I N E S . O V E R R I D E _ B Y ,   U S E R S _ 1 . F U L L _ N A M E   A S   o v e r r i d e _ b y _ n a m e ,    
                                             d b o . S E R V I C E _ L I N E S . O V E R R I D E _ R E A S O N ,   d b o . S E R V I C E _ L I N E S . V E R I F I E D _ D A T E ,   d b o . S E R V I C E _ L I N E S . V E R I F I E D _ B Y ,    
                                             U S E R S _ 2 . F U L L _ N A M E   A S   v e r i f i e d _ b y _ n a m e ,   d b o . S E R V I C E S . D E S C R I P T I O N   A S   s e r v i c e _ d e s c r i p t i o n ,   d b o . S E R V I C E _ L I N E S . D A T E _ C R E A T E D ,    
                                             d b o . S E R V I C E _ L I N E S . C R E A T E D _ B Y ,   U S E R S _ 3 . F U L L _ N A M E   A S   c r e a t e d _ b y _ n a m e ,   d b o . S E R V I C E _ L I N E S . D A T E _ M O D I F I E D ,    
                                             d b o . S E R V I C E _ L I N E S . M O D I F I E D _ B Y ,   U S E R S _ 4 . F U L L _ N A M E   A S   m o d i f i e d _ b y _ n a m e  
 F R O M                   d b o . L O O K U P S   S E R V _ S T A T U S _ T Y P E S   R I G H T   O U T E R   J O I N  
                                             d b o . J O B S _ V   R I G H T   O U T E R   J O I N  
                                             d b o . S E R V I C E S   O N   d b o . J O B S _ V . J O B _ I D   =   d b o . S E R V I C E S . J O B _ I D   O N    
                                             S E R V _ S T A T U S _ T Y P E S . L O O K U P _ I D   =   d b o . S E R V I C E S . S E R V _ S T A T U S _ T Y P E _ I D   R I G H T   O U T E R   J O I N  
                                             d b o . S E R V I C E _ L I N E _ S T A T U S E S   R I G H T   O U T E R   J O I N  
                                             d b o . U S E R S   U S E R S _ 4   R I G H T   O U T E R   J O I N  
                                             d b o . U S E R S   U S E R S _ 5   R I G H T   O U T E R   J O I N  
                                             d b o . U S E R S   U S E R S _ 1   R I G H T   O U T E R   J O I N  
                                             d b o . S E R V I C E _ L I N E S   O N   U S E R S _ 1 . U S E R _ I D   =   d b o . S E R V I C E _ L I N E S . O V E R R I D E _ B Y   O N    
                                             U S E R S _ 5 . U S E R _ I D   =   d b o . S E R V I C E _ L I N E S . E N T E R E D _ B Y   L E F T   O U T E R   J O I N  
                                             d b o . U S E R S   U S E R S _ 2   O N   d b o . S E R V I C E _ L I N E S . V E R I F I E D _ B Y   =   U S E R S _ 2 . U S E R _ I D   O N    
                                             U S E R S _ 4 . U S E R _ I D   =   d b o . S E R V I C E _ L I N E S . M O D I F I E D _ B Y   L E F T   O U T E R   J O I N  
                                             d b o . U S E R S   U S E R S _ 3   O N   d b o . S E R V I C E _ L I N E S . C R E A T E D _ B Y   =   U S E R S _ 3 . U S E R _ I D   O N    
                                             d b o . S E R V I C E _ L I N E _ S T A T U S E S . S T A T U S _ I D   =   d b o . S E R V I C E _ L I N E S . S T A T U S _ I D   O N   d b o . S E R V I C E S . S E R V I C E _ I D   =   d b o . S E R V I C E _ L I N E S . T C _ S E R V I C E _ I D  
  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 