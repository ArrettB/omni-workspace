/ *  
       C l e a r   d u p l i c a t e   f u n c t i o n   r i g h t   t y p e s .  
       A d d   u n i q u e   c o n s t r a i n t   t o   a v o i d   d u p l i c a t e   e n t r i e s .  
 * /  
  
 d e l e t e   f r o m   f u n c t i o n _ r i g h t _ t y p e s   w h e r e   f u n c t i o n _ r i g h t _ t y p e _ i d   i n  
 ( s e l e c t   m a x ( f u n c t i o n _ r i g h t _ t y p e _ i d )  
 f r o m   f u n c t i o n _ r i g h t _ t y p e s  
 w h e r e   f u n c t i o n _ i d   =   ( s e l e c t   f u n c t i o n _ i d   F R O M   f u n c t i o n s   w h e r e   c o d e   =   ' e n e t / p o / p o _ d e t a i l ' )  
 g r o u p   b y   r i g h t _ t y p e _ i d  
 )  
 G O  
  
 d e l e t e   f r o m   f u n c t i o n _ r i g h t _ t y p e s   w h e r e   f u n c t i o n _ r i g h t _ t y p e _ i d   i n  
 ( s e l e c t   m a x ( f u n c t i o n _ r i g h t _ t y p e _ i d )  
 f r o m   f u n c t i o n _ r i g h t _ t y p e s  
 w h e r e   f u n c t i o n _ i d   =   ( s e l e c t   f u n c t i o n _ i d   F R O M   f u n c t i o n s   w h e r e   c o d e   =   ' e n e t / p r o j / s e r v i c e _ a c c o u n t ' )  
 g r o u p   b y   r i g h t _ t y p e _ i d  
 )  
 G O  
  
  
 d e l e t e   f r o m   f u n c t i o n _ r i g h t _ t y p e s   w h e r e   f u n c t i o n _ r i g h t _ t y p e _ i d   i n  
 ( s e l e c t   m a x ( f u n c t i o n _ r i g h t _ t y p e _ i d )  
 f r o m   f u n c t i o n _ r i g h t _ t y p e s  
 w h e r e   f u n c t i o n _ i d   =   ( s e l e c t   f u n c t i o n _ i d   F R O M   f u n c t i o n s   w h e r e   c o d e   =   ' e n e t / r e q / q u o t e _ r e q u e s t ' )  
 g r o u p   b y   r i g h t _ t y p e _ i d  
 )  
 G O  
  
 d e l e t e   f r o m   f u n c t i o n _ r i g h t _ t y p e s   w h e r e   f u n c t i o n _ r i g h t _ t y p e _ i d   i n  
 ( s e l e c t   m a x ( f u n c t i o n _ r i g h t _ t y p e _ i d )  
 f r o m   f u n c t i o n _ r i g h t _ t y p e s  
 w h e r e   f u n c t i o n _ i d   =   ( s e l e c t   f u n c t i o n _ i d   F R O M   f u n c t i o n s   w h e r e   c o d e   =   ' e n e t / r e q / s e r v i c e _ r e q u e s t ' )  
 g r o u p   b y   r i g h t _ t y p e _ i d  
 )  
 G O  
  
  
  
 A L T E R   T A B L E   d b o . F U N C T I O N _ R I G H T _ T Y P E S   A D D   C O N S T R A I N T  
 	 U K _ F U N C T I O N _ R I G H T _ T Y P E S   U N I Q U E   N O N C L U S T E R E D    
 	 (  
 	 F U N C T I O N _ I D ,  
 	 R I G H T _ T Y P E _ I D  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
  
  
 