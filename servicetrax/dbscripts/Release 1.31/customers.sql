/ *  
       T u e s d a y ,   J a n u a r y   2 7 ,   2 0 0 9 1 1 : 2 3 : 3 3   A M  
       U s e r :   s a  
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
 A L T E R   T A B L E   d b o . C U S T O M E R S  
 	 D R O P   C O N S T R A I N T   d f _ c u s t o m e r _ v i e w _ s c h e d u l e _ f l a g  
 G O  
 A L T E R   T A B L E   d b o . C U S T O M E R S  
 	 D R O P   C O L U M N   V I E W _ S C H E D U L E _ F L A G  
 G O  
 C O M M I T  
 