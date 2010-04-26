CREATE VIEW dbo.CUSTOM_CUST_COLUMNS_V
AS
SELECT     dbo.CUSTOMERS_V.CUSTOMER_ID, dbo.CUSTOMERS_V.PARENT_CUSTOMER_ID, dbo.CUSTOMERS_V.ORGANIZATION_ID, 
                      dbo.CUSTOMERS_V.EXT_DEALER_ID, dbo.CUSTOMERS_V.DEALER_NAME, dbo.CUSTOMERS_V.EXT_CUSTOMER_ID, 
                      dbo.CUSTOMERS_V.CUSTOMER_NAME, COL1.COLUMN_DESC AS col1, COL1.ACTIVE_FLAG AS col1_active_flag, 
                      COL1.IS_MANDATORY AS col1_is_mandatory, COL1.IS_DROPLIST AS col1_is_droplist, COL2.COLUMN_DESC AS col2, 
                      COL2.ACTIVE_FLAG AS col2_active_flag, COL2.IS_MANDATORY AS col2_is_mandatory, COL2.IS_DROPLIST AS col2_is_droplist, 
                      COL3.COLUMN_DESC AS col3, COL3.ACTIVE_FLAG AS col3_active_flag, COL3.IS_MANDATORY AS col3_is_mandatory, 
                      COL3.IS_DROPLIST AS col3_is_droplist, COL4.COLUMN_DESC AS col4, COL4.ACTIVE_FLAG AS col4_active_flag, 
                      COL4.IS_MANDATORY AS col4_is_mandatory, COL4.IS_DROPLIST AS col4_is_droplist, COL5.COLUMN_DESC AS col5, 
                      COL5.ACTIVE_FLAG AS col5_active_flag, COL5.IS_MANDATORY AS col5_is_mandatory, COL5.IS_DROPLIST AS col5_is_droplist, 
                      COL6.COLUMN_DESC AS col6, COL6.ACTIVE_FLAG AS col6_active_flag, COL6.IS_MANDATORY AS col6_is_mandatory, 
                      COL6.IS_DROPLIST AS col6_is_droplist, COL7.COLUMN_DESC AS col7, COL7.ACTIVE_FLAG AS col7_active_flag, 
                      COL7.IS_MANDATORY AS col7_is_mandatory, COL7.IS_DROPLIST AS col7_is_droplist, COL8.COLUMN_DESC AS col8, 
                      COL8.ACTIVE_FLAG AS col8_active_flag, COL8.IS_MANDATORY AS col8_is_mandatory, COL8.IS_DROPLIST AS col8_is_droplist, 
                      COL9.COLUMN_DESC AS col9, COL9.ACTIVE_FLAG AS col9_active_flag, COL9.IS_MANDATORY AS col9_is_mandatory, 
                      COL9.IS_DROPLIST AS col9_is_droplist, COL10.COLUMN_DESC AS col10, COL10.ACTIVE_FLAG AS col10_active_flag, 
                      COL10.IS_MANDATORY AS col10_is_mandatory, COL10.IS_DROPLIST AS col10_is_droplist
FROM         dbo.CUSTOM_CUST_COLUMNS COL10 RIGHT OUTER JOIN
                      dbo.CUSTOMERS_V ON COL10.CUSTOMER_ID = dbo.CUSTOMERS_V.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL9 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL9.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL8 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL8.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL7 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL7.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL6 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL6.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL5 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL5.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL4 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL4.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL3 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL3.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL2 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL2.CUSTOMER_ID LEFT OUTER JOIN
                      dbo.CUSTOM_CUST_COLUMNS COL1 ON dbo.CUSTOMERS_V.CUSTOMER_ID = COL1.CUSTOMER_ID
WHERE     (COL1.COL_SEQUENCE = 1) AND (COL2.COL_SEQUENCE = 2) AND (COL3.COL_SEQUENCE = 3) AND (COL4.COL_SEQUENCE = 4) AND 
                      (COL5.COL_SEQUENCE = 5) AND (COL6.COL_SEQUENCE = 6) AND (COL7.COL_SEQUENCE = 7) AND (COL8.COL_SEQUENCE = 8) AND 
                      (COL9.COL_SEQUENCE = 9) AND (COL10.COL_SEQUENCE = 10)



