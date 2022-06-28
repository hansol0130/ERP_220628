USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_XML_SPLIT
■ Description				: 대용량 자르기 구분값용 테이블 함수
■ Input Parameter			:                  
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
2014-08-05			정지용			최초생성  
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_XML_SPLIT] (
	@RowData NVARCHAR(MAX),
	@Delimeter NVARCHAR(1)
)
RETURNS @RtnValue TABLE 
(
	ID INT IDENTITY(1,1),
	Data NVARCHAR(MAX) NOT NULL
)
AS
BEGIN
  DECLARE @XMLSTRING XML;
 
  SET @XMLSTRING = CAST(N'<X>'+REPLACE(@RowData, @Delimeter, N'</X><X>')+N'</X>' AS xml);
 
  INSERT @RtnValue (Data)
  SELECT Data = LTRIM(RTRIM(N.value(N'.', 'NVARCHAR(MAX)'))) FROM @XMLSTRING.nodes(N'X') AS T(N)
  RETURN;
END

GO
