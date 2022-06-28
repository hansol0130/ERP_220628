USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  function [dbo].[get_value_from_array]
	(@name varchar(max)
	, @index int
	, @flag  varchar(8)
	)
returns varchar(8000)
begin
declare @col_tmp varchar(max), @col_out varchar(8000), @i int, @col_cnt int

if @flag = ''
	return @name
	
if charindex(@flag,@name) = 0 
	return @name

set @col_tmp = @name
set @col_cnt = 1
while (charindex(@flag,@col_tmp) > 0 )
begin
	set @col_tmp = substring (@col_tmp
				, charindex(@flag,@col_tmp)+1
				, len(@col_tmp)- charindex(@flag,@col_tmp) )

	set @col_cnt = @col_cnt + 1
end

if (@col_cnt < @index )
return 'there is no data with match'


set @i = 0

while (@i <= @index-1)
begin

	if  charindex(@flag,@name) = 0 
		return @name

	set @col_out = substring (@name, 1, charindex(@flag, @name)-1)

	set @name = substring (@name
				, charindex(@flag,@name)+1
				, len(@name)- charindex(@flag,@name) )

	set @i = @i + 1
end

return @col_out
end

GO
