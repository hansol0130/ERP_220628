USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  function [dbo].[get_varchar2_value_from_array]
	(@name varchar(8000)
	, @index int)
returns varchar(8000)
begin
declare @col_tmp varchar(8000), @col_out varchar(8000), @i int, @col_cnt int


if charindex(',',@name) = 0 
	return @name


set @col_tmp = @name
set @col_cnt = 1
while (charindex(',',@col_tmp) > 0 )
begin
-- 	if  charindex(',',@col_tmp) = 0 
-- 		break

	set @col_tmp = substring (@col_tmp
				, charindex(',',@col_tmp)+1
				, len(@col_tmp)- charindex(',',@col_tmp) )

	set @col_cnt = @col_cnt + 1
end

if (@col_cnt < @index )
return 'there is no data with match'


set @i = 0

while (@i <= @index-1)
begin

	if  charindex(',',@name) = 0 
		return @name

	set @col_out = substring (@name, 1, charindex(',', @name)-1)

	set @name = substring (@name
				, charindex(',',@name)+1
				, len(@name)- charindex(',',@name) )

	set @i = @i + 1
end

return @col_out
end

GO
