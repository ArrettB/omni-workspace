/****** Object:  StoredProcedure [dbo].[getNextVal]    Script Date: 05/03/2010 14:18:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*  used to return next_val of sequence, and increment next_val by 1 */
CREATE procedure [dbo].[getNextVal] 
	@@seq_name varchar(50),
	@@seq_num numeric OUTPUT
as
begin transaction
	select @@seq_num = next_val from dbo.sequences
		where seq_name = @@seq_name;
	update dbo.sequences set next_val = (@@seq_num+1)
		where seq_name = @@seq_name;
	commit
GO
