USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_MASTER_ARRANGE_LIST
■ DESCRIPTION				: 출장예약 출발하지 않은 출장예약건
■ INPUT PARAMETER			: 
	XP_COM_BIZTRIP_MASTER_ARRANGE_LIST '93881',104
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-03		박형만			최초생성    
   2016-03-08		박형만			출장별로 그룹핑
   2016-03-17		박형만			emp_seq 추가 
   2016-03-30		박형만			승인완료된 출장예약은 안나오도록 
   2016-04-21		박형만			출장예약 기타예약건수 추가 
   2016-05-10		김성호			BT_STATE 삭제
   2016-05-13		박형만			BT_CODE 가 있을경우 BT코드만 나오기 
   2016-05-13		박형만			로그인한 사람(예약자)기준 승인필요없는 사람은 출장대기,요청,확정나오기 ,, 승인필요한 사람은  출장대기만 나오기 
   2016-09-28		박형만			출장일 +5일 이후 출발건 부터나오던것을 +1일 이후출발건으로 변경 
   2016-10-31		이유라			전체 취소된 출장건은 제외 조건 추가
   2016-11-01		이유라			BT_CODE 여부와 상관없이 추가 가능한 출장리스트 나열하도록 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_MASTER_ARRANGE_LIST]
(
	@AGT_CODE VARCHAR(10) ,
	@EMP_SEQ INT = 0 --로그인한 사람 
) 
AS 
BEGIN
	DECLARE @CONFIRM_YN CHAR(1)
	SET @CONFIRM_YN =  
		ISNULL((SELECT TOP 1 B.CONFIRM_YN  FROM DBO.FN_COM_BIZTRIP_GROUP_INFO(@AGT_CODE, @EMP_SEQ) A 
			INNER JOIN COM_BIZTRIP_GROUP B ON A.BT_SEQ = B.BT_SEQ AND A.AGT_CODE = B.AGT_CODE 
		ORDER BY A.ORDER_NUM),'N')  -- 사용되는 규정이 없으면 전부 승인 필요없음 

	
	-- 출장코드별 
	-- 예약 전체 

	--SELECT 
	--*
	--FROM 
	--(
		SELECT T.BT_CODE ,
			T.PRO_CODE ,
			APPROVAL_STATE,
			BT_START_DATE,
			BT_END_DATE,
			BT_CITY_CODE,
			(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = BT_CITY_CODE) AS BT_CITY_NAME , 
			DATEDIFF(DD, MIN(BT_START_DATE), ISNULL(MAX(BT_END_DATE),BT_END_DATE)) + 1 AS DAYS,
			SUM(CASE WHEN PRO_DETAIL_TYPE = 2 THEN 1 ELSE 0 END) AS AIR_CNT ,
			SUM(CASE WHEN PRO_DETAIL_TYPE = 3 THEN 1 ELSE 0 END) AS HTL_CNT ,
			SUM(CASE WHEN PRO_DETAIL_TYPE IN (4,5,9) THEN 1 ELSE 0 END) AS ETC_CNT  
		FROM 
		(
			SELECT A.BT_CODE , A.PRO_CODE ,  A.BT_CITY_CODE , A.APPROVAL_STATE,  A.NEW_DATE , BT_START_DATE , BT_END_DATE , 
				B.RES_CODE , B.BT_RES_SEQ , B.PRO_DETAIL_TYPE, C.RES_STATE 
			FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)  
				LEFT JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_CODE = B.BT_CODE 
				LEFT JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE AND C.RES_STATE NOT IN (7,8,9) 
				LEFT JOIN RES_AIR_DETAIL D WITH(NOLOCK) ON C.RES_CODE = D.RES_CODE 
				LEFT JOIN RES_HTL_ROOM_MASTER E WITH(NOLOCK) ON C.RES_CODE = E.RES_CODE 
			WHERE A.AGT_CODE = @AGT_CODE
			AND A.BT_START_DATE > GETDATE() -- 출발하지 않은
			--AND A.BT_STATE IN (0,1,2) -- 출장요청 = 0, 출장확정 = 1, 출장중 = 2, 출장완료 = 3, 환불 = 8, 취소 = 9
			-- 출장대기 = 0, 출장요청 = 1, 출장확정 = 2, 출장반려 = 9
			AND (( @CONFIRM_YN = 'N' AND A.APPROVAL_STATE IN (0,1,2) ) -- 출장대기,요청,확정   출장대기 = 0, 출장요청 = 1, 출장확정 = 2, 출장반려 = 9
				OR ( @CONFIRM_YN = 'Y' AND A.APPROVAL_STATE IN (0) )) -- 출장대기만   출장대기 = 0, 출장요청 = 1, 출장확정 = 2, 출장반려 = 9
			--AND A.BT_START_DATE >  DATEADD(DD,5,GETDATE())  --5일 이후 출발 건만
			AND A.BT_START_DATE >=  DATEADD(DD,1,CONVERT(VARCHAR(10),GETDATE(),121))  --현재일 +1일 뒤 출발건 부터
			AND A.NEW_SEQ = @EMP_SEQ  
			AND C.RES_STATE IS NOT NULL --전체 취소된 출장건은 제외 조건 추가

			--OR A.BT_CODE = @BT_CODE 
		) T 
		GROUP BY T.BT_CODE , T.PRO_CODE , BT_END_DATE , 
			BT_CITY_CODE,
			APPROVAL_STATE,
			BT_START_DATE,
			BT_END_DATE
	
		ORDER BY BT_START_DATE ASC 

	--) TT 
	--WHERE  BT_START_DATE IS NOT NULL 
	--AND BT_START_DATE > GETDATE() -- 출발하지 않은 조건 한번더 구함
	--ORDER BY BT_START_DATE ASC 
END 
GO
