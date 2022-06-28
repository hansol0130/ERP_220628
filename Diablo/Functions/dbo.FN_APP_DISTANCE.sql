USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  UserDefinedFunction [dbo].[FN_APP_DISTANCE]    Script Date: 2016-08-05 오후 6:46:09 ******/
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_APP_CALCDISTANCEKM
■ Description				: 자기 자신과 주변정류소의 거리위치를 Km 단위로 리턴합니다.
■ Input Parameter			:                  
	@lat1	FLOAT			: 파일코드
	@lat12	FLOAT			: 가져올 파일 수
	@lon1	FLOAT			: 구분자
	@lon2   FLOAT
■ Output Parameter			:                  
■ Output Value				: 
■ Exec						: 

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-08-05		김낙겸			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_APP_DISTANCE](@lat1 FLOAT, @lat2 FLOAT, @lon1 FLOAT, @lon2 FLOAT)
RETURNS FLOAT 
AS
BEGIN

    RETURN ACOS(SIN(PI()*@lat1/180.0)*SIN(PI()*@lat2/180.0)+COS(PI()*@lat1/180.0)*COS(PI()*@lat2/180.0)*COS(PI()*@lon2/180.0-PI()*@lon1/180.0))*6371
END
GO
