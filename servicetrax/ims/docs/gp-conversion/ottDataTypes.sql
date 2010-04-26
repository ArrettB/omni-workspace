/*
==============================================================================
SCRIPT CREATED BY:
Olsen Thielen Technologies, Inc.
Your Trusted Business Solutions Partner
www.ottechnologies.com

TABLE NAME:
ottDataTypes

REASON FOR SCRIPT:
Populates the ottDataTypes Table

DATE SCRIPT CREATED:
6/6/2007

AUTHOR:
NT_DOMAIN\OlsoMR

REVISION HISTORY:
DATE		BY						Ver					CHANGE DESCRIPTION
6/6/2007    NT_DOMAIN\OlsoMR							Created Table Script
6/8/2007    Olsomr										Added isnull's to all statements, and linked to ottCompanyInfo table.  Added create script before prepopulation
06/15/2007	DRAGRA										Added column MasterTableName
07/02/2007	dragra										Added column LowercaseAllowed
==============================================================================
*/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ottDataTypes]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [dbo].[ottDataTypes]
GO
CREATE TABLE [dbo].[ottDataTypes](
	[DataTypeID] [varchar](10) NOT NULL,
	[DataTypeName] [varchar](50) NULL,
	[PhysicalDBView] [varchar](50) NULL,
	[PrimaryKeyField1] [varchar](50) NULL,
	[PrimaryKeyField2] [varchar](50) NULL,
	[DescriptionField] [varchar](50) NULL,
	[MasterTableName] [varchar](50) NULL,
	[MappingForm] [varchar](50) NULL CONSTRAINT [DF_ottDataTypes_MappingForm]  DEFAULT (''),
	[DisplaySortOrder] [decimal](18, 2) NULL CONSTRAINT [DF__ottDataTy__Displ__1E9D9A43]  DEFAULT ((0)),
	[TotalToLink] [int] NULL CONSTRAINT [DF__ottDataTy__Total__1F91BE7C]  DEFAULT ((0)),
	[NumberLinked] [int] NULL CONSTRAINT [DF__ottDataTy__Numbe__2085E2B5]  DEFAULT ((0)),
	[RemainingToLink] [int] NULL CONSTRAINT [DF__ottDataTy__Remai__217A06EE]  DEFAULT ((0)),
	[AllowMerge] [bit] NULL CONSTRAINT [DF__ottDataTy__Allow__226E2B27]  DEFAULT ((0)),
	[GetNextIDType] [smallint] NULL,
	[GetNextIDSprocName] [varchar](50) NULL,
	[GetNextIDNextNumber] [varchar](50) NULL,
	[ScriptLine] [text] NULL,
	[Hidden] [bit] NULL,
	[LowercaseAllowed] [bit] NULL,
	[ParentDataTypeID] [varchar](10) NULL,
	[KeyableLength] [int] NULL,
	[CreateStoredProcName] [char](50) NULL,
 CONSTRAINT [aaaaaottDataTypes_PK] PRIMARY KEY NONCLUSTERED 
(
	[DataTypeID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[ottDataTypes]') AND name = N'DataTypeID')
CREATE NONCLUSTERED INDEX [DataTypeID] ON [dbo].[ottDataTypes] 
(
	[DataTypeID] ASC
) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[ottDataTypes]') AND name = N'NumberLinked')
CREATE NONCLUSTERED INDEX [NumberLinked] ON [dbo].[ottDataTypes] 
(
	[NumberLinked] ASC
) ON [PRIMARY]
GO
GRANT SELECT,INSERT,UPDATE,DELETE ON [dbo].[ottDataTypes] TO [DataCleanupUser]
GO
GRANT SELECT,INSERT,UPDATE,DELETE ON [dbo].[ottDataTypes] TO [DYNGRP]
GO
INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('ACCTS', 'GL Accounts', 'ott_vwDCGLAccounts', 'ACTNUMST', NULL, 'ACTDESCR', 'GL00105', 'MapGLAccounts', 1.00, 40824, 34365, 6459, 1, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' as DBName,GL00105.ACTNUMST, 
	ottCompanyInfo.DBStatus as DBType, CASE ottDataMapping.MappingType	
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus, ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
GL00100.ACTALIAS, GL00102.ACCATDSC, 
                      CASE GL00100.ACCTTYPE WHEN 1 THEN ''Posting Account'' WHEN 2 THEN ''Unit Account'' WHEN 3 THEN ''Posting Allocation Account'' WHEN 4 THEN ''Unit Allocation Account''
                       END AS ACCTTYPE, GL00100.ACTDESCR, CASE GL00100.PSTNGTYP WHEN 0 THEN ''Balance Sheet'' ELSE ''Profit and Loss'' END AS PSTNGTYP, 
                      CASE GL00100.ACTIVE WHEN 1 THEN ''True'' ELSE ''False'' END ACTIVE, CASE GL00100.TPCLBLNC WHEN 0 THEN ''Debit'' ELSE ''Credit'' END TPCLBLNC, GL00100.DECPLACS, GL00100.USERDEF1, GL00100.USERDEF2, GL00100.USRDEFS1, GL00100.USRDEFS2, 
                      CASE GL00100.ACCTENTR WHEN 1 THEN ''True'' ELSE ''False'' END ACCTENTR
FROM         %CompanyDBName%.dbo.GL00100 GL00100 
INNER JOIN %CompanyDBName%.dbo.GL00105 GL00105 ON GL00100.ACTINDX = GL00105.ACTINDX 
INNER JOIN %CompanyDBName%.dbo.GL00102 GL00102 ON GL00100.ACCATNUM = GL00102.ACCATNUM
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON RTRIM(GL00105.ACTNUMST) = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''ACCTS'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 128, 'ott_spMstr_GLAccounts                             ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('CHECK', 'Checkbook IDs', 'ott_vwDCCheckBooks', 'CHEKBKID', NULL, 'DSCRIPTN', 'CM00100', 'MapCheckbookIDs', 1.00, 32, 32, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, CM00100.CHEKBKID, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus, ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
		CM00100.DSCRIPTN, CM00100.BANKID, CM00100.CURNCYID, CM00100.BNKACTNM, CM00100.NXTCHNUM, 
                      CM00100.Next_Deposit_Number, CASE CM00100.INACTIVE WHEN 0 THEN ''False'' ELSE ''True'' END INACTIVE, CM00100.LOCATNID, CM00100.CMUSRDF1, 
                      CM00100.CMUSRDF2, CM00100.Last_Reconciled_Date, CM00100.Last_Reconciled_Balance, CM00100.CURRBLNC, CM00100.CMPANYID, 
                      CASE CM00100.CHKBKTYP WHEN 1 THEN ''Savings'' WHEN 2 THEN ''Checking'' ELSE ''N/A'' END CHKBKTYP, CM00100.DDACTNUM, CM00100.DDINDNAM, CM00100.DDTRANS, CM00100.PaymentRateTypeID, 
                      CM00100.DepositRateTypeID, GL00105.ACTNUMST CashAccount, GL00100.ACTDESCR CashAccountDesc,isnull(CashAccountBalance,0) CashAccountBalance
FROM         %CompanyDBName%.dbo.CM00100 CM00100 INNER JOIN
                      %CompanyDBName%.dbo.GL00100 GL00100 ON CM00100.ACTINDX = GL00100.ACTINDX INNER JOIN
                      %CompanyDBName%.dbo.GL00105 GL00105 ON CM00100.ACTINDX = GL00105.ACTINDX
LEFT OUTER JOIN (SELECT ACTINDX,SUM(perdblnc) CashAccountBalance FROM %CompanyDBName%.dbo.GL10110 GL10110 GROUP BY ACTINDX) AccountSummary ON
cm00100.ACTINDX = accountsummary.ACTINDX
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON CM00100.CHEKBKID = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''CHECK'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_CheckBooks                             ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('CREDIT', 'Credit Card IDs', 'ott_vwDCCreditCards', 'CARDNAME', NULL, 'CARDNAME', 'SY03100', 'MapCreditCardIDs', 1.00, 2, 2, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, SY03100.CARDNAME, 
	DBStatus as DBType,
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	CASE SY03100.PYBLGRBX WHEN 0 THEN ''Credit Card'' ELSE ''Check Card'' END AS PYBLGRBX, 
                      CASE SY03100.RCVBGRBX WHEN 0 THEN ''Bank Card'' ELSE ''Charge Card'' END AS RCVBGRBX, 
                      CASE SY03100.CBPAYBLE WHEN 1 THEN ''True'' ELSE ''False'' END AS UsedByCompany, 
                      CASE SY03100.CBRCVBLE WHEN 1 THEN ''True'' ELSE ''False'' END AS AcceptedByCustomers, SY03100.CKBKNUM1, SY03100.CKBKNUM2, 
                      SY03100.VENDORID, ISNULL(GL00100.ACTDESCR, '''') AS ACTDESC, ISNULL(GL00105.ACTNUMST, '''') AS ACTNUMST
FROM         %CompanyDBName%.dbo.SY03100 SY03100 LEFT OUTER JOIN
                      %CompanyDBName%.dbo.GL00105 GL00105 ON SY03100.ACTINDX = GL00105.ACTINDX LEFT OUTER JOIN
                      %CompanyDBName%.dbo.GL00100 GL00100 ON SY03100.ACTINDX = GL00100.ACTINDX
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON SY03100.CARDNAME = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''CREDIT'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 1, NULL, 15, 'ott_spMstr_CreditCards                            ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('CUST', 'Customers', 'ott_vwDCCustomer', 'CUSTNMBR', NULL, 'CUSTNAME', 'RM00101', 'MapCustomers', 5.20, 1862, 542, 1320, 1, 1, 'ott_spDCRMGetNextCustomerID', NULL, 'SELECT  ''%CompanyDBName%'' AS DBName, Cust.CUSTNMBR, --Primary Key
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus, ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	Cust.CUSTNAME, Cust.CUSTCLAS, Cust.CNTCPRSN, Cust.STMTNAME, Cust.SHRTNAME, Cust.ADRSCODE, 
	Cust.SHIPMTHD, Cust.TAXSCHID, Cust.ADDRESS1, Cust.ADDRESS2, Cust.ADDRESS3, Cust.COUNTRY, Cust.CCode, Cust.CITY, Cust.STATE, Cust.ZIP, 
	Cust.PHONE1, Cust.PHONE2, Cust.PHONE3, Cust.FAX, Cust.PRBTADCD, Cust.PRSTADCD, Cust.STADDRCD, Cust.SLPRSNID, Cust.SALSTERR, 
	Cust.PYMTRMID, Cust.CRLMTTYP, Cust.CRLMTAMT, Cust.CRLMTPER, Cust.PRCLEVEL, Cust.COMMENT1, Cust.COMMENT2, Cust.USERDEF1, 
	Cust.USERDEF2, Cust.TAXEXMT1, Cust.INACTIVE, Cust.HOLD, Cust.CREATDDT, Cust.MODIFDT,
	CustSum.CUSTBLNC, CustSum.LSTTRXDT, CustSum.LSTTRXAM, CAST(SUM(ISNULL(CustSumYr.SMRYSALS, 0)) as Numeric(19,5)) AS Sales2YrsAgo, 
	CustSum.TTLSLLYR as SalesLastYear, CustSum.TTLSLYTD as SalesYTD
FROM %CompanyDBName%.dbo.RM00101 Cust
LEFT OUTER JOIN %CompanyDBName%.dbo.RM00103 CustSum ON Cust.CUSTNMBR = CustSum.CUSTNMBR
LEFT OUTER JOIN %CompanyDBName%.dbo.RM00104 CustSumYr ON Cust.CUSTNMBR = CustSumYr.CUSTNMBR AND CustSumYr.YEAR1 = %FiscalYear%
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON Cust.CUSTNMBR = ottDataMapping.PrimaryKeyField1
	AND ottDataMapping.DataTypeID = ''CUST'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''
GROUP BY ottDataMapping.MappingType, Cust.CUSTNMBR, Cust.CUSTNAME, Cust.CUSTCLAS, Cust.CNTCPRSN, Cust.STMTNAME, Cust.SHRTNAME, Cust.ADRSCODE, Cust.SHIPMTHD, 
	Cust.TAXSCHID, Cust.ADDRESS1, Cust.ADDRESS2, Cust.ADDRESS3, Cust.COUNTRY, Cust.CCode, Cust.CITY, Cust.STATE, Cust.ZIP, Cust.PHONE1, 
	Cust.PHONE2, Cust.PHONE3, Cust.FAX, Cust.PRBTADCD, Cust.PRSTADCD, Cust.STADDRCD, Cust.SLPRSNID, Cust.SALSTERR, Cust.PYMTRMID, 
	Cust.CRLMTTYP, Cust.CRLMTAMT, Cust.CRLMTPER, Cust.PRCLEVEL, Cust.COMMENT1, Cust.COMMENT2, Cust.USERDEF1, Cust.USERDEF2, 
	Cust.TAXEXMT1, Cust.INACTIVE, Cust.HOLD, Cust.CREATDDT, Cust.MODIFDT, CustSum.CUSTBLNC, CustSum.LSTTRXDT, CustSum.LSTTRXAM, 
	CustSum.TTLSLLYR, CustSum.TTLSLYTD, ottDataMapping.MergeWithINTERID, ottDataMapping.MergeWithPKField1, ottDataMapping.MergeWithPKField2,
	ottDataMapping.NewPKField1,ottDataMapping.NewPKField2,
	ottCompanyInfo.DBStatus

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_Customer                               ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('CUSTADDR', 'Customer Addresses', 'ott_vwDCCustomerAddress', 'CUSTNMBR', 'ADRSCODE', 'ADDRESS1', 'RM00102', 'MapCustomerAddresses', 5.30, 27, 1, 26, 0, 0, NULL, NULL, 'SELECT  ''%CompanyDBName%'' AS DBName, CustAddr.CUSTNMBR, CustAddr.ADRSCODE, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END
		END as LinkingStatus, 
	ParentStatus.ChildrenMapped,ParentStatus.MappingType as ParentMappingType,
	ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	Cust.CUSTNAME, CustAddr.CNTCPRSN,  
	CustAddr.SHIPMTHD, CustAddr.TAXSCHID, CustAddr.ADDRESS1, CustAddr.ADDRESS2, CustAddr.ADDRESS3, CustAddr.COUNTRY, CustAddr.CCode, CustAddr.CITY, CustAddr.STATE, CustAddr.ZIP, 
	CustAddr.PHONE1, CustAddr.PHONE2, CustAddr.PHONE3, CustAddr.FAX, CustAddr.SLPRSNID, CustAddr.SALSTERR, 
	CustAddr.USERDEF1, CustAddr.USERDEF2
FROM         %CompanyDBName%.dbo.RM00102 CustAddr
INNER JOIN %CompanyDBName%.dbo.RM00101 Cust ON Cust.CUSTNMBR = CustAddr.CUSTNMBR
INNER JOIN DYNAMICS..ottDataMapping ParentStatus ON CustAddr.CUSTNMBR = ParentStatus.PrimaryKeyField1 
	AND ParentStatus.DataTypeID = ''CUST'' AND ParentStatus.INTERID = ''%CompanyDBName%''
	AND ParentStatus.MappingType IN (1, 2)	--Keep and Linked only
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON CustAddr.CUSTNMBR = ottDataMapping.PrimaryKeyField1 
	AND CustAddr.ADRSCODE = ottDataMapping.PrimaryKeyField2 
	AND ottDataMapping.DataTypeID = ''CUSTADDR'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, 'CUST', 15, 'ott_spMstr_CustomerAddress                        ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('CUSTCLASS', 'Customer Class IDs', 'ott_vwDCCustomerClass', 'CLASSID', NULL, 'CLASDSCR', 'RM00201', 'MapCustomerClasses', 5.10, 56, 56, 0, 0, 0, NULL, NULL, 'SELECT    ''%CompanyDBName%'' AS DBName, CustClass.CLASSID, 
	DBStatus as DBType,
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus, ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	CustClass.CLASDSCR, CustClass.CRLMTTYP, CustClass.CRLMTAMT, CustClass.CRLMTPER, CustClass.CRLMTPAM, CustClass.BALNCTYP, 
	CustClass.PYMTRMID, CustClass.SHIPMTHD, CustClass.TAXSCHID, CustClass.SLPRSNID, CustClass.SALSTERR, CustClass.CSTPRLVL
FROM %CompanyDBName%.dbo.RM00201 CustClass
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON CustClass.CLASSID = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''CUSTCLASS'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_CustomerClass                          ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('ITEM', 'Items', 'ott_vwDCItems', 'ITEMNMBR', NULL, 'ITEMDESC', 'IV00101', 'MapItems', 4.20, 2580, 13, 2567, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, ITEMNMBR, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	ITEMDESC, ITMSHNAM, 
                      CASE ITEMTYPE WHEN 1 THEN ''Sales Inventory'' WHEN 2 THEN ''Discontinued'' WHEN 3 THEN ''Kit'' WHEN 4 THEN ''Misc Charges'' WHEN 5 THEN ''Services''
                       WHEN 6 THEN ''Flat Fee'' END AS ITEMTYPE, ITMGEDSC, STNDCOST, CURRCOST, ITEMSHWT / 100.0 AS ITEMSHWT, DECPLQTY, DECPLCUR, 
                      ITMTSHID, CASE TAXOPTNS WHEN 1 THEN ''Taxable'' WHEN 2 THEN ''Nontaxable'' WHEN 3 THEN ''Base on customers'' END AS taxoptns, ITMCLSCD, 
                      CASE ITMTRKOP WHEN 1 THEN ''None'' WHEN 2 THEN ''Serial Numbers'' WHEN 3 THEN ''Lot Numbers'' END AS ITMTRKOP, LOTTYPE, 
                      CASE ALWBKORD WHEN 0 THEN ''False'' WHEN 1 THEN ''True'' END AS ALWBKORD, 
                      CASE VCTNMTHD WHEN 1 THEN ''FIFO Perpetual'' WHEN 2 THEN ''LIFO Perpetual'' WHEN 3 THEN ''Average Perpetual'' WHEN 4 THEN ''FIFO Periodic'' WHEN
                       5 THEN ''LIFO Periodic'' END AS VCTNMTHD, UOMSCHDL, USCATVLS_1, USCATVLS_2, USCATVLS_3, USCATVLS_4, USCATVLS_5, USCATVLS_6, 
                      PRCLEVEL, LOCNCODE, WRNTYDYS, 
                      CASE PRICMTHD WHEN 1 THEN ''Currency Amount'' WHEN 2 THEN ''% of List Price'' WHEN 3 THEN ''% Markup - Current Cost'' WHEN 4 THEN ''% Markup - Standard Cost''
                       WHEN 5 THEN ''% Margin - Current Cost'' WHEN 6 THEN ''% Margin - Standard Cost'' ELSE '''' END AS PRICMTHD, PriceGroup,
                      CASE INACTIVE WHEN 0 THEN ''False'' WHEN 1 THEN ''True'' END AS INACTIVE, 
                      CASE INCLUDEINDP WHEN 0 THEN ''False'' WHEN 1 THEN ''True'' END AS INCLUDEINDP
FROM         %CompanyDBName%.dbo.IV00101 IV00101
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON IV00101.ITEMNMBR = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''ITEM'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 30, 'ott_spMstr_Items                                  ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('ITEMCLASS', 'Item Class IDs', 'ott_vwDCItemClasses', 'ITMCLSCD', NULL, 'ITMCLSDC', 'IV40400', 'MapItemClasses', 4.10, 124, 123, 1, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, ITMCLSCD, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	ITMCLSDC, CASE DEFLTCLS WHEN 0 THEN ''False'' WHEN 1 THEN ''True'' END AS DefaultClass, CASE ITEMTYPE WHEN 1 THEN ''Sales Inventory'' WHEN 2 THEN ''Discontinued'' WHEN 3 THEN ''Kit'' WHEN 4 THEN ''Misc Charges'' WHEN 5 THEN ''Services''
                       WHEN 6 THEN ''Flat Fee'' END AS ITEMTYPE, CASE ITMTRKOP WHEN 1 THEN ''None'' WHEN 2 THEN ''Serial Numbers'' WHEN 3 THEN ''Lot Numbers'' END AS TrackingOption, LOTTYPE, CASE ALWBKORD WHEN 0 THEN ''False'' WHEN 1 THEN ''True'' END AS AllowBackOrder,
                       ITMGEDSC AS GenericDescription, CASE TAXOPTNS WHEN 1 THEN ''Taxable'' WHEN 2 THEN ''Nontaxable'' WHEN 3 THEN ''Base on customers'' END AS TaxOptions, ITMTSHID AS TaxScheduleID, CASE Purchase_Tax_Options WHEN 1 THEN ''Taxable'' WHEN 2 THEN ''Nontaxable'' WHEN 3 THEN ''Base on vendor'' END  AS PurchaseTaxOption, 
                      Purchase_Item_Tax_Schedu AS PurchaseTaxScheduleID, UOMSCHDL AS UofMSchedule, CASE VCTNMTHD WHEN 1 THEN ''FIFO Perpetual'' WHEN 2 THEN ''LIFO Perpetual'' WHEN 3 THEN ''Average Perpetual'' WHEN 4 THEN ''FIFO Periodic'' WHEN
                       5 THEN ''LIFO Periodic'' END AS ValuationMethod, 
                      USCATVLS_1 AS UserDefined1, USCATVLS_2 AS UserDefined2, USCATVLS_3 AS UserDefined3, USCATVLS_4 AS UserDefined4, 
                      USCATVLS_5 AS UserDefined5, USCATVLS_6 AS UserDefined6, DECPLQTY AS QuantityDecimals, PRCLEVEL AS DefaultPriceLevel, PriceGroup, 
                      CASE PRICMTHD WHEN 1 THEN ''Currency Amount'' WHEN 2 THEN ''% of List Price'' WHEN 3 THEN ''% Markup - Current Cost'' WHEN 4 THEN ''% Markup - Standard Cost''
                       WHEN 5 THEN ''% Margin - Current Cost'' WHEN 6 THEN ''% Margin - Standard Cost'' ELSE '''' END AS PricingMethod, CASE INCLUDEINDP WHEN 0 THEN ''False'' WHEN 1 THEN ''True'' END AS IncludeInDemandPlanning
FROM         %CompanyDBName%.dbo.IV40400 IV40400
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON IV40400.ITMCLSCD = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''ITEMCLASS'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 10, 'ott_spMstr_ItemClasses                            ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('PAYTERMS', 'Payment Terms IDs', 'ott_vwDCPaymentTerms', 'PYMTRMID', NULL, 'PYMTRMID', 'SY03300', 'MapPayTermsIDs', 3.00, 145, 27, 118, 0, 0, NULL, NULL, 'SELECT  ''%CompanyDBName%'' AS DBName, PYMTRMID, 
	DBStatus as DBType, --To Be linked
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
CASE DUETYPE WHEN 1 THEN ''Net Days'' WHEN 2 THEN ''Date'' WHEN 3 THEN ''EOM'' WHEN 4 THEN ''None'' WHEN 5 THEN ''Next Month'' END DueType, DUEDTDS AS DueDateDays, 
CASE DISCTYPE WHEN 1 THEN ''Days'' WHEN 2 THEN ''Date'' WHEN 3 THEN ''EOM'' WHEN 4 THEN ''None'' END AS DiscountType, DISCDTDS AS DiscountDateDays, 
CASE DSCLCTYP WHEN 1 THEN ''Percent'' WHEN 2 THEN ''Amount'' END AS DiscountCalculateType,
        DSCDLRAM AS DiscountDollarAmount, DSCPCTAM/100.0 AS DiscountPercentAmount, 
				CASE SALPURCH
         WHEN 1 THEN ''Sale/Purchase''
         WHEN 0 THEN case discntcb
                       WHEN 1 THEN ''Discount''
                       WHEN 0 THEN CASE Freight
                                     WHEN 1 THEN ''Freight''
                                     WHEN 0 THEN CASE Misc
                                                   WHEN 1 THEN ''Misc''
                                                   WHEN 0 THEN CASE tax
                                                                 WHEN 1 THEN ''Tax''
                                                                 ELSE ''''
                                                               END
                                                 END
                                   END
                     END
       END CalculateDiscountOn, CASE USEGRPER WHEN 1 THEN ''True'' WHEN 0 THEN ''False'' END AS UseGracePeriods
FROM    %CompanyDBName%.dbo.SY03300 SY03300
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON SY03300.PYMTRMID = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''PAYTERMS'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 1, NULL, 20, 'ott_spMstr_PaymentTerms                           ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('SALESREP', 'Sales Reps', 'ott_vwDCSalesReps', 'SLPRSNID', NULL, 'SLPRSNID', 'RM00301', 'MapSalesReps', 3.00, 1, 1, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, SLPRSNID, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	EMPLOYID, VENDORID, SLPRSNFN AS SalesPersonFirstName, SPRSNSMN AS SalesPersonMiddleName, 
                      SPRSNSLN AS SalesPersonLastName, ADDRESS1, ADDRESS2, ADDRESS3, CITY, STATE, ZIP, COUNTRY, PHONE1, PHONE2, PHONE3, FAX, 
                      CASE INACTIVE WHEN 1 THEN ''True'' WHEN 0 THEN ''False'' END INACTIVE, SALSTERR AS SalesTerritory, COMMCODE AS CommissionCode, COMPRCNT/100.0 AS CommissionPercent, 
                      STDCPRCT AS StandardCommissionPercent, CASE COMAPPTO WHEN 0 THEN ''Sales'' WHEN 1 THEN ''Total Invoice'' END AS ComissionAppliedTo, COSTTODT AS CostToDate, CSTLSTYR AS CostLastYear, 
                      TTLCOMTD AS TotalCommissionsToDate, TTLCOMLY AS TotalComissionsLastYear, COMSLTDT AS CommissionedSalesToDate, 
                      COMSLLYR AS CommissionedSalesLastYear, NCOMSLTD AS NonCommissionedSalesToDate, NCOMSLYR AS NonComissionedSalesLastYear, 
                      CASE KPCALHST WHEN 1 THEN ''True'' ELSE ''False'' END AS KeepCalendarHistory, CASE KPERHIST WHEN 1 THEN ''True'' ELSE ''False'' END AS KeepPeriodHistory
FROM         %CompanyDBName%.dbo.RM00301 RM00301
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON RM00301.SLPRSNID = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''SALESREP'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_SalesReps                              ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('SALESTERR', 'Sales Territories', 'ott_vwDCSalesTerritories', 'SALSTERR', NULL, 'SLTERDSC', 'RM00303', 'MapTerritoryIDs', 3.00, 1, 1, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, SALSTERR, 
	DBStatus as DBType,
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	SLTERDSC, CASE INACTIVE WHEN 0 THEN ''False'' WHEN 1 THEN ''True'' END INACTIVE, SLPRSNID, STMGRFNM AS SalesTerritoryManagersFirstName, 
                      STMGRMNM AS SalesTerritoryManagersMiddleName, STMGRLNM AS SalesTerritoryManagersLastName, COUNTRY, COSTTODT AS CostToDate, 
                      TTLCOMTD AS TotalCommissionsToDate, TTLCOMLY AS TotalCommissionsLastYear, NCOMSLYR AS NonCommissionedSalesLastYear, 
                      COMSLLYR AS CommissionedSalesLastYear, CSTLSTYR AS CostLastYear, COMSLTDT AS CommissionedSalesToDate, 
                      NCOMSLTD AS NonCommissionedSalesToDate, CASE KPCALHST WHEN 1 THEN ''True'' WHEN 0 THEN ''False'' END AS KeepCalendarHistory, CASE KPERHIST WHEN 1 THEN ''True'' WHEN 0 THEN ''False'' END AS KeepPeriodHistory
FROM         %CompanyDBName%.dbo.RM00303 RM00303
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON RM00303.SALSTERR = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''SALESTERR'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_SalesTerritories                       ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('SHIPMETH', 'Shipping Methods', 'ott_vwDCShippingMethods', 'SHIPMTHD', NULL, 'SHMTHDSC', 'SY03000', 'MapShipMethods', 3.00, 721, 7, 714, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, SHIPMTHD, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	SHMTHDSC, PHONNAME PhoneNumber, CONTACT, CARRACCT CarrierAccount, CARRIER, CASE SHIPTYPE WHEN 1 THEN ''Delivery'' WHEN 0 THEN ''Pickup'' END ShipType
FROM         %CompanyDBName%.dbo.SY03000 SY03000
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON SY03000.SHIPMTHD = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''SHIPMETH'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_ShippingMethods                        ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('TAXDETAIL', 'Tax Detail IDs', 'ott_vwDCTaxDetails', 'TAXDTLID', NULL, 'TXDTLDSC', 'TX00201', 'MapTaxDetailIDs', 2.00, 47, 47, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, TX00201.TAXDTLID, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	TX00201.TXDTLDSC, CASE TX00201.TXDTLTYP WHEN 1 THEN ''Sales'' WHEN 2 THEN ''Purchases'' END AS TaxDetailType, 
                      TX00201.TXIDNMBR AS TaxIDNumber, 
                      CASE TX00201.TXDTLBSE WHEN 1 THEN ''Tax Included with Item Price'' WHEN 2 THEN ''Flat Amount per Unit'' WHEN 3 THEN ''Percent of Sale/Purchase''
                       WHEN 4 THEN ''Percent of Cost'' WHEN 5 THEN ''Percent of Another Tax Detail'' WHEN 6 THEN ''Percent of Sale/Purchase plus Tax'' END AS TaxDetailBase,
                       TX00201.TXDTLPCT AS TaxDetailPercent, TX00201.TXDTLAMT AS TaxDetailAmount, 
                      CASE TX00201.TDTLRNDG WHEN 1 THEN ''Up to the Next Currency Decimal Digit'' WHEN 2 THEN ''To the Nearest Currency Decimal Digit'' WHEN 3 THEN
                       ''Down to the Previous Currency Decimal Digit'' WHEN 4 THEN ''Up to the Next Whole Digit'' WHEN 5 THEN ''To the Nearest Whole Digit'' WHEN 6 THEN ''Down to the Previous Whole Digit''
                       END AS TaxDetailRounding, TX00201.TXDBODTL AS TaxDetailBasedOnDetailID, TX00201.TDTABMIN AS TaxDetailTaxableMinimum, 
                      TX00201.TDTABMAX AS TaxDetailTaxableMaximum, TX00201.TDTAXMIN AS TaxDetailTaxMinimum, TX00201.TDTAXMAX AS TaxDetailTaxMaximum, 
                      CASE TX00201.TDRNGTYP WHEN 1 THEN ''Full Amount'' WHEN 2 THEN ''Amount within Range'' END AS TaxDetailRangeType, 
                      CASE TX00201.TXDTQUAL + TX00201.TXDTLBSE WHEN 4 THEN ''Unit Amount'' WHEN 7 THEN ''Unit Amount Plus Taxable Taxes'' ELSE '''' END AS TaxDetailBaseQualifiers,
                       CASE TX00201.TDTAXTAX WHEN 1 THEN ''True'' ELSE ''False'' END AS TaxDetailTaxableTax, 
                      CASE TX00201.TXDTLPDC WHEN 1 THEN ''True'' ELSE ''False'' END AS TaxDetailPrintOnDocuments, TX00201.TXDTLPCH AS TaxDetailprintCharacter, 
                      CASE TX00201.TXDXDISC WHEN 1 THEN ''True'' ELSE ''False'' END AS TaxDetailExcludeDiscounts, TX00201.CMNYTXID AS CompanyTaxID, 
                      TX00201.NAME, TX00201.CNTCPRSN AS ContactPerson, TX00201.ADDRESS1, TX00201.ADDRESS2, TX00201.ADDRESS3, TX00201.CITY, 
                      TX00201.STATE, TX00201.ZIPCODE, TX00201.COUNTRY, TX00201.PHONE1, TX00201.PHONE2, TX00201.PHONE3, TX00201.FAX, 
                      TX00201.TXUSRDF1 AS UserDefined1, TX00201.TXUSRDF2 AS UserDefined2, TX00201.TDTABPCT AS TaxDetailTaxablePercent, 
                      ISNULL(GL00105.ACTNUMST, '''') AS ACTNUMST, ISNULL(GL00100.ACTDESCR, '''') AS ACTDESCR, TX00202.TDTSYTD AS TotalSalesOrPurchasesYTD, 
                      TX00202.TDSLLYTD AS TotalSalesOrPurchasesLastYear, TX00202.TXDTSYTD AS TaxableSalesOrPurchasesYTD, 
                      TX00202.TDTSLYTD AS TaxableSalesOrPurchasesLastYear, TX00202.TXDSTYTD AS SalesOrPurchasesTaxesYTD, 
                      TX00202.TDSTLYTD AS SalesOrPurchasesTaxesLastYear
FROM         %CompanyDBName%.dbo.TX00201 TX00201 INNER JOIN
                      %CompanyDBName%.dbo.TX00202 TX00202 ON TX00201.TAXDTLID = TX00202.TAXDTLID LEFT OUTER JOIN
                      %CompanyDBName%.dbo.GL00105 GL00105 ON TX00201.ACTINDX = GL00105.ACTINDX LEFT OUTER JOIN
                      %CompanyDBName%.dbo.GL00100 GL00100 ON TX00201.ACTINDX = GL00100.ACTINDX
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON TX00201.TAXDTLID = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''TAXDETAIL'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_TaxDetails                             ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('TAXSCHED', 'Tax Schedule IDs', 'ott_vwDCTaxSchedules', 'TAXSCHID', NULL, 'TXSCHDSC', 'TX00101', 'MapTaxSchedules', 2.00, 40, 39, 1, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, TAXSCHID, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
		TXSCHDSC
FROM         %CompanyDBName%.dbo.TX00101 TX00101
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON TX00101.TAXSCHID = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''TAXSCHED'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_TaxSchedules                           ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('VEND', 'Vendors', 'ott_vwDCVendors', 'VENDORID', NULL, 'VENDNAME', 'PM00200', 'MapVendors', 6.20, 3704, 788, 2916, 0, 1, 'ott_spDCPMGetNextVendorID', NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, PM00200.VENDORID, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus, ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
PM00200.VENDNAME, PM00200.VNDCHKNM AS VendorCheckName, PM00200.VENDSHNM AS VendorShortName, 
                      PM00200.VADDCDPR AS PrimaryAddressCode, PM00200.VADCDPAD AS PurchaseAddressCode, PM00200.VADCDSFR AS ShipFromAddressCode, 
                      PM00200.VADCDTRO AS RemitToAddressCode, PM00200.VNDCLSID AS VendorClassID, PM00200.VNDCNTCT AS VendorContact, PM00200.ADDRESS1, 
                      PM00200.ADDRESS2, PM00200.ADDRESS3, PM00200.CITY, PM00200.STATE, PM00200.ZIPCODE, PM00200.COUNTRY, 
                      PM00200.PHNUMBR1 AS Phone1, PM00200.PHNUMBR2 AS Phone2, PM00200.PHONE3, PM00200.FAXNUMBR, PM00200.UPSZONE, 
                      PM00200.SHIPMTHD AS ShippingMethod, PM00200.TAXSCHID, PM00200.ACNMVNDR AS AccountNumberWithVendor, 
                      PM00200.TXIDNMBR AS TaxIDNumber, 
                      CASE VENDSTTS WHEN 1 THEN ''Active'' WHEN 2 THEN ''Inactive'' WHEN 3 THEN ''Temporary'' END AS VendorStatus, PM00200.CURNCYID, 
                      PM00200.TXRGNNUM AS TaxRegistrationNumber, PM00200.PARVENID AS ParentVendorID, PM00200.TRDDISCT / 100.0 AS TradeDiscountPercent, 
                      CASE TEN99TYPE WHEN 1 THEN ''Not a 1099 Vendor'' WHEN 2 THEN ''Dividend'' WHEN 3 THEN ''Interest'' WHEN 4 THEN ''Miscellaneous'' END AS [1099Type],
                       PM00200.MINORDER AS MinimumOrder, PM00200.PYMTRMID AS PaymentTermsID, 
                      CASE MINPYTYP WHEN 0 THEN ''No Minimum'' WHEN 1 THEN ''Percent'' WHEN 2 THEN ''Amount'' END AS MinimumPaymentType, 
                      PM00200.MINPYPCT / 100.0 AS MinimumPaymentPercent, PM00200.MINPYDLR AS MinimumPaymentDollar, 
                      CASE MXIAFVND WHEN 0 THEN ''No Maximum'' WHEN 1 THEN ''Amount'' END AS MaximumInvoiceAmountForVendors, 
                      PM00200.MAXINDLR AS MaximumInvoiceDollar, PM00200.COMMENT1, PM00200.COMMENT2, PM00200.USERDEF1, PM00200.USERDEF2, 
                      PM00200.CRLMTDLR AS CreditLimitDollar, PM00200.PYMNTPRI AS PaymentPriority, CASE HOLD WHEN 1 THEN ''True'' ELSE ''False'' END AS HOLD, 
                      CASE CREDTLMT WHEN 0 THEN ''No Credit'' WHEN 1 THEN ''Unlimited'' WHEN 2 THEN ''Amount'' END AS CreditLimit, 
                      CASE WRITEOFF WHEN 0 THEN ''Not Allowed'' WHEN 1 THEN ''Unlimited'' WHEN 2 THEN ''Maximum'' END AS WRITEOFF, 
                      PM00200.MXWOFAMT AS MaximumWriteOffAmount, PM00200.CHEKBKID, PM00200.RATETPID AS RateTypeID, 
                      CASE FREEONBOARD WHEN 1 THEN ''None'' WHEN 2 THEN ''Origin'' WHEN 3 THEN ''Destination'' END AS FREEONBOARD, 
                      PM00200.GOVCRPID AS GovernmentalCorporateID, PM00200.GOVINDID AS GovernmentalInvidividualID, 
                      PM00200.DISGRPER AS DiscountGracePeriodDays, PM00200.DUEGRPER AS DueDateGracePeriodDays, PM00200.MODIFDT, PM00200.CREATDDT,
					PM00201.CURRBLNC AS CurrentBalance,
					PM00201.ONORDAMT AS OnOrderAmount,
					PM00201.LSTPURDT AS LastPurchaseDate, 
					PM00201.LSTINVAM AS LastInvoiceAmount,
					PM00201.NOINVYTD AS NumberOfInvoicesYTD, 
					PM00201.NOINVLYR AS NumberOfInvoicesLYR,
					PM00201.NOINVLIF AS NumberOfInvoicesLIFE, 
					PM00201.LSTCHKDT AS LastCheckDate, 
					PM00201.LSTCHAMT AS LastCheckAmount
FROM         %CompanyDBName%.dbo.PM00200 PM00200 LEFT OUTER JOIN
                      %CompanyDBName%.dbo.PM00201 PM00201 ON PM00200.VENDORID = PM00201.VENDORID
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON PM00200.VENDORID = ottDataMapping.PrimaryKeyField1 
	AND ottDataMapping.DataTypeID = ''VEND'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 15, 'ott_spMstr_Vendors                                ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('VENDADDR', 'Vendor Addresses', 'ott_vwDCVendorAddresses', 'VENDORID', 'ADRSCODE', 'ADDRESS1', 'PM00300', 'MapVendorAddresses', 6.30, 9, 8, 1, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, PM00300.VENDORID, PM00300.ADRSCODE,
	DBStatus as DBType,
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END
		END as LinkingStatus, 
	ParentStatus.ChildrenMapped,ParentStatus.MappingType as ParentMappingType, 
ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
PM00200.VENDNAME,  PM00300.VNDCNTCT, PM00300.ADDRESS1, PM00300.ADDRESS2, PM00300.ADDRESS3, PM00300.CITY, PM00300.STATE, PM00300.ZIPCODE, PM00300.COUNTRY, PM00300.UPSZONE, PM00300.PHNUMBR1, PM00300.PHNUMBR2, 
                      PM00300.PHONE3, PM00300.FAXNUMBR, PM00300.SHIPMTHD, PM00300.TAXSCHID
FROM         %CompanyDBName%.dbo.PM00300 PM00300
INNER JOIN %CompanyDBName%.dbo.PM00200 PM00200 ON PM00200.VENDORID = PM00300.VENDORID
INNER JOIN DYNAMICS..ottDataMapping ParentStatus ON PM00300.VENDORID = ParentStatus.PrimaryKeyField1 
	AND ParentStatus.DataTypeID = ''VEND'' AND ParentStatus.INTERID = ''%CompanyDBName%''
	AND ParentStatus.MappingType IN (1, 2)	--Keep and Linked only
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON PM00300.VENDORID = ottDataMapping.PrimaryKeyField1 
	AND PM00300.ADRSCODE = ottDataMapping.PrimaryKeyField2
	AND ottDataMapping.DataTypeID = ''VENDADDR'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, 'VEND', 15, 'ott_spMstr_VendorAddresses                        ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('VENDCLASS', 'Vendor Class IDs', 'ott_vwDCVendorClasses', 'VNDCLSID', NULL, 'VNDCLDSC', 'PM00100', 'MapVendorClasses', 6.10, 71, 71, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, VNDCLSID, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus,  ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	VNDCLDSC, case DEFLTCLS when 1 then ''True'' else ''False'' END AS DefaultClass, CASE MXIAFVND WHEN 0 THEN ''No Maximum'' WHEN 1 THEN ''Amount'' END AS MaximumInvoiceAmountForVendors, MXINVAMT AS MaximumInvoiceAmount, 
                      CASE WRITEOFF WHEN 0 THEN ''Not Allowed'' WHEN 1 THEN ''Unlimited'' WHEN 2 THEN ''Maximum'' END AS WRITEOFF, CASE CREDTLMT WHEN 0 THEN ''No Credit'' WHEN 1 THEN ''Unlimited'' WHEN 2 THEN ''Amount'' END AS CreditLimit, CASE TEN99TYPE WHEN 1 THEN ''Not a 1099 Vendor'' WHEN 2 THEN ''Dividend'' WHEN 3 THEN ''Interest'' WHEN 4 THEN ''Miscellaneous'' END AS [1099Type], 
MXWOFAMT AS MaximumWriteOffAmount, MINORDER AS MinimumOrder, 
                      CRLMTDLR AS CreditLimitDollar, PYMNTPRI AS PaymentPriority, SHIPMTHD AS ShippingMethod, PYMTRMID AS PaymentTermsID, 
                      CASE MINPYTYP WHEN 0 THEN ''No Minimum'' WHEN 1 THEN ''Percent'' WHEN 2 THEN ''Amount'' END AS MinimumPaymentType, MINPYDLR AS MinimumPaymentDollar, MINPYPCT/100.0 AS MinimumPaymentPercent, CURNCYID, TAXSCHID, 
                      TRDDISCT/100.0 AS TradeDiscount, USERDEF1, USERDEF2, CHEKBKID, RATETPID AS RateTypeID, CASE FREEONBOARD WHEN 1 THEN ''None'' WHEN 2 THEN ''Origin'' WHEN 3 THEN ''Destination'' END AS FREEONBOARD, 
                      DISGRPER AS DiscountGracePeriodDays, DUEGRPER AS DueDateGracePeriodDays
FROM         %CompanyDBName%.dbo.PM00100 PM00100
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON PM00100.VNDCLSID = ottDataMapping.PrimaryKeyField1
	AND ottDataMapping.DataTypeID = ''VENDCLASS'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 0, 0, NULL, 10, 'ott_spMstr_VendorClasses                          ')
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('TAXSCDTL', 'Tax Schedule Details', 'ott_vwDCTaxScheduleDetails', 'TAXSCHID', 'TAXDTLID', 'TAXSCHID', 'TX00102', NULL, 0.00, 0, 0, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName, TX00102.TAXSCHID, TX00102.TAXDTLID,
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END END as LinkingStatus, ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
		TX00101.TXSCHDSC, TX00201.TXDTLDSC, TX00102.TXDTLBSE, TX00102.TDTAXTAX, 
                      TX00102.Auto_Calculate
FROM         %CompanyDBName%.dbo.TX00102 TX00102 INNER JOIN
                      %CompanyDBName%.dbo.TX00101 TX00101 ON TX00102.TAXSCHID = TX00101.TAXSCHID INNER JOIN
                      %CompanyDBName%.dbo.TX00201 TX00201 ON TX00102.TAXDTLID = TX00201.TAXDTLID
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON TX00102.TAXSCHID = ottDataMapping.PrimaryKeyField1 
	AND TX00102.TAXDTLID = ottDataMapping.PrimaryKeyField2 
	AND ottDataMapping.DataTypeID = ''TAXSCDTL'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 1, 0, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('CUSTADRALL', 'Customer Addresses (All)', 'ott_vwDCCustomerAddressAllStatus', 'CUSTNMBR', 'ADRSCODE', 'ADDRESS1', 'RM00102', NULL, 0.00, 0, 0, 0, 0, 0, NULL, NULL, 'SELECT  ''%CompanyDBName%'' AS DBName, CustAddr.CUSTNMBR, CustAddr.ADRSCODE, 
	DBStatus as DBType, 
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
			else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END 
		END as LinkingStatus, 
	ISNULL(ParentStatus.ChildrenMapped,0) as ChildrenMapped,ISNULL(ParentStatus.MappingType,0) as ParentMappingType,
	ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
	Cust.CUSTNAME, CustAddr.CNTCPRSN,  
	CustAddr.SHIPMTHD, CustAddr.TAXSCHID, CustAddr.ADDRESS1, CustAddr.ADDRESS2, CustAddr.ADDRESS3, CustAddr.COUNTRY, CustAddr.CCode, CustAddr.CITY, CustAddr.STATE, CustAddr.ZIP, 
	CustAddr.PHONE1, CustAddr.PHONE2, CustAddr.PHONE3, CustAddr.FAX, CustAddr.SLPRSNID, CustAddr.SALSTERR, 
	CustAddr.USERDEF1, CustAddr.USERDEF2
FROM         %CompanyDBName%.dbo.RM00102 CustAddr
INNER JOIN %CompanyDBName%.dbo.RM00101 Cust ON Cust.CUSTNMBR = CustAddr.CUSTNMBR
LEFT OUTER JOIN DYNAMICS..ottDataMapping ParentStatus ON CustAddr.CUSTNMBR = ParentStatus.PrimaryKeyField1 
	AND ParentStatus.DataTypeID = ''CUST'' AND ParentStatus.INTERID = ''%CompanyDBName%''
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON CustAddr.CUSTNMBR = ottDataMapping.PrimaryKeyField1 
	AND CustAddr.ADRSCODE = ottDataMapping.PrimaryKeyField2 
	AND ottDataMapping.DataTypeID = ''CUSTADDR'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 1, 0, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[ottDataTypes] ([DataTypeID], [DataTypeName], [PhysicalDBView], [PrimaryKeyField1], [PrimaryKeyField2], [DescriptionField], [MasterTableName], [MappingForm], [DisplaySortOrder], [TotalToLink], [NumberLinked], [RemainingToLink], [AllowMerge], [GetNextIDType], [GetNextIDSprocName], [GetNextIDNextNumber], [ScriptLine], [Hidden], [LowercaseAllowed], [ParentDataTypeID], [KeyableLength], [CreateStoredProcName]) VALUES ('VENDADRALL', 'Vendor Addresses (All)', 'ott_vwDCVendorAddressesAllStatus', 'VENDORID', 'ADRSCODE', 'ADDRESS1', 'PM00300', NULL, 0.00, 0, 0, 0, 0, 0, NULL, NULL, 'SELECT     ''%CompanyDBName%'' AS DBName,  PM00300.VENDORID,  PM00300.ADRSCODE,
	DBStatus as DBType,
	CASE ottDataMapping.MappingType
		WHEN 1 THEN ''Keep''
		WHEN 2 THEN ''Merge''
		WHEN 3 THEN ''Ignore''
		else CASE ottCompanyInfo.DBStatus WHEN 2 THEN ''Master'' ELSE ''Unlinked'' END 
		END as LinkingStatus, 
	ISNULL(ParentStatus.ChildrenMapped,0) as ChildrenMapped,ISNULL(ParentStatus.MappingType,0) as ParentMappingType, 
ISNULL(ottDataMapping.MergeWithINTERID,'''') MergeWithINTERID, ISNULL(ottDataMapping.MergeWithPKField1,'''') MergeWithPKField1, ISNULL(ottDataMapping.MergeWithPKField2,'''') MergeWithPKField2,
ISNULL(ottDataMapping.NewPKField1,'''') NewPKField1, ISNULL(ottDataMapping.NewPKField2,'''') NewPKField2, 
PM00200.VENDNAME,  PM00300.VNDCNTCT,  PM00300.ADDRESS1,  PM00300.ADDRESS2,  PM00300.ADDRESS3,  PM00300.CITY,  PM00300.STATE,  PM00300.ZIPCODE,  PM00300.COUNTRY,  PM00300.UPSZONE,  PM00300.PHNUMBR1,  PM00300.PHNUMBR2, 
                       PM00300.PHONE3,  PM00300.FAXNUMBR,  PM00300.SHIPMTHD,  PM00300.TAXSCHID
FROM         %CompanyDBName%.dbo.PM00300 PM00300
INNER JOIN %CompanyDBName%.dbo.PM00200 PM00200 ON PM00200.VENDORID = PM00300.VENDORID
LEFT OUTER JOIN DYNAMICS..ottDataMapping ParentStatus ON PM00300.VENDORID = ParentStatus.PrimaryKeyField1 
	AND ParentStatus.DataTypeID = ''VEND'' AND ParentStatus.INTERID = ''%CompanyDBName%''
LEFT OUTER JOIN DYNAMICS..ottDataMapping ottDataMapping ON PM00300.VENDORID = ottDataMapping.PrimaryKeyField1 
	AND PM00300.ADRSCODE = ottDataMapping.PrimaryKeyField2
	AND ottDataMapping.DataTypeID = ''VENDADDR'' AND ottDataMapping.INTERID = ''%CompanyDBName%''
INNER JOIN ottCompanyInfo on ottCompanyInfo.INTERID=''%CompanyDBName%''

UNION ALL', 1, 0, NULL, NULL, NULL)
GO

