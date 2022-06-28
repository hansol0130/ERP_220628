USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name			: XN_APP_PKG_USE_YN 
■ Description				: 스마트케어 대상행사 여부 
■ Input Parameter			:           
		@RES_CODE
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
SELECT DBO.XN_APP_PKG_USE_YN('AFF158-160814CX',2)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-09-05		박형만			최초생성 
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_APP_PKG_USE_YN]
(	
	@PRO_CODE	PRO_CODE ,
	@PRO_TYPE	INT 
)
RETURNS VARCHAR(1)
AS 
BEGIN
RETURN 
	ISNULL((SELECT TOP 1  --A.PRO_TYPE , C.SIGN_CODE , C.ATT_CODE , B.TRANSFER_TYPE  
		CASE WHEN  (@PRO_TYPE = 1 AND B.TRANSFER_TYPE = 1) -- [교통편] 패키지=항공편
				OR (@PRO_TYPE = 2 AND B.TRANSFER_TYPE IN(1,3))  --	항공=항공편,기타
			AND C.ATT_CODE IN ('P','R','W','G')	--[마스터 대표속성] 패키지,실시간항공,허니문,골프
			AND C.SIGN_CODE <> 'K'	--[국내해외여부] 해외
			--AND A.RES_STATE >= 2 AND A.RES_STATE < 7 --[예약상태] 예약확정~ 출발완료 까지
		THEN 'Y' ELSE 'N' END AS RES_PKG_YN 
	FROM PKG_DETAIL B WITH(NOLOCK)
		INNER JOIN PKG_MASTER C WITH(NOLOCK)
			ON B.MASTER_CODE = C.MASTER_CODE
	WHERE B.PRO_CODE = @PRO_CODE ) ,'N')
END 
GO
