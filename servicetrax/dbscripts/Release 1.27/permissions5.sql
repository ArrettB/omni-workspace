/ *  
       A d d   m i s s i n g   u n i q u e   C O D E   e n t r i e s   f o r   F u n c t i o n s ,   F u n c t i o n _ G r o u p s ,   R o l e s ,   a n d   R i g h t _ T y p e s .    
       A d d   m i s s i n g   u n i q u e   R o l e ,   F u n c t i o n   a n d   R i g h t   T y p e   e n t r i e s   f o r   R o l e _ F u n c t i o n _ R i g h t s .  
 * /  
  
 A L T E R   T A B L E   d b o . F U N C T I O N S   A D D   C O N S T R A I N T  
 	 U K _ F U _ C O D E   U N I Q U E   N O N C L U S T E R E D    
 	 (  
 	 C O D E  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
  
  
 A L T E R   T A B L E   d b o . F U N C T I O N _ G R O U P S   A D D   C O N S T R A I N T  
 	 U K _ F G _ C O D E   U N I Q U E   N O N C L U S T E R E D    
 	 (  
 	 C O D E  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
  
 A L T E R   T A B L E   d b o . R O L E S   A D D   C O N S T R A I N T  
 	 U K _ R O _ C O D E   U N I Q U E   N O N C L U S T E R E D    
 	 (  
 	 C O D E  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
  
  
 A L T E R   T A B L E   d b o . R I G H T _ T Y P E S   A D D   C O N S T R A I N T  
 	 U K _ R T _ C O D E   U N I Q U E   N O N C L U S T E R E D    
 	 (  
 	 C O D E  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
  
 A L T E R   T A B L E   d b o . R O L E _ F U N C T I O N _ R I G H T S   A D D   C O N S T R A I N T  
 	 U K _ R F R   U N I Q U E   N O N C L U S T E R E D    
 	 (  
 	 R O L E _ I D ,  
 	 F U N C T I O N _ I D ,  
 	 R I G H T _ T Y P E _ I D  
 	 )   W I T H (   S T A T I S T I C S _ N O R E C O M P U T E   =   O F F ,   I G N O R E _ D U P _ K E Y   =   O F F ,   A L L O W _ R O W _ L O C K S   =   O N ,   A L L O W _ P A G E _ L O C K S   =   O N )   O N   [ P R I M A R Y ]  
 G O  
 