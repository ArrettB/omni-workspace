/ *  
       A d d   m i s s i n g   p r i m a r y   k e y .  
       A d d   m i s s i n g   f o r e i g n   k e y   f r o m   F u n c t i o n s   t o   T e m p l a t e   L o c a t i o n s .  
 * /  
  
 A L T E R   T A B L E   d b o . T E M P L A T E _ L O C A T I O N S   A D D   C O N S T R A I N T  
 	 P K _ T E M P L A T E _ L O C A T I O N S   P R I M A R Y   K E Y   C L U S T E R E D    
 	 (  
 	 T E M P L A T E _ L O C A T I O N _ I D  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
  
 G O  
  
 A L T E R   T A B L E   d b o . F U N C T I O N S   A D D   C O N S T R A I N T  
 	 F K _ F U N C T I O N S _ T E M P L A T E _ L O C A T I O N S   F O R E I G N   K E Y  
 	 (  
 	 T E M P L A T E _ L O C A T I O N _ I D  
 	 )   R E F E R E N C E S   d b o . T E M P L A T E _ L O C A T I O N S  
 	 (  
 	 T E M P L A T E _ L O C A T I O N _ I D  
 	 )   O N   U P D A T E     N O   A C T I O N    
 	   O N   D E L E T E     N O   A C T I O N    
 	  
 G O  
  
 