USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		김성호
-- Create date: 2011-08-17
-- Description:	호텔 자동취소를 위한 조건 검색
-- History 
-- 2011-08-17 : 최초생성
-- =============================================
CREATE PROCEDURE [dbo].[SP_HTL_COM_HOTEL_AUTO_CANCEL]
	@START_DATE	DATETIME,
	@END_DATE	DATETIME
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

--set @start_date = '2011-12-03'
--set @end_date = '2011-12-04'

-- LAST_CXL_DATE 취소 수수료가 발생하지 않는 마지막 시각
SELECT --B.LAST_CXL_DATE, a.res_state, a.new_date,
	A.RES_CODE, A.PRO_CODE, A.PRO_NAME, B.SUP_CODE, B.SUP_RES_CODE, A.CUS_NO, C.CUS_NAME
	, C.EMAIL, C.NOR_TEL1, C.NOR_TEL2, C.NOR_TEL3
	, DBO.FN_RES_GET_PAY_PRICE(A.MASTER_CODE) AS [PAY_PRICE]
FROM RES_MASTER A
INNER JOIN RES_HTL_ROOM_MASTER B ON A.RES_CODE = B.RES_CODE
LEFT JOIN CUS_CUSTOMER_DAMO C ON A.CUS_NO = C.CUS_NO
WHERE A.RES_STATE <= 7 AND B.LAST_CXL_DATE >= @START_DATE AND B.LAST_CXL_DATE < @END_DATE
AND (
	SELECT ISNULL(SUM(AA.PART_PRICE), 0)
	FROM PAY_MATCHING AA WITH(NOLOCK)
	INNER JOIN PAY_MASTER BB ON AA.PAY_SEQ = BB.PAY_SEQ
	WHERE AA.RES_CODE = A.RES_CODE AND AA.CXL_YN = 'N' AND BB.PAY_TYPE <> 7
) = 0

END

GO
