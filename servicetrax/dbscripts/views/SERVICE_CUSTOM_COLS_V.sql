CREATE VIEW dbo.SERVICE_CUSTOM_COLS_V
AS
SELECT     dbo.SERVICES.JOB_ID, dbo.SERVICES.SERVICE_ID, dbo.SERVICES.CUST_COL_1 AS col1_value, CUSTOM_COL_LISTS_1.LIST_VALUE AS col1_lookup, 
                      dbo.SERVICES.CUST_COL_2 AS col2_value, CUSTOM_COL_LISTS_2.LIST_VALUE AS col2_lookup, dbo.SERVICES.CUST_COL_3 AS col3_value, 
                      CUSTOM_COL_LISTS_3.LIST_VALUE AS col3_lookup, dbo.SERVICES.CUST_COL_4 AS col4_value, 
                      CUSTOM_COL_LISTS_4.LIST_VALUE AS col4_lookup, dbo.SERVICES.CUST_COL_5 AS col5_value, 
                      CUSTOM_COL_LISTS_5.LIST_VALUE AS col5_lookup, dbo.SERVICES.CUST_COL_6 AS col6_value, 
                      CUSTOM_COL_LISTS_6.LIST_VALUE AS col6_lookup, dbo.SERVICES.CUST_COL_7 AS col7_value, 
                      CUSTOM_COL_LISTS_7.LIST_VALUE AS col7_lookup, dbo.SERVICES.CUST_COL_8 AS col8_value, 
                      CUSTOM_COL_LISTS_8.LIST_VALUE AS col8_lookup, dbo.SERVICES.CUST_COL_9 AS col9_value, 
                      CUSTOM_COL_LISTS_9.LIST_VALUE AS col9_lookup, dbo.SERVICES.CUST_COL_10 AS col10_value, 
                      CUSTOM_COL_LISTS_10.LIST_VALUE AS col10_lookup
FROM         dbo.SERVICES INNER JOIN
                      dbo.JOBS ON dbo.SERVICES.JOB_ID = dbo.JOBS.JOB_ID LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_10 ON 
                      dbo.SERVICES.CUST_COL_10 = CAST(CUSTOM_COL_LISTS_10.CUSTOM_COL_LIST_ID AS varchar) LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_9 ON dbo.SERVICES.CUST_COL_9 = CAST(CUSTOM_COL_LISTS_9.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_8 ON dbo.SERVICES.CUST_COL_8 = CAST(CUSTOM_COL_LISTS_8.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_7 ON dbo.SERVICES.CUST_COL_7 = CAST(CUSTOM_COL_LISTS_7.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_6 ON dbo.SERVICES.CUST_COL_6 = CAST(CUSTOM_COL_LISTS_6.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_5 ON dbo.SERVICES.CUST_COL_5 = CAST(CUSTOM_COL_LISTS_5.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_4 ON dbo.SERVICES.CUST_COL_4 = CAST(CUSTOM_COL_LISTS_4.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_3 ON dbo.SERVICES.CUST_COL_3 = CAST(CUSTOM_COL_LISTS_3.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_2 ON dbo.SERVICES.CUST_COL_2 = CAST(CUSTOM_COL_LISTS_2.CUSTOM_COL_LIST_ID AS varchar)
                       LEFT OUTER JOIN
                      dbo.CUSTOM_COL_LISTS CUSTOM_COL_LISTS_1 ON dbo.SERVICES.CUST_COL_1 = CAST(CUSTOM_COL_LISTS_1.CUSTOM_COL_LIST_ID AS varchar)


