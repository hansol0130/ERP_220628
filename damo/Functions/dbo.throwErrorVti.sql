USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[throwErrorVti](@functioname varchar(1000), @owner varchar(256), @table varchar(512), @column varchar(256), @indata varchar(8000), @msg varchar(2000), @flag varchar(10))
returns int
as
begin
    declare @encode varchar(10)
    declare @tmpMsg varchar(4000)
    declare @errMsg varchar(4000)
    
    select @encode = value
      from damo.dbo.secure_cfg
      where parameter = 'ENCODE_TYPE'

    if CHARINDEX ( '353', @msg ) > 0 
      select @tmpMsg = REPLACE (@msg, '353', ' 353 - INVALID INPUT : OUT OF DATASET ')
    else if CHARINDEX ( '354', @msg ) > 0
      select @tmpMsg = REPLACE (@msg, '354', ' 354 - INVALID INPUT : MISSING REPLACE CHARACTERS ')
    else if CHARINDEX ( '355', @msg ) > 0 
      select @tmpMsg = REPLACE (@msg, '355', ' 355 - INVALID INPUT : REPLACE RESULT CHARACTERS EXIST ')
    else if CHARINDEX ( '366', @msg ) > 0
      select @tmpMsg = REPLACE (@msg, '366', ' 366 - INVALID INPUT : WRONG REPLACE CHARACTERS ORDER ')
    else
      select @tmpMsg = @msg
      
    if(@encode = 'RAW' and @flag = 'DEC')
      select @errMsg = @functioname + '('+ ''''+ @owner +''', '''+ @table +''', '''+ @column +''',  ''0x'+ @indata + ''') : ' + @tmpMsg 
    else
      select @errMsg = @functioname + '('+ ''''+ @owner +''', '''+ @table +''', '''+ @column +''', '''+ @indata + ''') : ' + @tmpMsg 

    return cast(@errMsg as int);
end
GO
