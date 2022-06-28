USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
------ : secure_access$get_computed_info
--  -- : ------ ------ -------- ------ -------- ---- (sql 2005)
--  -- : 
		@i_owner : ------------ -- 
		@i_table_name : ------ (--------.------)
--  -- : ------ ------ -------- -------- ---- ------ nullable ------ ---- ---- --------


************** ---- ---- ******************
-------- : 
-------- :
------ : 
*/
create  procedure [dbo].[secure_access$get_computed_info]
@i_owner varchar(128),
@i_table_name varchar(300)
as

  declare 
		@sqlstmt nvarchar(4000), @err int


set @sqlstmt = N'select  c.name,case c.is_nullable when 1 then ''NULL'' else ''NOT NULL'' end
from '+quotename(@i_owner)+'.sys.columns c  join '+quotename(@i_owner)+'.sys.computed_columns  cc on cc.object_id = c.object_id  and charindex(''[''+c.name+'']'',cc.definition) >0 
where cc.object_id =  object_id(quotename(@i_owner)+''.''+@i_table_name)'

		exec @err = sp_executesql @sqlstmt
			,N'  @i_owner varchar(128), @i_table_name varchar(300)'
			, @i_owner,@i_table_name

GO
