USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[throwError](@msg varchar(4000))
returns int
as
begin
    return cast(@msg as int);
end
GO
