 
  
 - -   T H I S   F I L E   C A N   B E   D I S C A R D E D ,   O N L Y   H E R E   I N   C A S E   O F   B A C K U P  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ G c _ u b e r _ v ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ d b o ] . [ G c _ u b e r _ v ]  
 G O  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ J C _ J O B _ C O S T S _ V ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ d b o ] . [ J C _ J O B _ C O S T S _ V ]  
 G O  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ j o b _ w i t h _ c o s t s _ u n b i l l e d _ v ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ d b o ] . [ j o b _ w i t h _ c o s t s _ u n b i l l e d _ v ]  
 G O  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ j o b s _ p o s t e d _ f r o m _ c o s t s _ v ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ d b o ] . [ j o b s _ p o s t e d _ f r o m _ c o s t s _ v ]  
 G O  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ i m s ] . [ j o b s _ t o t a l _ c o s t s _ v ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ i m s ] . [ j o b s _ t o t a l _ c o s t s _ v ]  
 G O  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ i m s ] . [ j o b s _ w i t h _ p o s t e d _ c o s t s _ v ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ i m s ] . [ j o b s _ w i t h _ p o s t e d _ c o s t s _ v ]  
 G O  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ t m p _ p o s t e d _ v ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ d b o ] . [ t m p _ p o s t e d _ v ]  
 G O  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ u s e r _ c u s t o m e r s _ v ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s V i e w ' )   =   1 )  
 d r o p   v i e w   [ d b o ] . [ u s e r _ c u s t o m e r s _ v ]  
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 C R E A T E   V I E W   d b o . G c _ u b e r _ v  
 A S  
 S E L E C T           d b o . O R G A N I Z A T I O N S . N A M E   A S   o r g a n i z a t i o n _ n a m e ,   d b o . C U S T O M E R S . D E A L E R _ N A M E   A S   d e a l e r _ n a m e ,    
                                             d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E   A S   j o b _ o w n e r ,   d b o . R E S O U R C E S . N A M E   A S   j o b _ s u p e r v i s o r ,   d b o . J O B S . J O B _ I D ,    
                                             d b o . J O B S . J O B _ N O ,   d b o . J O B S . J O B _ N A M E ,  
                                                     ( S E L E C T           S U M ( s l . b i l l _ q t y )  
                                                         F R O M                     s e r v i c e _ l i n e s   s l  
                                                         W H E R E             s l . t c _ j o b _ i d   =   d b o . J O B S . j o b _ i d   A N D   s l . s e r v i c e _ l i n e _ d a t e   B E T W E E N   ' 1 / 1 / 2 0 0 5 '   A N D   ' 1 / 3 1 / 2 0 0 5 ' )   A S   a b c ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E  
 F R O M                   d b o . J O B S   I N N E R   J O I N  
                                             d b o . P R O J E C T S   O N   d b o . J O B S . P R O J E C T _ I D   =   d b o . P R O J E C T S . P R O J E C T _ I D   I N N E R   J O I N  
                                             d b o . C U S T O M E R S   O N   d b o . J O B S . C U S T O M E R _ I D   =   d b o . C U S T O M E R S . C U S T O M E R _ I D   I N N E R   J O I N  
                                             d b o . O R G A N I Z A T I O N S   O N   d b o . C U S T O M E R S . O R G A N I Z A T I O N _ I D   =   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D   I N N E R   J O I N  
                                             d b o . S E R V I C E S   O N   d b o . J O B S . J O B _ I D   =   d b o . S E R V I C E S . J O B _ I D   I N N E R   J O I N  
                                             d b o . S E R V I C E _ L I N E S   O N   d b o . S E R V I C E S . S E R V I C E _ I D   =   d b o . S E R V I C E _ L I N E S . T C _ S E R V I C E _ I D   I N N E R   J O I N  
                                             d b o . R E S O U R C E S   O N   d b o . J O B S . F O R E M A N _ R E S O U R C E _ I D   =   d b o . R E S O U R C E S . R E S O U R C E _ I D   I N N E R   J O I N  
                                             d b o . U S E R S   O N   d b o . J O B S . B I L L I N G _ U S E R _ I D   =   d b o . U S E R S . U S E R _ I D  
 W H E R E           ( d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E   B E T W E E N   C O N V E R T ( D A T E T I M E ,   ' 2 0 0 5 - 0 1 - 0 1   0 0 : 0 0 : 0 0 ' ,   1 0 2 )   A N D   C O N V E R T ( D A T E T I M E ,    
                                             ' 2 0 0 5 - 0 1 - 3 1   0 0 : 0 0 : 0 0 ' ,   1 0 2 ) )  
  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 C R E A T E   V I E W   d b o . J C _ J O B _ C O S T S _ V  
 A S  
 S E L E C T           T O P   1 0 0   P E R C E N T   d b o . O R G A N I Z A T I O N S . N A M E   A S   [ O r g a n i z a t i o n   N a m e ] ,   d b o . J O B S . J O B _ N O   A S   [ J o b   N o ] ,   d b o . J O B S . J O B _ N A M E   A S   [ J o b   N a m e ] ,    
                                             d b o . C U S T O M E R S . D E A L E R _ N A M E   A S   [ D e a l e r   N a m e ] ,   d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E   A S   [ J o b   O w n e r ] ,   C O N V E R T ( v a r c h a r ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E ,   1 0 1 )   A S   [ S e r v i c e   L i n e   D a t e   ] ,   d b o . R E S O U R C E S . N A M E   A S   [ J o b   S u p e r v i s o r ] ,    
                                             d b o . I T E M S . N A M E   A S   [ I t e m   N a m e ] ,   i t e m _ t y p e s . C O D E   A S   [ I t e m   T y p e   C o d e ] ,   S U M ( d b o . S E R V I C E _ L I N E S . B I L L _ Q T Y )   A S   Q t y ,    
                                             d b o . S E R V I C E _ L I N E S . B I L L _ R A T E   A S   R a t e ,   S U M ( d b o . S E R V I C E _ L I N E S . B I L L _ Q T Y   *   d b o . S E R V I C E _ L I N E S . B I L L _ R A T E )   A S   T o t a l ,    
                                             d b o . I T E M S . C O S T _ P E R _ U O M   A S   [ C o s t   P e r   U n i t ] ,   S U M ( d b o . I T E M S . C O S T _ P E R _ U O M   *   d b o . S E R V I C E _ L I N E S . B I L L _ Q T Y )   A S   [ T o t a l   C o s t ] ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E   A S   [ R e p o r t   D a t e ]  
 F R O M                   d b o . S E R V I C E _ L I N E _ S T A T U S E S   R I G H T   O U T E R   J O I N  
                                             d b o . L O O K U P S   i t e m _ t y p e s   I N N E R   J O I N  
                                             d b o . I T E M S   O N   i t e m _ t y p e s . L O O K U P _ I D   =   d b o . I T E M S . I T E M _ T Y P E _ I D   I N N E R   J O I N  
                                             d b o . J O B S   I N N E R   J O I N  
                                             d b o . S E R V I C E S   O N   d b o . J O B S . J O B _ I D   =   d b o . S E R V I C E S . J O B _ I D   I N N E R   J O I N  
                                             d b o . S E R V I C E _ L I N E S   O N   d b o . S E R V I C E _ L I N E S . B I L L _ S E R V I C E _ I D   =   d b o . S E R V I C E S . S E R V I C E _ I D   O N    
                                             d b o . I T E M S . I T E M _ I D   =   d b o . S E R V I C E _ L I N E S . I T E M _ I D   L E F T   O U T E R   J O I N  
                                             d b o . O R G A N I Z A T I O N S   I N N E R   J O I N  
                                             d b o . C U S T O M E R S   O N   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D   =   d b o . C U S T O M E R S . O R G A N I Z A T I O N _ I D   O N    
                                             d b o . J O B S . C U S T O M E R _ I D   =   d b o . C U S T O M E R S . C U S T O M E R _ I D   O N    
                                             d b o . S E R V I C E _ L I N E _ S T A T U S E S . S T A T U S _ I D   =   d b o . S E R V I C E _ L I N E S . S T A T U S _ I D   L E F T   O U T E R   J O I N  
                                             d b o . R E S O U R C E S   O N   d b o . J O B S . F O R E M A N _ R E S O U R C E _ I D   =   d b o . R E S O U R C E S . R E S O U R C E _ I D   L E F T   O U T E R   J O I N  
                                             d b o . U S E R S   O N   d b o . J O B S . B I L L I N G _ U S E R _ I D   =   d b o . U S E R S . U S E R _ I D  
 G R O U P   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O ,   d b o . J O B S . J O B _ N A M E ,   d b o . C U S T O M E R S . D E A L E R _ N A M E ,    
                                             d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E ,   d b o . R E S O U R C E S . N A M E ,   d b o . I T E M S . N A M E ,   d b o . I T E M S . C O S T _ P E R _ U O M ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E ,   d b o . S E R V I C E _ L I N E S . B I L L _ R A T E ,   d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E ,   i t e m _ t y p e s . C O D E  
 H A V I N G             ( d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E   < >   ' T e m p ' )  
 O R D E R   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O ,   d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E  
  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 C R E A T E   V I E W   d b o . j o b _ w i t h _ c o s t s _ u n b i l l e d _ v  
 A S  
 S E L E C T           T O P   1 0 0   P E R C E N T   d b o . O R G A N I Z A T I O N S . N A M E   A S   [ O r g a n i z a t i o n   N a m e ] ,   d b o . J O B S . J O B _ N O   A S   [ J o b   N o ] ,   d b o . J O B S . J O B _ N A M E   A S   [ J o b   N a m e ] ,    
                                             d b o . C U S T O M E R S . D E A L E R _ N A M E   A S   [ D e a l e r   N a m e ] ,   d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E   A S   [ J o b   O w n e r ] ,   C O N V E R T ( v a r c h a r ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E ,   1 0 1 )   A S   [ S e r v i c e   L i n e   D a t e   ] ,   d b o . R E S O U R C E S . N A M E   A S   [ J o b   S u p e r v i s o r ] ,    
                                             d b o . I T E M S . N A M E   A S   [ I t e m   N a m e ] ,   S U M ( d b o . S E R V I C E _ L I N E S . B I L L _ Q T Y )   A S   Q t y ,   d b o . S E R V I C E _ L I N E S . B I L L _ R A T E   A S   R a t e ,    
                                             S U M ( d b o . S E R V I C E _ L I N E S . B I L L _ Q T Y   *   d b o . S E R V I C E _ L I N E S . B I L L _ R A T E )   A S   T o t a l ,   d b o . I T E M S . C O S T _ P E R _ U O M   A S   [ C o s t   P e r   U n i t ] ,    
                                             S U M ( d b o . I T E M S . C O S T _ P E R _ U O M   *   d b o . S E R V I C E _ L I N E S . B I L L _ Q T Y )   A S   [ T o t a l   C o s t ] ,   d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E   A S   [ R e p o r t   D a t e ]  
 F R O M                   d b o . J O B S   I N N E R   J O I N  
                                             d b o . S E R V I C E S   O N   d b o . J O B S . J O B _ I D   =   d b o . S E R V I C E S . J O B _ I D   I N N E R   J O I N  
                                             d b o . S E R V I C E _ L I N E S   O N   d b o . S E R V I C E _ L I N E S . B I L L _ S E R V I C E _ I D   =   d b o . S E R V I C E S . S E R V I C E _ I D   I N N E R   J O I N  
                                             d b o . I T E M S   O N   d b o . S E R V I C E _ L I N E S . I T E M _ I D   =   d b o . I T E M S . I T E M _ I D   I N N E R   J O I N  
                                             d b o . C U S T O M E R S   O N   d b o . J O B S . C U S T O M E R _ I D   =   d b o . C U S T O M E R S . C U S T O M E R _ I D   I N N E R   J O I N  
                                             d b o . O R G A N I Z A T I O N S   O N   d b o . C U S T O M E R S . O R G A N I Z A T I O N _ I D   =   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D   I N N E R   J O I N  
                                             d b o . S E R V I C E _ L I N E _ S T A T U S E S   O N   d b o . S E R V I C E _ L I N E S . S T A T U S _ I D   =   d b o . S E R V I C E _ L I N E _ S T A T U S E S . S T A T U S _ I D   L E F T   O U T E R   J O I N  
                                             d b o . R E S O U R C E S   O N   d b o . J O B S . F O R E M A N _ R E S O U R C E _ I D   =   d b o . R E S O U R C E S . R E S O U R C E _ I D   L E F T   O U T E R   J O I N  
                                             d b o . U S E R S   O N   d b o . J O B S . B I L L I N G _ U S E R _ I D   =   d b o . U S E R S . U S E R _ I D  
 G R O U P   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O ,   d b o . J O B S . J O B _ N A M E ,   d b o . C U S T O M E R S . D E A L E R _ N A M E ,    
                                             d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E ,   d b o . R E S O U R C E S . N A M E ,   d b o . I T E M S . N A M E ,   d b o . I T E M S . C O S T _ P E R _ U O M ,    
                                             d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E ,   d b o . S E R V I C E _ L I N E S . B I L L _ R A T E ,   d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E  
 H A V I N G             ( d b o . I T E M S . C O S T _ P E R _ U O M   I S   N O T   N U L L )   A N D   ( d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E   < >   ' T e m p '   A N D    
                                             d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E   < >   ' P o s t e d ' )  
 O R D E R   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O ,   d b o . S E R V I C E _ L I N E S . S E R V I C E _ L I N E _ D A T E  
  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 C R E A T E   V I E W   d b o . j o b s _ p o s t e d _ f r o m _ c o s t s _ v  
 A S  
 S E L E C T           T O P   1 0 0   P E R C E N T   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D ,   d b o . O R G A N I Z A T I O N S . N A M E   A S   [ O r g a n i z a t i o n   N a m e ] ,   d b o . J O B S . J O B _ N O   A S   [ J o b   N o ] ,    
                                             d b o . C U S T O M E R S . C U S T O M E R _ N A M E   A S   [ C u s t o m e r   N a m e ] ,   d b o . C U S T O M E R S . D E A L E R _ N A M E   A S   [ D e a l e r   N a m e ] ,    
                                             d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E   A S   [ J o b   O w n e r ] ,   ' N / A '   A S   [ I n v o i c e   N o ] ,    
                                             d b o . S E R V I C E _ L I N E S . I N V O I C E _ P O S T _ D A T E   A S   [ I n v o i c e d   D a t e ] ,   d b o . R E S O U R C E S . N A M E   A S   [ J o b   S u p e r v i s o r ] ,    
                                             d b o . C O N T A C T S . C O N T A C T _ N A M E   A S   [ S P   S a l e s ] ,   0   A S   [ T o t a l   I n v o i c e d ] ,  
                                                     ( S E L E C T           I S N U L L ( S U M ( s l . b i l l _ q t y   *   I S N U L L ( i . c o s t _ p e r _ u o m ,   0 ) ) ,   0 )  
                                                         F R O M                     s e r v i c e _ l i n e s   s l ,   i t e m s   i  
                                                         W H E R E             s l . b i l l _ j o b _ i d   =   j o b s . j o b _ i d   A N D   s l . i t e m _ i d   =   i . i t e m _ i d   A N D   s l . i t e m _ t y p e _ c o d e   =   ' h o u r s '   A N D   i . n a m e   N O T   L I K E   ' T R U C K % '   A N D    
                                                                                                       ( n a m e   N O T   L I K E   ' s u b % '   O R  
                                                                                                       n a m e   L I K E   ' s u b % e x p % ' ) )   A S   [ L a b o r   C o s t ] ,  
                                                     ( S E L E C T           I S N U L L ( S U M ( s l . b i l l _ q t y   *   I S N U L L ( i . c o s t _ p e r _ u o m ,   0 ) ) ,   0 )  
                                                         F R O M                     s e r v i c e _ l i n e s   s l ,   i t e m s   i  
                                                         W H E R E             s l . b i l l _ j o b _ i d   =   j o b s . j o b _ i d   A N D   s l . i t e m _ i d   =   i . i t e m _ i d   A N D   s l . i t e m _ t y p e _ c o d e   =   ' h o u r s '   A N D   i . n a m e   L I K E   ' T R U C K % ' )   A S   [ T r u c k   C o s t   ] ,  
                                                     ( S E L E C T           I S N U L L ( S U M ( s l . b i l l _ q t y   *   I S N U L L ( i . c o s t _ p e r _ u o m ,   0 ) ) ,   0 )  
                                                         F R O M                     s e r v i c e _ l i n e s   s l ,   i t e m s   i  
                                                         W H E R E             s l . b i l l _ j o b _ i d   =   j o b s . j o b _ i d   A N D   s l . i t e m _ i d   =   i . i t e m _ i d   A N D   s l . i t e m _ t y p e _ c o d e   =   ' h o u r s '   A N D   i . n a m e   L I K E   ' S U B - % '   A N D    
                                                                                                       i . n a m e   N O T   L I K E   ' S U B % E X P % ' )   A S   [ S u b   C o s t   ] ,  
                                                     ( S E L E C T           I S N U L L ( S U M ( s l . e x p e n s e _ q t y   *   I S N U L L ( s l . e x p e n s e _ r a t e ,   0 ) ) ,   0 )  
                                                         F R O M                     s e r v i c e _ l i n e s   s l  
                                                         W H E R E             s l . b i l l _ j o b _ i d   =   j o b s . j o b _ i d   A N D   s l . i t e m _ t y p e _ c o d e   =   ' e x p e n s e ' )   A S   [ E x p e n s e   C o s t   ]  
 F R O M                   d b o . J O B S   I N N E R   J O I N  
                                             d b o . S E R V I C E _ L I N E S   O N   d b o . J O B S . J O B _ I D   =   d b o . S E R V I C E _ L I N E S . B I L L _ J O B _ I D   I N N E R   J O I N  
                                             d b o . C U S T O M E R S   O N   d b o . J O B S . C U S T O M E R _ I D   =   d b o . C U S T O M E R S . C U S T O M E R _ I D   I N N E R   J O I N  
                                             d b o . O R G A N I Z A T I O N S   O N   d b o . C U S T O M E R S . O R G A N I Z A T I O N _ I D   =   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D   L E F T   O U T E R   J O I N  
                                             d b o . R E S O U R C E S   O N   d b o . J O B S . F O R E M A N _ R E S O U R C E _ I D   =   d b o . R E S O U R C E S . R E S O U R C E _ I D   L E F T   O U T E R   J O I N  
                                             d b o . U S E R S   O N   d b o . J O B S . B I L L I N G _ U S E R _ I D   =   d b o . U S E R S . U S E R _ I D   L E F T   O U T E R   J O I N  
                                             d b o . C O N T A C T S   O N   d b o . J O B S . A _ M _ S A L E S _ C O N T A C T _ I D   =   d b o . C O N T A C T S . C O N T A C T _ I D  
 G R O U P   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O ,   d b o . C U S T O M E R S . D E A L E R _ N A M E ,   d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E ,    
                                             d b o . R E S O U R C E S . N A M E ,   d b o . S E R V I C E _ L I N E S . I N V O I C E _ P O S T _ D A T E ,   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D ,   d b o . C U S T O M E R S . C U S T O M E R _ N A M E ,    
                                             d b o . C O N T A C T S . C O N T A C T _ N A M E ,   d b o . J O B S . J O B _ I D  
 H A V I N G             ( d b o . S E R V I C E _ L I N E S . I N V O I C E _ P O S T _ D A T E   I S   N O T   N U L L )  
 O R D E R   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O  
  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 s e t u s e r   N ' i m s '  
 G O  
  
 C R E A T E   V I E W   j o b s _ t o t a l _ c o s t s _ v   A S    
 S E L E C T   *    
 F R O M   j o b s _ w i t h _ c o s t s _ v    
 U N I O N    
 S E L E C T   *    
 F R O M   j o b s _ w i t h _ p o s t e d _ c o s t s _ v  
 G O  
 s e t u s e r  
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 s e t u s e r   N ' i m s '  
 G O  
  
 C R E A T E   V I E W   j o b s _ w i t h _ p o s t e d _ c o s t s _ v   A S    
 S E L E C T   T O P   1 0 0   P E R C E N T   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D ,  
         d b o . O R G A N I Z A T I O N S . N A M E                                                                 A S   [ O r g a n i z a t i o n   N a m e ] ,  
         d b o . J O B S . J O B _ N O                                                                               A S   [ J o b   N o ] ,  
         d b o . C U S T O M E R S . C U S T O M E R _ N A M E                                                       A S   [ C u s t o m e r   N a m e ] ,  
         d b o . C U S T O M E R S . D E A L E R _ N A M E                                                           A S   [ D e a l e r   N a m e ] ,  
         d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E             A S   [ J o b   O w n e r ] ,  
         N U L L                                                                                                     A S   [ I n v o i c e   N o ] ,  
         s l . I N V O I C E _ P O S T _ D A T E                                                                     A S   [ I n v o i c e d   D a t e ] ,  
         d b o . R E S O U R C E S . N A M E                                                                         A S   [ J o b   S u p e r v i s o r ] ,  
         d b o . C O N T A C T S . C O N T A C T _ N A M E                                                           A S   [ S P   S a l e s ] ,  
         0                                                                                                           A S   [ T o t a l   I n v o i c e d ] ,  
         S U M ( I S N U L L ( s l . B I L L _ Q T Y   *   l a b o r _ i t e m s . C O S T _ P E R _ U O M , 0 ) )   A S   [ l a b o r   c o s t ] ,  
         S U M ( I S N U L L ( s l . B I L L _ Q T Y   *   t r u c k _ i t e m s . C O S T _ P E R _ U O M , 0 ) )   A S   [ t r u c k   c o s t ] ,  
         S U M ( I S N U L L ( s l . B I L L _ Q T Y   *   s u b _ i t e m s . C O S T _ P E R _ U O M , 0 ) )       A S   [ s u b   c o s t ] ,  
         S U M ( I S N U L L (    
         C A S E    
                 W H E N   ( s l . e n t r y _ m e t h o d   =   ' g r e a t   p l a i n s ' )    
                 T H E N   s l . e x p e n s e _ t o t a l    
                 E L S E   ( s l . e x p e n s e _ q t y   *   e x p e n s e _ i t e m s . c o s t _ p e r _ u o m )    
         E N D , 0 ) )                                                               A S   [ e x p e n s e   c o s t ]    
 F R O M   d b o . J O B S    
                 I N N E R   J O I N   d b o . C U S T O M E R S    
                 O N   d b o . J O B S . C U S T O M E R _ I D   =   d b o . C U S T O M E R S . C U S T O M E R _ I D    
                 I N N E R   J O I N   d b o . O R G A N I Z A T I O N S    
                 O N   d b o . C U S T O M E R S . O R G A N I Z A T I O N _ I D   =   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D    
                 I N N E R   J O I N   d b o . S E R V I C E _ L I N E S   s l    
                 O N   d b o . J O B S . J O B _ I D   =   s l . b i l l _ j o b _ i d    
                 L E F T   O U T E R   J O I N   d b o . R E S O U R C E S    
                 O N   d b o . J O B S . F O R E M A N _ R E S O U R C E _ I D   =   d b o . R E S O U R C E S . R E S O U R C E _ I D    
                 L E F T   O U T E R   J O I N   d b o . C O N T A C T S    
                 O N   d b o . C O N T A C T S . C O N T A C T _ I D   =   d b o . J O B S .   A _ M _ S A L E S _ C O N T A C T _ I D    
                 L E F T   O U T E R   J O I N   d b o . U S E R S    
                 O N   d b o . U S E R S . U S E R _ I D   =   d b o . J O B S . B I L L I N G _ U S E R _ I D    
                 L E F T   O U T E R   J O I N   d b o . I T E M S   l a b o r _ i t e m s    
                 O N   s l . I T E M _ I D   =   l a b o r _ i t e m s . I T E M _ I D    
                 A N D   s l . i t e m _ t y p e _ c o d e   =   ' h o u r s '    
                 A N D   l a b o r _ i t e m s . N A M E   N O T   L I K E   ' T R U C K % '    
                 A N D   ( l a b o r _ i t e m s . N A M E   N O T   L I K E   ' S U B % '    
                 O R   l a b o r _ i t e m s . N A M E   L I K E   ' S U B % E X P % ' )    
                 L E F T   O U T E R   J O I N   d b o . I T E M S   t r u c k _ i t e m s    
                 O N   s l . I T E M _ I D   =   t r u c k _ i t e m s . I T E M _ I D    
                 A N D   s l . i t e m _ t y p e _ c o d e   =   ' h o u r s '    
                 A N D   t r u c k _ i t e m s . N A M E   L I K E   ' T R U C K % '    
                 L E F T   O U T E R   J O I N   d b o . I T E M S   s u b _ i t e m s    
                 O N   s l . I T E M _ I D   =   s u b _ i t e m s   . I T E M _ I D    
                 A N D   s l . i t e m _ t y p e _ c o d e   =   ' h o u r s '    
                 A N D   s u b _ i t e m s . N A M E   L I K E   ' S U B - % '    
                 A N D   s u b _ i t e m s . N A M E   N O T   L I K E   ' S U B % E X P % '    
                 L E F T   O U T E R   J O I N   d b o . I T E M S   e x p e n s e _ i t e m s    
                 O N   s l . I T E M _ I D   =   e x p e n s e _ i t e m s . I T E M _ I D    
                 A N D   s l . i t e m _ t y p e _ c o d e   =   ' e x p e n s e '    
 W H E R E   s l . I N V O I C E _ P O S T _ D A T E   I S   N O T   N U L L    
 G R O U P   B Y   d b o . o r g a n i z a t i o n s . o r g a n i z a t i o n _ i d ,  
         d b o . O R G A N I Z A T I O N S . N A M E ,  
         d b o . J O B S . J O B _ N O ,  
         d b o . C U S T O M E R S . C U S T O M E R _ N A M E ,  
         d b o . C U S T O M E R S . D E A L E R _ N A M E ,  
         d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E ,  
         s l . I N V O I C E _ P O S T _ D A T E ,  
         d b o . R E S O U R C E S . N A M E ,  
         d b o . C O N T A C T S . C O N T A C T _ N A M E  
 G O  
 s e t u s e r  
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 C R E A T E   V I E W   d b o . t m p _ p o s t e d _ v  
 A S  
 S E L E C T           T O P   1 0 0   P E R C E N T   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D ,   d b o . O R G A N I Z A T I O N S . N A M E   A S   [ O r g a n i z a t i o n   N a m e ] ,   d b o . J O B S . J O B _ N O   A S   [ J o b   N o ] ,    
                                             d b o . C U S T O M E R S . C U S T O M E R _ N A M E   A S   [ C u s t o m e r   N a m e ] ,   d b o . C U S T O M E R S . D E A L E R _ N A M E   A S   [ D e a l e r   N a m e ] ,    
                                             d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E   A S   [ J o b   O w n e r ] ,   d b o . R E S O U R C E S . N A M E   A S   [ J o b   S u p e r v i s o r ]  
 F R O M                   d b o . J O B S   I N N E R   J O I N  
                                             d b o . C U S T O M E R S   O N   d b o . J O B S . C U S T O M E R _ I D   =   d b o . C U S T O M E R S . C U S T O M E R _ I D   I N N E R   J O I N  
                                             d b o . O R G A N I Z A T I O N S   O N   d b o . C U S T O M E R S . O R G A N I Z A T I O N _ I D   =   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D   I N N E R   J O I N  
                                             d b o . S E R V I C E _ L I N E S   O N   d b o . J O B S . J O B _ I D   =   d b o . S E R V I C E _ L I N E S . B I L L _ J O B _ I D   I N N E R   J O I N  
                                             d b o . S E R V I C E _ L I N E _ S T A T U S E S   O N   d b o . S E R V I C E _ L I N E S . S T A T U S _ I D   =   d b o . S E R V I C E _ L I N E _ S T A T U S E S . S T A T U S _ I D   L E F T   O U T E R   J O I N  
                                             d b o . R E S O U R C E S   O N   d b o . J O B S . F O R E M A N _ R E S O U R C E _ I D   =   d b o . R E S O U R C E S . R E S O U R C E _ I D   L E F T   O U T E R   J O I N  
                                             d b o . U S E R S   O N   d b o . J O B S . B I L L I N G _ U S E R _ I D   =   d b o . U S E R S . U S E R _ I D  
 G R O U P   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O ,   d b o . C U S T O M E R S . D E A L E R _ N A M E ,   d b o . U S E R S . F I R S T _ N A M E   +   '   '   +   d b o . U S E R S . L A S T _ N A M E ,    
                                             d b o . R E S O U R C E S . N A M E ,   d b o . O R G A N I Z A T I O N S . O R G A N I Z A T I O N _ I D ,   d b o . C U S T O M E R S . C U S T O M E R _ N A M E ,   d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E ,    
                                             d b o . S E R V I C E _ L I N E S . P O S T E D _ F R O M _ I N V O I C E _ I D  
 H A V I N G             ( d b o . S E R V I C E _ L I N E S . P O S T E D _ F R O M _ I N V O I C E _ I D   I S   N U L L )   A N D   ( d b o . S E R V I C E _ L I N E _ S T A T U S E S . C O D E   =   ' p o s t e d ' )  
 O R D E R   B Y   d b o . O R G A N I Z A T I O N S . N A M E ,   d b o . J O B S . J O B _ N O  
  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 S E T   Q U O T E D _ I D E N T I F I E R   O N    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
  
 C R E A T E   V I E W   u s e r _ c u s t o m e r s _ v   A S  
 S E L E C T           d b o . U S E R _ C U S T O M E R S . u s e r _ i d ,   d b o . C U S T O M E R S . C U S T O M E R _ I D  
 F R O M                   d b o . C U S T O M E R S   I N N E R   J O I N  
                                             d b o . U S E R _ C U S T O M E R S   O N   d b o . C U S T O M E R S . P A R E N T _ C U S T O M E R _ I D   =   d b o . U S E R _ C U S T O M E R S . c u s t o m e r _ i d  
 U N I O N  
 S E L E C T           d b o . U S E R _ C U S T O M E R S . u s e r _ i d ,   d b o . U S E R _ C U S T O M E R S . c u s t o m e r _ i d  
 F R O M                   d b o . U S E R _ C U S T O M E R S  
  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O F F    
 G O  
 S E T   A N S I _ N U L L S   O N    
 G O  
  
 