USE [WebSession]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*****************************************************************************/

CREATE PROCEDURE [dbo].[TempGetVersion]
    @ver      char(10) OUTPUT
AS
    SELECT @ver = "2"
    RETURN 0
GO
