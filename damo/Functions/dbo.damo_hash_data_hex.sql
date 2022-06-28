USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create function [dbo].[damo_hash_data_hex]
( 
	  @inData varchar(256) 
	, @inAlgo varchar(256) 
) 
returns varchar(128) 
as 
begin 
	declare  
		 @ret int 
		,@out varchar(128) 
		,@hashMode varchar(2) 
 
	select  
		@ret = 1, 
		@out = NULL	 
	 
	if ( @inAlgo = 'HAS160' ) 
	  select @hashMode = '1' 
	else if ( @inAlgo = 'SHA1' ) 
	  select @hashMode = '2' 
	else if ( @inAlgo = 'SHA256' ) 
	  select @hashMode = '3' 
	else if ( @inAlgo = 'SHA512' ) 
	  select @hashMode = '4' 
	else 
	  return NULL 
	if ( @inData is NULL ) 
		set @out = NULL 
	else 
	begin 
		exec @ret = master..xp_P5_HashStringHex @out output, @inData, @hashMode 
		if ( @ret <> 0 ) 
			set @out = NULL 
	end 
	 
	return @out 
end 
GO
