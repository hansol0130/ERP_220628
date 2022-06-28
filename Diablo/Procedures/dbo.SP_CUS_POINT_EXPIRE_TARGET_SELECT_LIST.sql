USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================    
■ USP_NAME				: [dbo].[SP_CUS_POINT_EXPIRE_TARGET_SELECT_LIST]    
■ DESCRIPTION			: 포인트 소멸 대상 POINT_NO 조회 
■ INPUT PARAMETER		: 
■ OUTPUT PARAMETER		: 
■ EXEC					: 

	EXEC SP_CUS_POINT_EXPIRE_TARGET_SELECT_LIST  '2013-05-13'

■ MEMO					: PointExpireUpdate.exe 포인트 소멸 스케쥴 프로그램 에서 사용
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION               
------------------------------------------------------------------------------------------------------------------
	2010-05-13		박형만			신규 작성 
	2010-06-03		박형만			암호화 적용
	2010-12-08		김성호			회원테이블 분리
================================================================================================================*/
CREATE PROC [dbo].[SP_CUS_POINT_EXPIRE_TARGET_SELECT_LIST]
	@EXE_DATE VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT *
	FROM   (
	           SELECT CP.POINT_NO
	                 ,CP.POINT_PRICE - ISNULL(SUM(CPH.POINT_PRICE) ,0) AS POINT_PRICE
	                 ,CC.CUS_NO
	                 ,CP.START_DATE
	                 ,CP.END_DATE
	           FROM   CUS_POINT AS CP WITH(NOLOCK)
	                  INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK)
	                       ON  CP.CUS_NO = CC.CUS_NO
	                  LEFT JOIN CUS_POINT_HISTORY AS CPH WITH(NOLOCK)
	                       ON  CP.POINT_NO = CPH.ACC_POINT_NO
	           WHERE  END_DATE < CONVERT(DATETIME ,@EXE_DATE) -- 유효기간 지난것들만
	           GROUP BY
	                  CP.POINT_NO
	                 ,CP.POINT_PRICE
	                 ,CC.CUS_NO
	                 ,CP.START_DATE
	                 ,CP.END_DATE
	       ) TBL
	WHERE  POINT_PRICE > 0
END

GO
