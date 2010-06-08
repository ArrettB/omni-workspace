/*
==============================================================================
SCRIPT CREATED BY:
	Olsen Thielen Technologies, Inc.
	Your Trusted Business Solutions Partner
	www.ottechnologies.com

STORED PROCEDURE NAME:
	ott_spGetPrimaryAddress

REASON FOR SCRIPT:
	Get the primary address from the customer master table

EXECUTION SAMPLE:
	DECLARE @CUSTOMERID CHAR(15)
	
	-- Set parameters here
	

	EXEC ott_spGetPrimaryAddress @CUSTOMERID

REVISION HISTORY:
	DATE	BY		CHANGE DESCRIPTION
	27May10	CBRUELS	Created Stored Procedure Script
	06Jun10 PGARVIE Modified Stored Procedure 

*/
--Drop Stored Procedures
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ott_spGetPrimaryAddress]') 
and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ott_spGetPrimaryAddress]
GO
CREATE PROCEDURE ott_spGetPrimaryAddress
	@CustomerID			char(15) /*Customer. REQUIRED.*/
AS
SET NOCOUNT ON

SELECT CNTCPRSN, ADDRESS1, ADDRESS2, CITY, STATE, ZIP, COUNTRY 
FROM RM00102
WHERE CUSTNMBR = @CustomerID 
	AND ADRSCODE = 'PRIMARY'

SET NOCOUNT OFF
GO
GRANT  EXECUTE  ON [dbo].[ott_spGetPrimaryAddress]  TO [DYNGRP]
GO
