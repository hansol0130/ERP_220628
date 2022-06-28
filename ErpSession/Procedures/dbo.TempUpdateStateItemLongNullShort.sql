USE [ErpSession]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

        CREATE PROCEDURE [dbo].[TempUpdateStateItemLongNullShort]
            @id         tSessionId,
            @itemLong   tSessionItemLong,
            @timeout    int,
            @lockCookie int
        AS    
            UPDATE [ErpSession].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, @timeout, GETUTCDATE()), 
                SessionItemLong = @itemLong, 
                SessionItemShort = NULL,
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
GO
