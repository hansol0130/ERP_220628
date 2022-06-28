USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_CUS_POINT_REFUND_LIST
- 기 능 : ERP 포인트 환불 신청 시 내역 조회
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC SP_CUS_POINT_REFUND_LIST @CUS_NO=4153295, @RES_CODE='RP1004056858'
====================================================================================
	변경내역
====================================================================================
- 2010-05-07 신규 작성 
- 2010-06-03 박형만 암호화 적용
- 2010-06-28 박형만 버그수정(CP.POINT_PRICE->CPH.POINT_PRICE)
- 2010-12-09 김성호	회원테이블 분리
- 2011-12-07 박형만	CUS_POINT_HISTORY 테이블 LEFT JOIN  ->  INNER JOIN 
===================================================================================*/
CREATE PROC [dbo].[SP_CUS_POINT_REFUND_LIST]
	@CUS_NO  INT ,
	@RES_CODE RES_CODE 
AS

--DECLARE @CUS_NO  INT ,
--	@RES_CODE RES_CODE 
--SELECT @CUS_NO =3951285	, @RES_CODE = 'RP1108222264'

SELECT * FROM 
( 
SELECT 
	CP.CUS_NO , 
	CC.CUS_NAME ,
	CP.RES_CODE , 
	CP.POINT_NO , --사용 POINT_NO
	CP.NEW_DATE ,
	CPUSE.END_DATE , --적립포인트의 유효기간
	CPH.POINT_PRICE ,  --결제사용 포인트 
	CPH.POINT_PRICE AS RFD_POINT_PRICE,   --환불가능 포인트
	--CASE 2 . 유효기간지난것은 0 으로 표시 = 원안
	--CASE WHEN CPUSE.END_DATE > '2013-05-17' THEN  0  ELSE CP.POINT_PRICE - SUM(ISNULL(RFD_POINT_PRICE,0))  END  AS RFD_POINT_PRICE,   --유효기간지난포인트
	RM.PRO_NAME ,
	CPUSE.POINT_NO AS USE_POINT
FROM CUS_POINT_HISTORY AS CPH WITH(NOLOCK)
	INNER JOIN 	CUS_POINT AS CP WITH(NOLOCK) --사용포인트
		ON CP.POINT_NO = CPH.POINT_NO 
		AND CP.IS_CXL = 0 
	LEFT JOIN RES_MASTER_damo AS RM WITH(NOLOCK)
		ON CP.RES_CODE = RM.RES_CODE 		
	LEFT JOIN CUS_MEMBER AS CC WITH(NOLOCK)
		ON CP.CUS_NO = CC.CUS_NO 
	LEFT JOIN CUS_POINT AS CPUSE WITH(NOLOCK) --적립된 포인트
		ON CPUSE.POINT_NO = CPH.ACC_POINT_NO 
		
WHERE  CP.POINT_TYPE = 2  
AND CP.CUS_NO = @CUS_NO
AND CP.RES_CODE =  @RES_CODE 
GROUP BY CP.CUS_NO  ,CC.CUS_NAME , CP.RES_CODE ,  CP.POINT_NO , CP.NEW_DATE  , CPUSE.END_DATE  , CPH.POINT_PRICE , RM.PRO_NAME , CPUSE.POINT_NO
) TBL 
--WHERE RFD_POINT_PRICE > 0 
ORDER BY END_DATE ASC , NEW_DATE ASC


GO
