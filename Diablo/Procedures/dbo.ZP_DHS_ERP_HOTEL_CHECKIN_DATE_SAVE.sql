USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_ERP_HOTEL_CHECKIN_DATE_SAVE
■ DESCRIPTION					: 수정_홈쇼핑호텔_체크인날짜
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-24		오준혁			최초생성
   2022-02-10		오준혁			체크인 날짜 변경시 PRO_CODE 수정
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_ERP_HOTEL_CHECKIN_DATE_SAVE]
	 @RES_CODE     VARCHAR(12)
	,@DEP_DATE     DATETIME
	,@RES_ADD_YN   VARCHAR(1) OUTPUT
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- 변경되는 체크인 날짜가 예약이 가능한지 확인한다.
	DECLARE @SEARCH_WORD     VARCHAR(20)
		   ,@MASTER_CODE     VARCHAR(10)
		   ,@BIT_CODE        VARCHAR(4)
		   

	SELECT @MASTER_CODE = MASTER_CODE
	      ,@BIT_CODE = SUBSTRING(PRO_CODE, CHARINDEX('-', PRO_CODE)+7, LEN(PRO_CODE))
	FROM   dbo.RES_MASTER_damo
	WHERE  RES_CODE = @RES_CODE
	
	
	SET @SEARCH_WORD = (@MASTER_CODE + '-______' + @BIT_CODE)
	
	
	SELECT @RES_ADD_YN = (CASE 
	                           WHEN A.RES_ADD_YN = 'Y' AND A.MAX_COUNT > A.RES_COUNT THEN 'Y'
	                           ELSE 'N'
	                      END)
	FROM   (
			   SELECT PD.PRO_CODE
			         ,PD.DEP_DATE
			         ,ISNULL(MAX(PD.MAX_COUNT) ,0) AS MAX_COUNT
			         ,MAX(PD.RES_ADD_YN) AS RES_ADD_YN
			         ,ISNULL(COUNT(*) ,0) AS RES_COUNT
			   FROM   dbo.PKG_MASTER PM
			          INNER JOIN dbo.PKG_DETAIL PD
			               ON  PM.MASTER_CODE = PD.MASTER_CODE
			          LEFT JOIN dbo.RES_MASTER_damo RM
			               ON  PD.PRO_CODE = RM.PRO_CODE
			                   AND RM.RES_STATE < 7
			   WHERE  PM.MASTER_CODE = @MASTER_CODE
			          AND PD.DEP_DATE >= @DEP_DATE
			          AND PD.DEP_DATE < DATEADD(DAY ,1 ,@DEP_DATE)
			          AND PD.PRO_CODE LIKE @SEARCH_WORD
			   GROUP BY
			          PD.PRO_CODE
			         ,PD.DEP_DATE
		   ) A
			         
	
	-- 예약이 불가능 할 경우
	IF ISNULL(@RES_ADD_YN,'N') = 'N' 
	BEGIN
		
		SET @RES_ADD_YN = ISNULL(@RES_ADD_YN,'N')
		
		RETURN 
		
	END
	
	
	


	-- 새로운 행사 코드
	DECLARE @NEW_PRO_CODE VARCHAR(20)
	
	SELECT @NEW_PRO_CODE = MASTER_CODE + '-' + FORMAT(@DEP_DATE, 'yyMMdd') + SUBSTRING(PRO_CODE, CHARINDEX('-', PRO_CODE)+7, LEN(PRO_CODE))
	FROM   dbo.RES_MASTER_damo
	WHERE  RES_CODE = @RES_CODE		

	-- 예약테이블
	UPDATE dbo.RES_MASTER_damo
	SET    DEP_DATE = @DEP_DATE
	      ,PRO_CODE = @NEW_PRO_CODE
	WHERE  RES_CODE = @RES_CODE
	
	
END
GO
