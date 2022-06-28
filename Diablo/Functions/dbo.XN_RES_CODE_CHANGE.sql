USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_RES_CODE_CHANGE
■ Description				: 단축URL을 위한 예약코드 MIX
■ Input Parameter			:                  
		@CODE				: 예약코드/믹스코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.XN_RES_CODE_CHANGE('RP2201170524');
	
	SELECT DBO.XN_RES_CODE_CHANGE('17052201641');
	
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2022-01-20		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_RES_CODE_CHANGE]
(
	@CODE VARCHAR(20)
)
RETURNS VARCHAR(20)
AS

BEGIN
	RETURN(
	    SELECT CASE 
	                WHEN LEFT(@CODE ,1) = 'R' THEN (
	                         SELECT SUBSTRING(@CODE ,7 ,4) + SUBSTRING(@CODE ,3 ,4) + CONVERT(CHAR(1) ,RIGHT((CONVERT(INT ,SUBSTRING(@CODE ,11 ,1)) + CONVERT(INT ,SUBSTRING(@CODE ,12 ,1))) ,1)) + SUBSTRING(@CODE ,12 ,1) + (CASE SUBSTRING(@CODE ,2 ,1) WHEN 'T' THEN '2' WHEN 'H' THEN '3' ELSE '1' END)
	                     )
	                ELSE (
	                         SELECT (CASE SUBSTRING(@CODE ,11 ,1) WHEN '2' THEN 'RT' WHEN '3' THEN 'RH' ELSE 'RP' END) + SUBSTRING(@CODE ,5 ,4) + SUBSTRING(@CODE ,1 ,4) + RIGHT(CONVERT(INT ,('1' + SUBSTRING(@CODE ,9 ,1))) -CONVERT(INT ,SUBSTRING(@CODE ,10 ,1)) ,1) + SUBSTRING(@CODE ,10 ,1)
	                     )
	           END
	)
END
GO
