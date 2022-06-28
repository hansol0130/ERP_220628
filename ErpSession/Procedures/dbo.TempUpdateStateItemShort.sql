USE [ErpSession]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

        CREATE PROCEDURE [dbo].[TempUpdateStateItemShort]
            @id         tSessionId,
            @itemShort  tSessionItemShort,
            @timeout    int,
            @lockCookie int
        AS    
            UPDATE [ErpSession].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, @timeout, GETUTCDATE()), 
                SessionItemShort = @itemShort, 
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
GO
