USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PRoc [dbo].[SP_FAX_RECIEVE_UPDATE_WITHOUT_GROUP]
AS
SET NOCOUNT ON

DECLARE cursor_fax CURSOR FAST_FORWARD
FOR
select distinct PUB_VALUE, PUB_VALUE2 from cod_public where pub_type = 'FAX.TEAM'

OPEN cursor_fax

DECLARE @VALUE VARCHAR(100)
declare @VALUE2 varchar(100)
declare @query varchar(500)

FETCH NEXT FROM cursor_fax INTO @VALUE, @VALUE2

WHILE @@FETCH_STATUS = 0
BEGIN

SET @VALUE = Replace(@VALUE, '-', '')

SET @query = 'UPDATE fax_master ' 
SET @query = @query + ' SET FAX_GROUP = ' + @VALUE2
SET @query = @query + ' where fax_type = 2  and fax_group = 0 And PATINDEX(''%'+ @VALUE +'%'', Subject) > 0'
--print @query
exec(@query)

SET @query = 'SELECT * from fax_master ' 
SET @query = @query + ' where fax_type = 2  and fax_group = 0 And PATINDEX(''%'+ @VALUE +'%'', Subject) > 0'
--print (@query)
--exec(@query)

FETCH NEXT FROM cursor_fax INTO @VALUE, @VALUE2
END

CLOSE cursor_fax
DEALLOCATE cursor_fax

GO
