/ *  
       F r i d a y ,   M a y   1 6 ,   2 0 0 8 2 : 2 7 : 0 1   P M  
       U s e r :   s a  
       S e r v e r :   L E X U S \ l e x u s 6 4 d e v  
       D a t a b a s e :   s e r v i c e t r a x _ d e v  
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
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ U S E R S  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ U S E R S _ C  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ U S E R S _ M  
 G O  
 C O M M I T  
 B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ R E Q U E S T S  
 G O  
 C O M M I T  
 B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ R E Q U E S T _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ T Y P E S  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   F K _ Q U O T E _ S T A T U S E S  
 G O  
 C O M M I T  
 B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S  
 	 D R O P   C O N S T R A I N T   D F _ Q U O T E S _ T A X A B L E _ F L A G  
 G O  
 C R E A T E   T A B L E   d b o . T m p _ Q U O T E S  
 	 (  
 	 q u o t e _ i d   n u m e r i c ( 1 8 ,   0 )   n o t   n u l l   i d e n t i t y   ( 1 ,   1 ) ,  
 	 r e q u e s t _ i d   n u m e r i c ( 1 8 ,   0 )   n o t   n u l l ,  
 	 i s _ s e n t   v a r c h a r ( 1 )   n o t   n u l l ,  
 	 r e q u e s t _ t y p e _ i d   n u m e r i c ( 1 8 ,   0 )   n o t   n u l l ,  
 	 q u o t e _ n o   n u m e r i c ( 1 8 ,   0 )   n o t   n u l l ,  
 	 q u o t e _ t y p e _ i d   n u m e r i c ( 1 8 ,   0 )   n o t   n u l l ,  
 	 q u o t e _ s t a t u s _ t y p e _ i d   n u m e r i c ( 1 8 ,   0 )   n o t   n u l l ,  
 	 q u o t e d _ b y _ u s e r _ i d   n u m e r i c ( 1 8 ,   0 )   n u l l ,  
 	 q u o t e r s _ t i t l e   v a r c h a r ( 1 0 0 )   n u l l ,  
 	 d e s c r i p t i o n   v a r c h a r ( 2 0 0 0 )   n u l l ,  
 	 q u o t e _ t o t a l   n u m e r i c ( 1 8 ,   2 )   n u l l ,  
 	 t a x a b l e _ f l a g   v a r c h a r ( 1 )   n u l l ,  
 	 t a x a b l e _ a m o u n t   n u m e r i c ( 1 8 ,   2 )   n u l l ,  
 	 w a r e h o u s e _ f e e _ f l a g   v a r c h a r ( 1 )   n u l l ,  
 	 d a t e _ q u o t e d   d a t e t i m e   n u l l ,  
 	 d a t e _ p r i n t e d   d a t e t i m e   n u l l ,  
 	 e x t r a _ c o n d i t i o n s   v a r c h a r ( 1 0 0 0 )   n u l l ,  
 	 d a t e _ c r e a t e d   d a t e t i m e   n o t   n u l l ,  
 	 c r e a t e d _ b y   n u m e r i c ( 1 8 ,   0 )   n o t   n u l l ,  
 	 d a t e _ m o d i f i e d   d a t e t i m e   n u l l ,  
 	 m o d i f i e d _ b y   n u m e r i c ( 1 8 ,   0 )   n u l l ,  
 	 v e r s i o n   i n t   n u l l ,  
 	 s u b _ v e r s i o n   i n t   n u l l ,  
 	 s y s t e m s _ s h i p p i n g _ m e t h o d   v a r c h a r ( 5 0 )   n u l l ,  
 	 c a s e g o o d s _ s h i p p i n g _ m e t h o d   v a r c h a r ( 5 0 )   n u l l ,  
 	 [ s e l e c t _ j o b _ s i t e _ m o v e - s t a g e _ e n v i r o n m e n t ]   v a r c h a r ( 5 0 )   n u l l ,  
 	 [ s y s t e m _ t y p i c a l _ l i n e - t y p i c a l 1 ]   v a r c h a r ( 5 0 )   n u l l ,  
 	 t y p i c a l 1 _ w o r k s t a t i o n _ c o u n t   v a r c h a r ( 5 0 )   n u l l ,  
 	 o m n i _ b i l l _ s t d _ h o u r s _ d i s c o u n t e d _ b i l l _ r a t e   v a r c h a r ( 5 0 )   n u l l ,  
 	 n e t _ e f f e c t i v e _ b i l l i n g _ r a t e _ p e r _ h o u r   v a r c h a r ( 5 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - m o v e _ s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i s c o u n t e d _ h o u r s - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - m o v e _ s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ i n d u s t r y _ s t d _ b i l l - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - m o v e - s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ r o c _ o m n i _ d i r e c t _ c o s t - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - m o v e _ s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ h o u r s - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - m o v e _ s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ h o u r s - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - m o v e _ s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ i n d u s t r y _ s t d _ b i l l - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - m o v e _ s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i s c o u n t e d _ b i l l - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - r e c e i v e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - r e l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - t r u c k ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - d r i v e r ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - u n l o a d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - m o v e _ s t a g e ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - i n s t a l l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - e l e c t r i c a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ i n d _ o m n i _ d i r e c t _ c o s t - t o t a l ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ t y p i c a l   v a r c h a r ( 1 0 0 )   n u l l ,  
 	 t 1 _ w o r k s t a t i o n _ c o u n t   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ d o m i n a n t _ w o r k s t a t i o n   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ b e l t l i n e _ p o w e r   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 1 _ p a n e l s _ n o n - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ p a n e l s _ p o w e r e d   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ t i l e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 1 _ s t a c k - o n _ f r a m e _ f a b r i c ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 1 _ s t a c k - o n _ f r a m e _ g l a s s ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ w o r k s u r f a c e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ o v e r h e a d s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ p e d e s t a l s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ t a s k l i g h t s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ k e y b o a r d _ t r a y s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ w a l l t r a c k   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ d o o r s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 1 _ a c c e s s o r i e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ t y p i c a l   v a r c h a r ( 1 0 0 )   n u l l ,  
 	 t 2 _ w o r k s t a t i o n _ c o u n t   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ d o m i n a n t _ w o r k s t a t i o n   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ b e l t l i n e _ p o w e r   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 2 _ p a n e l s _ n o n - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 2 _ p a n e l s - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ t i l e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 2 _ s t a c k - o n _ f r a m e _ f a b r i c ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 2 _ s t a c k - o n _ f r a m e _ g l a s s ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ w o r k s u r f a c e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ o v e r h e a d s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ p e d e s t a l s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ t a s k l i g h t s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ k e y b o a r d _ t r a y s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ w a l l t r a c k   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ d o o r s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 2 _ a c c e s s o r i e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ t y p i c a l   v a r c h a r ( 1 0 0 )   n u l l ,  
 	 t 3 _ w o r k s t a t i o n _ c o u n t   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ d o m i n a n t _ w o r k s t a t i o n   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ b e l t l i n e _ p o w e r   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 3 _ p a n e l s _ n o n - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 3 _ p a n e l s - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ t i l e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 3 _ s t a c k - o n _ f r a m e _ f a b r i c ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 3 _ s t a c k - o n _ f r a m e _ g l a s s ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ w o r k s u r f a c e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ o v e r h e a d s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ p e d e s t a l s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ t a s k l i g h t s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ k e y b o a r d _ t r a y s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ w a l l t r a c k   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ d o o r s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 3 _ a c c e s s o r i e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ t y p i c a l   v a r c h a r ( 1 0 0 )   n u l l ,  
 	 t 4 _ w o r k s t a t i o n _ c o u n t   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ d o m i n a n t _ w o r k s t a t i o n   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ b e l t l i n e _ p o w e r   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 4 _ p a n e l s _ n o n - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ p a n e l s _ p o w e r e d   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ t i l e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 4 _ s t a c k - o n _ f r a m e _ f a b r i c ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 4 _ s t a c k - o n _ f r a m e _ g l a s s ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ w o r k s u r f a c e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ o v e r h e a d s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ p e d e s t a l s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ t a s k l i g h t s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ k e y b o a r d _ t r a y s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ w a l l t r a c k   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ d o o r s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 4 _ a c c e s s o r i e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ t y p i c a l   v a r c h a r ( 1 0 0 )   n u l l ,  
 	 t 5 _ w o r k s t a t i o n _ c o u n t   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ d o m i n a n t _ w o r k s t a t i o n   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ b e l t l i n e _ p o w e r   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 5 _ p a n e l s _ n o n - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ p a n e l s _ p o w e r e d   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ t i l e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 5 _ s t a c k - o n _ f r a m e _ f a b r i c ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 5 _ s t a c k - o n _ f r a m e _ g l a s s ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ w o r k s u r f a c e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ o v e r h e a d s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ p e d e s t a l s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ t a s k l i g h t s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ k e y b o a r d _ t r a y s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ w a l l t r a c k   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ d o o r s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 5 _ a c c e s s o r i e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ t y p i c a l   v a r c h a r ( 1 0 0 )   n u l l ,  
 	 t 6 _ w o r k s t a t i o n _ c o u n t   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ d o m i n a n t _ w o r k s t a t i o n   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ b e l t l i n e _ p o w e r   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 6 _ p a n e l s _ n o n - p o w e r e d ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ p a n e l s _ p o w e r e d   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ t i l e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 6 _ s t a c k - o n _ f r a m e _ f a b r i c ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t 6 _ s t a c k - o n _ f r a m e _ g l a s s ]   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ w o r k s u r f a c e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ o v e r h e a d s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ p e d e s t a l s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ t a s k l i g h t s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ k e y b o a r d _ t r a y s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ w a l l t r a c k   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ d o o r s   v a r c h a r ( 2 0 )   n u l l ,  
 	 t 6 _ a c c e s s o r i e s   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 1   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 1   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 2   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 2   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 3   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 3   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 4   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 4   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 5   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 5   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 6   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 6   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 7   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 7   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 8   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 8   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 9   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 9   v a r c h a r ( 2 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ 1 0   v a r c h a r ( 6 0 )   n u l l ,  
 	 o t h e r _ f u r n i t u r e _ c o u n t _ 1 0   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 1   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 2   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 3   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 4   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 5   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 6   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 7   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 8   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 9   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ 1 0   v a r c h a r ( 3 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 1   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 2   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 3   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 4   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 5   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 6   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 7   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 8   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 9   v a r c h a r ( 2 0 )   n u l l ,  
 	 s p e c i f y _ s e r v i c e s _ b i l l _ 1 0   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ p r i c e _ 1   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ p r i c e _ 2   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ p r i c e _ 3   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ p r i c e _ 4   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ p r i c e _ 5   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ p r i c e _ 6   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ e x t e n d e d _ p r i c e _ 1   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ e x t e n d e d _ p r i c e _ 2   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ e x t e n d e d _ p r i c e _ 3   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ e x t e n d e d _ p r i c e _ 4   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ e x t e n d e d _ p r i c e _ 5   v a r c h a r ( 2 0 )   n u l l ,  
 	 t y p i c a l _ e x t e n d e d _ p r i c e _ 6   v a r c h a r ( 2 0 )   n u l l ,  
 	 [ t o t a l - p a n e l s _ n o n - p o w e r e d ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - p a n e l s _ p o w e r e d ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - b e l t l i n e _ p o w e r ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - t i l e s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - s t a c k _ f a b r i c ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - s t a c k _ g l a s s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - w o r k s u r f a c e s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - o v e r h e a d s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - p e d e s t a l s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - t a s k l i g h t s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - k e y b o a r d _ t r a y s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - w a l l t r a c k s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - d o o r s ]   v a r c h a r ( 1 0 )   n u l l ,  
 	 [ t o t a l - a c c e s s o r i e s ]   v a r c h a r ( 1 0 )   n u l l  
 	 )     O N   [ P R I M A R Y ]  
 G O  
 A L T E R   T A B L E   d b o . T m p _ Q U O T E S   A D D   C O N S T R A I N T  
 	 D F _ Q U O T E S _ T A X A B L E _ F L A G   D E F A U L T   ( ' N ' )   F O R   T A X A B L E _ F L A G  
 G O  
 S E T   I D E N T I T Y _ I N S E R T   d b o . T m p _ Q U O T E S   O N  
 G O  
 I F   E X I S T S ( S E L E C T   *   F R O M   d b o . Q U O T E S )  
 	   E X E C ( ' I N S E R T   I N T O   d b o . T m p _ Q U O T E S   ( Q U O T E _ I D ,   R E Q U E S T _ I D ,   I S _ S E N T ,   R E Q U E S T _ T Y P E _ I D ,   Q U O T E _ N O ,   Q U O T E _ T Y P E _ I D ,   Q U O T E _ S T A T U S _ T Y P E _ I D ,   Q U O T E D _ B Y _ U S E R _ I D ,   Q U O T E R S _ T I T L E ,   D E S C R I P T I O N ,   Q U O T E _ T O T A L ,   T A X A B L E _ F L A G ,   T A X A B L E _ A M O U N T ,   W A R E H O U S E _ F E E _ F L A G ,   D A T E _ Q U O T E D ,   D A T E _ P R I N T E D ,   E X T R A _ C O N D I T I O N S ,   D A T E _ C R E A T E D ,   C R E A T E D _ B Y ,   D A T E _ M O D I F I E D ,   M O D I F I E D _ B Y ,   V E R S I O N ,   S U B _ V E R S I O N ,   S Y S T E M S _ S H I P P I N G _ M E T H O D ,   C A S E G O O D S _ S H I P P I N G _ M E T H O D ,   [ S E L E C T _ J O B _ S I T E _ M O V E - S T A G E _ E N V I R O N M E N T ] ,   [ S Y S T E M _ T Y P I C A L _ L I N E - T Y P I C A L 1 ] ,   T Y P I C A L 1 _ W O R K S T A T I O N _ C O U N T ,   O M N I _ B I L L _ S T D _ H O U R S _ D I S C O U N T E D _ B I L L _ R A T E ,   N E T _ E F F E C T I V E _ B I L L I N G _ R A T E _ P E R _ H O U R ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - R E C E I V E ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - R E L O A D ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - T R U C K ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - D R I V E R ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - U N L O A D ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - M O V E _ S T A G E ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - I N S T A L L ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - E L E C T R I C A L ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - T O T A L ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - R E C E I V E ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - R E L O A D ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - T R U C K ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - D R I V E R ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - U N L O A D ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - M O V E _ S T A G E ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - I N S T A L L ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - E L E C T R I C A L ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - T O T A L ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - R E C E I V E ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - R E L O A D ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - T R U C K ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - D R I V E R ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - U N L O A D ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - M O V E - S T A G E ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - I N S T A L L ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - E L E C T R I C A L ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - T O T A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - R E C E I V E ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - R E L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - T R U C K ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - D R I V E R ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - U N L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - M O V E _ S T A G E ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - I N S T A L L ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - E L E C T R I C A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - T O T A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - R E C E I V E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - R E L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - T R U C K ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - D R I V E R ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - U N L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - M O V E _ S T A G E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - I N S T A L L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - E L E C T R I C A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - T O T A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - R E C E I V E ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - R E L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - T R U C K ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - D R I V E R ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - U N L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - M O V E _ S T A G E ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - I N S T A L L ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - E L E C T R I C A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - T O T A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - R E C E I V E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - R E L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - T R U C K ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - D R I V E R ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - U N L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - M O V E _ S T A G E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - I N S T A L L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - E L E C T R I C A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - T O T A L ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - R E C E I V E ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - R E L O A D ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - T R U C K ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - D R I V E R ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - U N L O A D ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - M O V E _ S T A G E ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - I N S T A L L ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - E L E C T R I C A L ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - T O T A L ] ,   T 1 _ T Y P I C A L ,   T 1 _ W O R K S T A T I O N _ C O U N T ,   T 1 _ D O M I N A N T _ W O R K S T A T I O N ,   T 1 _ B E L T L I N E _ P O W E R ,   [ T 1 _ P A N E L S _ N O N - P O W E R E D ] ,   T 1 _ P A N E L S _ P O W E R E D ,   T 1 _ T I L E S ,   [ T 1 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 1 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 1 _ W O R K S U R F A C E S ,   T 1 _ O V E R H E A D S ,   T 1 _ P E D E S T A L S ,   T 1 _ T A S K L I G H T S ,   T 1 _ K E Y B O A R D _ T R A Y S ,   T 1 _ W A L L T R A C K ,   T 1 _ D O O R S ,   T 1 _ A C C E S S O R I E S ,   T 2 _ T Y P I C A L ,   T 2 _ W O R K S T A T I O N _ C O U N T ,   T 2 _ D O M I N A N T _ W O R K S T A T I O N ,   T 2 _ B E L T L I N E _ P O W E R ,   [ T 2 _ P A N E L S _ N O N - P O W E R E D ] ,   [ T 2 _ P A N E L S - P O W E R E D ] ,   T 2 _ T I L E S ,   [ T 2 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 2 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 2 _ W O R K S U R F A C E S ,   T 2 _ O V E R H E A D S ,   T 2 _ P E D E S T A L S ,   T 2 _ T A S K L I G H T S ,   T 2 _ K E Y B O A R D _ T R A Y S ,   T 2 _ W A L L T R A C K ,   T 2 _ D O O R S ,   T 2 _ A C C E S S O R I E S ,   T 3 _ T Y P I C A L ,   T 3 _ W O R K S T A T I O N _ C O U N T ,   T 3 _ D O M I N A N T _ W O R K S T A T I O N ,   T 3 _ B E L T L I N E _ P O W E R ,   [ T 3 _ P A N E L S _ N O N - P O W E R E D ] ,   [ T 3 _ P A N E L S - P O W E R E D ] ,   T 3 _ T I L E S ,   [ T 3 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 3 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 3 _ W O R K S U R F A C E S ,   T 3 _ O V E R H E A D S ,   T 3 _ P E D E S T A L S ,   T 3 _ T A S K L I G H T S ,   T 3 _ K E Y B O A R D _ T R A Y S ,   T 3 _ W A L L T R A C K ,   T 3 _ D O O R S ,   T 3 _ A C C E S S O R I E S ,   T 4 _ T Y P I C A L ,   T 4 _ W O R K S T A T I O N _ C O U N T ,   T 4 _ D O M I N A N T _ W O R K S T A T I O N ,   T 4 _ B E L T L I N E _ P O W E R ,   [ T 4 _ P A N E L S _ N O N - P O W E R E D ] ,   T 4 _ P A N E L S _ P O W E R E D ,   T 4 _ T I L E S ,   [ T 4 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 4 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 4 _ W O R K S U R F A C E S ,   T 4 _ O V E R H E A D S ,   T 4 _ P E D E S T A L S ,   T 4 _ T A S K L I G H T S ,   T 4 _ K E Y B O A R D _ T R A Y S ,   T 4 _ W A L L T R A C K ,   T 4 _ D O O R S ,   T 4 _ A C C E S S O R I E S ,   T 5 _ T Y P I C A L ,   T 5 _ W O R K S T A T I O N _ C O U N T ,   T 5 _ D O M I N A N T _ W O R K S T A T I O N ,   T 5 _ B E L T L I N E _ P O W E R ,   [ T 5 _ P A N E L S _ N O N - P O W E R E D ] ,   T 5 _ P A N E L S _ P O W E R E D ,   T 5 _ T I L E S ,   [ T 5 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 5 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 5 _ W O R K S U R F A C E S ,   T 5 _ O V E R H E A D S ,   T 5 _ P E D E S T A L S ,   T 5 _ T A S K L I G H T S ,   T 5 _ K E Y B O A R D _ T R A Y S ,   T 5 _ W A L L T R A C K ,   T 5 _ D O O R S ,   T 5 _ A C C E S S O R I E S ,   T 6 _ T Y P I C A L ,   T 6 _ W O R K S T A T I O N _ C O U N T ,   T 6 _ D O M I N A N T _ W O R K S T A T I O N ,   T 6 _ B E L T L I N E _ P O W E R ,   [ T 6 _ P A N E L S _ N O N - P O W E R E D ] ,   T 6 _ P A N E L S _ P O W E R E D ,   T 6 _ T I L E S ,   [ T 6 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 6 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 6 _ W O R K S U R F A C E S ,   T 6 _ O V E R H E A D S ,   T 6 _ P E D E S T A L S ,   T 6 _ T A S K L I G H T S ,   T 6 _ K E Y B O A R D _ T R A Y S ,   T 6 _ W A L L T R A C K ,   T 6 _ D O O R S ,   T 6 _ A C C E S S O R I E S ,   O T H E R _ F U R N I T U R E _ 1 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 1 ,   O T H E R _ F U R N I T U R E _ 2 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 2 ,   O T H E R _ F U R N I T U R E _ 3 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 3 ,   O T H E R _ F U R N I T U R E _ 4 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 4 ,   O T H E R _ F U R N I T U R E _ 5 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 5 ,   O T H E R _ F U R N I T U R E _ 6 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 6 ,   O T H E R _ F U R N I T U R E _ 7 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 7 ,   O T H E R _ F U R N I T U R E _ 8 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 8 ,   O T H E R _ F U R N I T U R E _ 9 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 9 ,   O T H E R _ F U R N I T U R E _ 1 0 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 1 0 ,   S P E C I F Y _ S E R V I C E S _ 1 ,   S P E C I F Y _ S E R V I C E S _ 2 ,   S P E C I F Y _ S E R V I C E S _ 3 ,   S P E C I F Y _ S E R V I C E S _ 4 ,   S P E C I F Y _ S E R V I C E S _ 5 ,   S P E C I F Y _ S E R V I C E S _ 6 ,   S P E C I F Y _ S E R V I C E S _ 7 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 1 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 2 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 3 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 4 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 5 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 6 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 7 ,   T Y P I C A L _ P R I C E _ 1 ,   T Y P I C A L _ P R I C E _ 2 ,   T Y P I C A L _ P R I C E _ 3 ,   T Y P I C A L _ P R I C E _ 4 ,   T Y P I C A L _ P R I C E _ 5 ,   T Y P I C A L _ P R I C E _ 6 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 1 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 2 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 3 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 4 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 5 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 6 ,   [ T O T A L - P A N E L S _ N O N - P O W E R E D ] ,   [ T O T A L - P A N E L S _ P O W E R E D ] ,   [ T O T A L - B E L T L I N E _ P O W E R ] ,   [ T O T A L - T I L E S ] ,   [ T O T A L - S T A C K _ F A B R I C ] ,   [ T O T A L - S T A C K _ G L A S S ] ,   [ T O T A L - W O R K S U R F A C E S ] ,   [ T O T A L - O V E R H E A D S ] ,   [ T O T A L - P E D E S T A L S ] ,   [ T O T A L - T A S K L I G H T S ] ,   [ T O T A L - K E Y B O A R D _ T R A Y S ] ,   [ T O T A L - W A L L T R A C K S ] ,   [ T O T A L - D O O R S ] ,   [ T O T A L - A C C E S S O R I E S ] )  
 	 	 S E L E C T   Q U O T E _ I D ,   R E Q U E S T _ I D ,   I S _ S E N T ,   R E Q U E S T _ T Y P E _ I D ,   Q U O T E _ N O ,   Q U O T E _ T Y P E _ I D ,   Q U O T E _ S T A T U S _ T Y P E _ I D ,   Q U O T E D _ B Y _ U S E R _ I D ,   Q U O T E R S _ T I T L E ,   D E S C R I P T I O N ,   Q U O T E _ T O T A L ,   T A X A B L E _ F L A G ,   T A X A B L E _ A M O U N T ,   W A R E H O U S E _ F E E _ F L A G ,   D A T E _ Q U O T E D ,   D A T E _ P R I N T E D ,   E X T R A _ C O N D I T I O N S ,   D A T E _ C R E A T E D ,   C R E A T E D _ B Y ,   D A T E _ M O D I F I E D ,   M O D I F I E D _ B Y ,   V E R S I O N ,   S U B _ V E R S I O N ,   S Y S T E M S _ S H I P P I N G _ M E T H O D ,   C A S E G O O D S _ S H I P P I N G _ M E T H O D ,   [ S E L E C T _ J O B _ S I T E _ M O V E - S T A G E _ E N V I R O N M E N T ] ,   [ S Y S T E M _ T Y P I C A L _ L I N E - T Y P I C A L 1 ] ,   T Y P I C A L 1 _ W O R K S T A T I O N _ C O U N T ,   O M N I _ B I L L _ S T D _ H O U R S _ D I S C O U N T E D _ B I L L _ R A T E ,   N E T _ E F F E C T I V E _ B I L L I N G _ R A T E _ P E R _ H O U R ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - R E C E I V E ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - R E L O A D ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - T R U C K ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - D R I V E R ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - U N L O A D ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - M O V E _ S T A G E ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - I N S T A L L ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - E L E C T R I C A L ] ,   [ R O C _ O M N I _ D I S C O U N T E D _ H O U R S - T O T A L ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - R E C E I V E ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - R E L O A D ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - T R U C K ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - D R I V E R ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - U N L O A D ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - M O V E _ S T A G E ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - I N S T A L L ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - E L E C T R I C A L ] ,   [ R O C _ I N D U S T R Y _ S T D _ B I L L - T O T A L ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - R E C E I V E ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - R E L O A D ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - T R U C K ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - D R I V E R ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - U N L O A D ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - M O V E - S T A G E ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - I N S T A L L ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - E L E C T R I C A L ] ,   [ R O C _ O M N I _ D I R E C T _ C O S T - T O T A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - R E C E I V E ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - R E L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - T R U C K ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - D R I V E R ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - U N L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - M O V E _ S T A G E ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - I N S T A L L ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - E L E C T R I C A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ H O U R S - T O T A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - R E C E I V E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - R E L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - T R U C K ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - D R I V E R ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - U N L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - M O V E _ S T A G E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - I N S T A L L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - E L E C T R I C A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ H O U R S - T O T A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - R E C E I V E ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - R E L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - T R U C K ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - D R I V E R ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - U N L O A D ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - M O V E _ S T A G E ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - I N S T A L L ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - E L E C T R I C A L ] ,   [ I N D _ I N D U S T R Y _ S T D _ B I L L - T O T A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - R E C E I V E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - R E L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - T R U C K ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - D R I V E R ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - U N L O A D ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - M O V E _ S T A G E ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - I N S T A L L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - E L E C T R I C A L ] ,   [ I N D _ O M N I _ D I S C O U N T E D _ B I L L - T O T A L ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - R E C E I V E ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - R E L O A D ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - T R U C K ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - D R I V E R ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - U N L O A D ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - M O V E _ S T A G E ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - I N S T A L L ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - E L E C T R I C A L ] ,   [ I N D _ O M N I _ D I R E C T _ C O S T - T O T A L ] ,   T 1 _ T Y P I C A L ,   T 1 _ W O R K S T A T I O N _ C O U N T ,   T 1 _ D O M I N A N T _ W O R K S T A T I O N ,   T 1 _ B E L T L I N E _ P O W E R ,   [ T 1 _ P A N E L S _ N O N - P O W E R E D ] ,   T 1 _ P A N E L S _ P O W E R E D ,   T 1 _ T I L E S ,   [ T 1 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 1 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 1 _ W O R K S U R F A C E S ,   T 1 _ O V E R H E A D S ,   T 1 _ P E D E S T A L S ,   T 1 _ T A S K L I G H T S ,   T 1 _ K E Y B O A R D _ T R A Y S ,   T 1 _ W A L L T R A C K ,   T 1 _ D O O R S ,   T 1 _ A C C E S S O R I E S ,   T 2 _ T Y P I C A L ,   T 2 _ W O R K S T A T I O N _ C O U N T ,   T 2 _ D O M I N A N T _ W O R K S T A T I O N ,   T 2 _ B E L T L I N E _ P O W E R ,   [ T 2 _ P A N E L S _ N O N - P O W E R E D ] ,   [ T 2 _ P A N E L S - P O W E R E D ] ,   T 2 _ T I L E S ,   [ T 2 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 2 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 2 _ W O R K S U R F A C E S ,   T 2 _ O V E R H E A D S ,   T 2 _ P E D E S T A L S ,   T 2 _ T A S K L I G H T S ,   T 2 _ K E Y B O A R D _ T R A Y S ,   T 2 _ W A L L T R A C K ,   T 2 _ D O O R S ,   T 2 _ A C C E S S O R I E S ,   T 3 _ T Y P I C A L ,   T 3 _ W O R K S T A T I O N _ C O U N T ,   T 3 _ D O M I N A N T _ W O R K S T A T I O N ,   T 3 _ B E L T L I N E _ P O W E R ,   [ T 3 _ P A N E L S _ N O N - P O W E R E D ] ,   [ T 3 _ P A N E L S - P O W E R E D ] ,   T 3 _ T I L E S ,   [ T 3 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 3 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 3 _ W O R K S U R F A C E S ,   T 3 _ O V E R H E A D S ,   T 3 _ P E D E S T A L S ,   T 3 _ T A S K L I G H T S ,   T 3 _ K E Y B O A R D _ T R A Y S ,   T 3 _ W A L L T R A C K ,   T 3 _ D O O R S ,   T 3 _ A C C E S S O R I E S ,   T 4 _ T Y P I C A L ,   T 4 _ W O R K S T A T I O N _ C O U N T ,   T 4 _ D O M I N A N T _ W O R K S T A T I O N ,   T 4 _ B E L T L I N E _ P O W E R ,   [ T 4 _ P A N E L S _ N O N - P O W E R E D ] ,   T 4 _ P A N E L S _ P O W E R E D ,   T 4 _ T I L E S ,   [ T 4 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 4 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 4 _ W O R K S U R F A C E S ,   T 4 _ O V E R H E A D S ,   T 4 _ P E D E S T A L S ,   T 4 _ T A S K L I G H T S ,   T 4 _ K E Y B O A R D _ T R A Y S ,   T 4 _ W A L L T R A C K ,   T 4 _ D O O R S ,   T 4 _ A C C E S S O R I E S ,   T 5 _ T Y P I C A L ,   T 5 _ W O R K S T A T I O N _ C O U N T ,   T 5 _ D O M I N A N T _ W O R K S T A T I O N ,   T 5 _ B E L T L I N E _ P O W E R ,   [ T 5 _ P A N E L S _ N O N - P O W E R E D ] ,   T 5 _ P A N E L S _ P O W E R E D ,   T 5 _ T I L E S ,   [ T 5 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 5 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 5 _ W O R K S U R F A C E S ,   T 5 _ O V E R H E A D S ,   T 5 _ P E D E S T A L S ,   T 5 _ T A S K L I G H T S ,   T 5 _ K E Y B O A R D _ T R A Y S ,   T 5 _ W A L L T R A C K ,   T 5 _ D O O R S ,   T 5 _ A C C E S S O R I E S ,   T 6 _ T Y P I C A L ,   T 6 _ W O R K S T A T I O N _ C O U N T ,   T 6 _ D O M I N A N T _ W O R K S T A T I O N ,   T 6 _ B E L T L I N E _ P O W E R ,   [ T 6 _ P A N E L S _ N O N - P O W E R E D ] ,   T 6 _ P A N E L S _ P O W E R E D ,   T 6 _ T I L E S ,   [ T 6 _ S T A C K - O N _ F R A M E _ F A B R I C ] ,   [ T 6 _ S T A C K - O N _ F R A M E _ G L A S S ] ,   T 6 _ W O R K S U R F A C E S ,   T 6 _ O V E R H E A D S ,   T 6 _ P E D E S T A L S ,   T 6 _ T A S K L I G H T S ,   T 6 _ K E Y B O A R D _ T R A Y S ,   T 6 _ W A L L T R A C K ,   T 6 _ D O O R S ,   T 6 _ A C C E S S O R I E S ,   O T H E R _ F U R N I T U R E _ 1 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 1 ,   O T H E R _ F U R N I T U R E _ 2 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 2 ,   O T H E R _ F U R N I T U R E _ 3 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 3 ,   O T H E R _ F U R N I T U R E _ 4 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 4 ,   O T H E R _ F U R N I T U R E _ 5 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 5 ,   O T H E R _ F U R N I T U R E _ 6 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 6 ,   O T H E R _ F U R N I T U R E _ 7 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 7 ,   O T H E R _ F U R N I T U R E _ 8 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 8 ,   O T H E R _ F U R N I T U R E _ 9 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 9 ,   O T H E R _ F U R N I T U R E _ 1 0 ,   O T H E R _ F U R N I T U R E _ C O U N T _ 1 0 ,   S P E C I F Y _ S E R V I C E S _ 1 ,   S P E C I F Y _ S E R V I C E S _ 2 ,   S P E C I F Y _ S E R V I C E S _ 3 ,   S P E C I F Y _ S E R V I C E S _ 4 ,   S P E C I F Y _ S E R V I C E S _ 5 ,   S P E C I F Y _ S E R V I C E S _ 6 ,   S P E C I F Y _ S E R V I C E S _ 7 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 1 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 2 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 3 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 4 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 5 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 6 ,   S P E C I F Y _ S E R V I C E S _ B I L L _ 7 ,   T Y P I C A L _ P R I C E _ 1 ,   T Y P I C A L _ P R I C E _ 2 ,   T Y P I C A L _ P R I C E _ 3 ,   T Y P I C A L _ P R I C E _ 4 ,   T Y P I C A L _ P R I C E _ 5 ,   T Y P I C A L _ P R I C E _ 6 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 1 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 2 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 3 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 4 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 5 ,   T Y P I C A L _ E X T E N D E D _ P R I C E _ 6 ,   [ T O T A L - P A N E L S _ N O N - P O W E R E D ] ,   [ T O T A L - P A N E L S _ P O W E R E D ] ,   [ T O T A L - B E L T L I N E _ P O W E R ] ,   [ T O T A L - T I L E S ] ,   [ T O T A L - S T A C K _ F A B R I C ] ,   [ T O T A L - S T A C K _ G L A S S ] ,   [ T O T A L - W O R K S U R F A C E S ] ,   [ T O T A L - O V E R H E A D S ] ,   [ T O T A L - P E D E S T A L S ] ,   [ T O T A L - T A S K L I G H T S ] ,   [ T O T A L - K E Y B O A R D _ T R A Y S ] ,   [ T O T A L - W A L L T R A C K S ] ,   [ T O T A L - D O O R S ] ,   [ T O T A L - A C C E S S O R I E S ]   F R O M   d b o . Q U O T E S   W I T H   ( H O L D L O C K   T A B L O C K X ) ' )  
 G O  
 S E T   I D E N T I T Y _ I N S E R T   d b o . T m p _ Q U O T E S   O F F  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E _ C O N D I T I O N S  
 	 D R O P   C O N S T R A I N T   F K _ Q C _ Q U O T E S  
 G O  
 D R O P   T A B L E   d b o . Q U O T E S  
 G O  
 E X E C U T E   s p _ r e n a m e   N ' d b o . T m p _ Q U O T E S ' ,   N ' Q U O T E S ' ,   ' O B J E C T '    
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   A D D   C O N S T R A I N T  
 	 P K _ Q U O T E S   P R I M A R Y   K E Y   C L U S T E R E D    
 	 (  
 	 Q U O T E _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ Q U O T E _ R E Q U E S T S   O N   d b o . Q U O T E S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ Q U O T E _ S T A T U S E S   O N   d b o . Q U O T E S  
 	 (  
 	 Q U O T E _ S T A T U S _ T Y P E _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ Q U O T E _ R E Q U E S T _ T Y P E S   O N   d b o . Q U O T E S  
 	 (  
 	 R E Q U E S T _ T Y P E _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 C R E A T E   N O N C L U S T E R E D   I N D E X   I X _ Q U O T E _ U S E R S   O N   d b o . Q U O T E S  
 	 (  
 	 Q U O T E D _ B Y _ U S E R _ I D  
 	 )   W I T H (   P A D _ I N D E X   =   O F F ,   F I L L F A C T O R   =   9 0 ,   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ R E Q U E S T _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ T Y P E S   F O R E I G N   K E Y  
 	 (  
 	 Q U O T E _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ S T A T U S E S   F O R E I G N   K E Y  
 	 (  
 	 Q U O T E _ S T A T U S _ T Y P E _ I D  
 	 )   R E F E R E N C E S   d b o . L O O K U P S  
 	 (  
 	 L O O K U P _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ R E Q U E S T S   F O R E I G N   K E Y  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   R E F E R E N C E S   d b o . R E Q U E S T S  
 	 (  
 	 R E Q U E S T _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ U S E R S   F O R E I G N   K E Y  
 	 (  
 	 Q U O T E D _ B Y _ U S E R _ I D  
 	 )   R E F E R E N C E S   d b o . U S E R S  
 	 (  
 	 U S E R _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ U S E R S _ C   F O R E I G N   K E Y  
 	 (  
 	 C R E A T E D _ B Y  
 	 )   R E F E R E N C E S   d b o . U S E R S  
 	 (  
 	 U S E R _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q U O T E _ U S E R S _ M   F O R E I G N   K E Y  
 	 (  
 	 M O D I F I E D _ B Y  
 	 )   R E F E R E N C E S   d b o . U S E R S  
 	 (  
 	 U S E R _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 B E G I N   T R A N S A C T I O N  
 G O  
 A L T E R   T A B L E   d b o . Q U O T E _ C O N D I T I O N S   W I T H   N O C H E C K   A D D   C O N S T R A I N T  
 	 F K _ Q C _ Q U O T E S   F O R E I G N   K E Y  
 	 (  
 	 Q U O T E _ I D  
 	 )   R E F E R E N C E S   d b o . Q U O T E S  
 	 (  
 	 Q U O T E _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
 C O M M I T  
 