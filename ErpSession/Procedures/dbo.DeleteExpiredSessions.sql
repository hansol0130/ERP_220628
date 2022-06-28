USE [ErpSession]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

        CREATE PROCEDURE [dbo].[DeleteExpiredSessions]
        AS
            SET NOCOUNT ON
            SET DEADLOCK_PRIORITY LOW 

            DECLARE @now datetime
            SET @now = GETUTCDATE() 

            CREATE TABLE #tblExpiredSessions 
            ( 
                SessionId nvarchar(88) NOT NULL PRIMARY KEY
            )

            INSERT #tblExpiredSessions (SessionId)
                SELECT SessionId
                FROM [ErpSession].dbo.ASPStateTempSessions WITH (READUNCOMMITTED)
                WHERE Expires < @now

            IF @@ROWCOUNT <> 0 
            BEGIN 
                DECLARE ExpiredSessionCursor CURSOR LOCAL FORWARD_ONLY READ_ONLY
                FOR SELECT SessionId FROM #tblExpiredSessions 

                DECLARE @SessionId nvarchar(88)

                OPEN ExpiredSessionCursor

                FETCH NEXT FROM ExpiredSessionCursor INTO @SessionId

                WHILE @@FETCH_STATUS = 0 
                    BEGIN
                        DELETE FROM [ErpSession].dbo.ASPStateTempSessions WHERE SessionId = @SessionId AND Expires < @now
                        FETCH NEXT FROM ExpiredSessionCursor INTO @SessionId
                    END

                CLOSE ExpiredSessionCursor

                DEALLOCATE ExpiredSessionCursor

            END 

            DROP TABLE #tblExpiredSessions

        RETURN 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
GO
