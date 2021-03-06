/*The following script will show all old value, and new value combinations for a particular Datatype ID.
The ID mapping information will be put into a temp table called #NewIDsForAllDataTypes
drop table #NewIDsForAllDataTypes
*/
declare @DataTypeID varchar(10),
				@INTERID char(5),
				@PrimaryKeyField1 char(50),
				@PrimaryKeyField2 char(50),
				@NewPKField1 char(50),
				@NewPKField2 char(50),
				@tempSQL char(2000),
				@outErrStatus int,
				@outErrMsg char(255),
				@counter int,
				@KeyableLength int,
				@tempDataLength int

select @NewPKField2='',@NewPKField1='',@counter=1
set NOCOUNT ON
create table #NewCustIDs (DataTypeID varchar(10),INTERID char(5),OldPrimaryKey1 char(50),OldPrimaryKey2 char(50),NewPrimaryKey1 varchar(50),NewPrimaryKey2 varchar(50))

/*Insert all ignore record new ID values*/
INSERT INTO #NewCustIDs (DataTypeID,INTERID,OldPrimaryKey1,OldPrimaryKey2,NewPrimaryKey1,NewPrimaryKey2)          
select DataTypeID,INTERID,PrimaryKeyField1,PrimaryKeyField2,NewPKField1,NewPKField2 from DYNAMICS..ottDataMapping where MappingType=3 and DataTypeID = 'CUST'

/*The following will show you all the new ID's for all KEEP records.  This takes into account the merge records which will ultimately be changed to keep records*/
INSERT INTO #NewCustIDs (DataTypeID,INTERID,OldPrimaryKey1,OldPrimaryKey2,NewPrimaryKey1,NewPrimaryKey2)
select DataTypeID,INTERID,PrimaryKeyField1,PrimaryKeyField2,NewPrimaryKeyField1,NewPrimaryKeyField2 from (
	select DataTypeID,INTERID,PrimaryKeyField1,PrimaryKeyField2,case rtrim(NewPKField1) WHEN '' then PrimaryKeyField1 else NewPKField1 END NewPrimaryKeyField1,
	case rtrim(NewPKField2) WHEN '' then PrimaryKeyField2 else NewPKField2 END NewPrimaryKeyField2
	from DYNAMICS..ottDataMapping 
	where MappingType=1 AND DataTypeID = 'CUST'

	union all /*Take care of all merge records*/

	select a.DataTypeID,b.INTERID,b.PrimaryKeyField1 OldPrimaryKey1,b.PrimaryKeyField2 OldPrimaryKeyField2,
	case rtrim(a.NewPkField1) when '' then a.PrimaryKeyField1 else rtrim(a.NewPkField1) END NewPrimaryKey1,
	case rtrim(a.NewPkField2) when '' then a.PrimaryKeyField2 else rtrim(a.NewPkField2) END NewPrimaryKey2
	from DYNAMICS..ottDataMapping a LEFT OUTER JOIN DYNAMICS..ottDataMapping b on a.DataTypeID=b.DataTypeID and a.MappingType=1 and 
	a.PrimaryKeyField1=b.MergeWithPKField1 and a.PrimaryKeyField2=b.MergeWithPKField2 and a.INTERID=b.MergeWithINTERID
	where b.MappingType=2  AND a.DataTypeID = 'CUST'
) KeepAndMergeRecords 
GROUP BY DataTypeID,INTERID,PrimaryKeyField1,PrimaryKeyField2,NewPrimaryKeyField1,NewPrimaryKeyField2
having (PrimaryKeyField1 <> NewPrimaryKeyField1 or PrimaryKeyField2 <> NewPrimaryKeyField2)




-- ext_direct_dealer_ids
CREATE TABLE #GPtoServiceTraxOrgs(
	[organization_id] [numeric](19, 5) NOT NULL,
	[NewGPExtDealerID] [varchar](50) NULL,
 CONSTRAINT [PK_GPtoSTTranslateD] PRIMARY KEY CLUSTERED 
(
	[organization_id] ASC
) ON [PRIMARY]
) ON [PRIMARY]

INSERT INTO #GPtoServiceTraxOrgs(organization_id,NewGPExtDealerID)
SELECT organizations.organization_id, a.NewPrimaryKey1
FROM organizations
INNER JOIN (
	SELECT org.organization_id, b.OldPrimaryKey1, b.NewPrimaryKey1
	FROM #NewCustIDs b 
	INNER JOIN organizations org ON
		CASE b.INTERID
			WHEN 'AMBIM' THEN 'MKY'
			WHEN 'AMMAD' THEN 'WISC'
   			WHEN 'AIA' THEN 'AIA'
   			WHEN 'CIINC' THEN 'CIINC'
   			WHEN 'CILLC' THEN 'CILLC'
   			WHEN 'ICS' THEN 'ICS'
   			WHEN 'ECMS' THEN 'ECMS'
   			WHEN 'CIMN' THEN 'CIMN'
			ELSE '' END = org.code
) a ON organizations.organization_id = a.organization_id and organizations.ext_direct_dealer_id = a.OldPrimaryKey1
GROUP BY organizations.organization_id, a.NewPrimaryKey1
ORDER BY organizations.organization_id

--update the table 
	update organizations 
	SET organizations.ext_direct_dealer_id = map.NewGPExtDealerID
	FROM organizations
	INNER JOIN #GPtoServiceTraxOrgs map ON organizations.organization_id = map.organization_id


DELETE FROM #GPtoServiceTraxOrgs


-- ext_dci_dealer_id
INSERT INTO #GPtoServiceTraxOrgs(organization_id,NewGPExtDealerID)
SELECT organizations.organization_id, a.NewPrimaryKey1
FROM organizations
INNER JOIN (
	SELECT org.organization_id, b.OldPrimaryKey1, b.NewPrimaryKey1
	FROM #NewCustIDs b 
	INNER JOIN organizations org ON
		CASE b.INTERID
			WHEN 'AMBIM' THEN 'MKY'
			WHEN 'AMMAD' THEN 'WISC'
   			WHEN 'AIA' THEN 'AIA'
   			WHEN 'CIINC' THEN 'CIINC'
   			WHEN 'CILLC' THEN 'CILLC'
   			WHEN 'ICS' THEN 'ICS'
   			WHEN 'ECMS' THEN 'ECMS'
   			WHEN 'CIMN' THEN 'CIMN'
			ELSE '' END = org.code
) a ON organizations.organization_id = a.organization_id and organizations.ext_dci_dealer_id = a.OldPrimaryKey1
GROUP BY organizations.organization_id, a.NewPrimaryKey1
ORDER BY organizations.organization_id

--update the table 
	update organizations 
	SET organizations.ext_dci_dealer_id = map.NewGPExtDealerID
	FROM organizations
	INNER JOIN #GPtoServiceTraxOrgs map ON organizations.organization_id = map.organization_id



--CLEANUP
DROP TABLE #GPtoServiceTraxOrgs
DROP TABLE #NewCustIDs
