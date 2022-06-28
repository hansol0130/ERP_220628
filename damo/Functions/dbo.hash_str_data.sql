USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create function [dbo].[hash_str_data]
( 
	@inData varchar(256) 
) 
returns varchar(128) 
as 
begin 
	declare  
		 @ret int 
		,@out varchar(128) 
 
	select  
		@ret = 1, 
		@out = NULL	 
	 
	if ( @inData is NULL ) 
		set @out = NULL 
	else 
	begin 
		exec @ret = master..xp_P5_HashString @out output, @inData, '3' 
		if ( @ret <> 0 ) 
			set @out = NULL 
	end 
	 
	return @out 
end 
GO
