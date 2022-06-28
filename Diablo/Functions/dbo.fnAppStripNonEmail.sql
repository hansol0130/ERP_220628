USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[fnAppStripNonEmail](@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^a-z,0-9,@,.,-]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')

    Return @Temp
End
GO
